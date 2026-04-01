import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/portfolio_form_data.dart';
import '../../../../core/network/market_data_service.dart';
import '../../../../core/services/log/talker_provider.dart';
import '../../data/portfolio_provider.dart';
import 'additional_data_step_screen.dart';
import 'registered_name_step_screen.dart';
import 'wizard_bottom_actions.dart';

class MarketsStepScreen extends ConsumerStatefulWidget {
  final IsinFormData formData;
  final bool isEditing;
  final bool isEntryPoint;

  const MarketsStepScreen({
    super.key,
    required this.formData,
    this.isEditing = false,
    this.isEntryPoint = false,
  });

  @override
  ConsumerState<MarketsStepScreen> createState() => _MarketsStepScreenState();
}

class _MarketsStepScreenState extends ConsumerState<MarketsStepScreen> {
  bool _isLoading = false;
  List<dynamic> _searchResults = [];

  // Track which symbols came from ISIN search directly
  final Set<String> _isinDirectSymbols = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchMarkets();
    });
  }

  Future<void> _handleBackNavigation(bool didPop) async {
    if (didPop) return;
    await _cancelWizard();
  }

  Future<void> _cancelWizard() async {
    final shouldCancel = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Operation?'),
        content: const Text(
          'Are you sure you want to cancel? All progress will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (shouldCancel == true) {
      if (context.mounted) {
        if (widget.isEditing) {
          Navigator.of(context).pop('CANCEL');
        } else {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      }
    }
  }

  Future<void> _searchMarkets() async {
    setState(() {
      _isLoading = true;
      _searchResults = [];
      _isinDirectSymbols.clear();
    });

    try {
      final marketService = ref.read(marketDataServiceProvider);

      // 1) Search by ISIN directly
      List<dynamic> isinQuotes = [];
      if (widget.formData.isinCode.isNotEmpty) {
        isinQuotes = await marketService.searchSymbol(widget.formData.isinCode);
        for (final q in isinQuotes) {
          if (q['symbol'] != null) {
            _isinDirectSymbols.add(q['symbol'].toString());
          }
        }
      }

      // 2) Search by Alternative Name
      List<dynamic> altNameQuotes = [];
      if (widget.formData.altName.isNotEmpty) {
        altNameQuotes =
            await marketService.searchSymbol(widget.formData.altName);
      }

      // 3) Search by each selected Registered Name
      List<dynamic> registeredNamesQuotes = [];
      for (final rn in widget.formData.registeredNames) {
        if (rn.isNotEmpty) {
          final res = await marketService.searchSymbol(rn);
          registeredNamesQuotes.addAll(res);
        }
      }

      // Merge and deduplicate by symbol
      final Map<String, dynamic> mergedResultsMap = {};
      final allQuotes = [
        ...isinQuotes,
        ...altNameQuotes,
        ...registeredNamesQuotes,
      ];

      for (final q in allQuotes) {
        final symbol = q['symbol'];
        if (symbol != null && !mergedResultsMap.containsKey(symbol)) {
          mergedResultsMap[symbol.toString()] = q;
        }
      }

      // Include any previously added tickers that might not have been found by the search
      for (final ticker in widget.formData.tickers) {
        if (!mergedResultsMap.containsKey(ticker.symbol)) {
          mergedResultsMap[ticker.symbol] = {
            'symbol': ticker.symbol,
            'shortname': ticker.symbol,
            'exchange': ticker.exchange,
            'exchDisp': ticker.exchange,
            'currency': ticker.currency,
            'quoteType': ticker.quoteType,
            'regularMarketStart': ticker.regularMarketStart,
            'regularMarketEnd': ticker.regularMarketEnd,
            'preMarketStart': ticker.preMarketStart,
            'preMarketEnd': ticker.preMarketEnd,
            'postMarketStart': ticker.postMarketStart,
            'postMarketEnd': ticker.postMarketEnd,
          };
        }
      }

      final List<dynamic> mergedResults = mergedResultsMap.values.toList();

      if (mergedResults.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'No markets found automatically. You can add them manually.',
              ),
            ),
          );
          setState(() {
            _isLoading = false;
          });
        }
        return;
      }

      // Asynchronously fetch chart data to populate additional properties BEFORE updating state
      await _fetchChartDataForResults(mergedResults);
    } catch (e, stack) {
      if (mounted) {
        ref.read(talkerProvider).handle(e, stack, 'Error searching markets');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error searching markets: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchChartDataForResults(List<dynamic> results) async {
    final marketService = ref.read(marketDataServiceProvider);

    // Create a copy to update safely
    final List<dynamic> updatedResults = List.from(results);

    for (int i = 0; i < updatedResults.length; i++) {
      final q = updatedResults[i];
      final symbol = q['symbol'];

      if (symbol != null) {
        try {
          // Fetch 1d interval, 1d range for basic metadata
          final chartData = await marketService.fetchHistoricalData(
              symbol.toString(), '1d', '1d');

          if (chartData != null) {
            final meta = chartData['meta'];
            if (meta != null) {
              // We create a mutable map for the UI state
              final Map<String, dynamic> mutableQ =
                  Map<String, dynamic>.from(q);

              mutableQ['currency'] = meta['currency'];

              final tradingPeriods = meta['currentTradingPeriod'];
              if (tradingPeriods != null) {
                mutableQ['preMarketStart'] = tradingPeriods['pre']?['start'];
                mutableQ['preMarketEnd'] = tradingPeriods['pre']?['end'];
                mutableQ['regularMarketStart'] =
                    tradingPeriods['regular']?['start'];
                mutableQ['regularMarketEnd'] =
                    tradingPeriods['regular']?['end'];
                mutableQ['postMarketStart'] = tradingPeriods['post']?['start'];
                mutableQ['postMarketEnd'] = tradingPeriods['post']?['end'];
                mutableQ['gmtoffset'] = meta['gmtoffset'];
              }

              updatedResults[i] = mutableQ;
            }
          }
        } catch (e) {
          // It's common for some obscure symbols to fail chart data fetch. We just ignore and move on.
        }
      }
    }

    if (mounted) {
      setState(() {
        _searchResults = updatedResults;
        _isLoading = false;
      });
    }
  }

  void _toggleMarketSelection(dynamic q, bool? isSelected) {
    if (isSelected == true) {
      _addMarketFromSearch(q, showSnackbar: false);
    } else {
      final symbol = q['symbol'];
      if (symbol != null) {
        setState(() {
          widget.formData.tickers.removeWhere((t) => t.symbol == symbol);
        });
      }
    }
  }

  void _addMarketFromSearch(dynamic q, {bool showSnackbar = true}) {
    final exchange = q['exchDisp'] ?? q['exchange'] ?? 'Unknown';
    final symbol = q['symbol'] ?? 'Unknown';
    final quoteType = q['quoteType'];
    final currency = q['currency'];
    final regularMarketStart = q['regularMarketStart'];
    final regularMarketEnd = q['regularMarketEnd'];
    final preMarketStart = q['preMarketStart'];
    final preMarketEnd = q['preMarketEnd'];
    final postMarketStart = q['postMarketStart'];
    final postMarketEnd = q['postMarketEnd'];

    setState(() {
      // Avoid duplicates if possible
      if (!widget.formData.tickers.any((t) => t.symbol == symbol)) {
        widget.formData.tickers.add(
          TickerFormData(
            symbol: symbol,
            exchange: exchange,
            currency: currency,
            quoteType: quoteType,
            regularMarketStart:
                regularMarketStart is int ? regularMarketStart : null,
            regularMarketEnd: regularMarketEnd is int ? regularMarketEnd : null,
            preMarketStart: preMarketStart is int ? preMarketStart : null,
            preMarketEnd: preMarketEnd is int ? preMarketEnd : null,
            postMarketStart: postMarketStart is int ? postMarketStart : null,
            postMarketEnd: postMarketEnd is int ? postMarketEnd : null,
          ),
        );
        if (showSnackbar) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Added market: $symbol'),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      } else if (showSnackbar) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Market $symbol is already in the list.'),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    });
  }

  Future<void> _showAddMarketDialog() async {
    final symbolController = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Market Manually'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: symbolController,
                decoration: const InputDecoration(
                  labelText: 'Symbol (e.g., AAPL)',
                ),
                autofocus: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, symbolController.text),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    if (result != null && result.trim().isNotEmpty) {
      final symbol = result.trim();

      setState(() {
        _isLoading = true;
      });

      try {
        final marketService = ref.read(marketDataServiceProvider);
        final searchResults = await marketService.searchSymbol(symbol);

        dynamic foundQuote;
        for (final q in searchResults) {
          if (q['symbol'] == symbol) {
            foundQuote = q;
            break;
          }
        }

        if (foundQuote == null && searchResults.isNotEmpty) {
          foundQuote = searchResults.first;
        }

        if (foundQuote != null) {
          final chartData = await marketService.fetchHistoricalData(
              foundQuote['symbol'].toString(), '1d', '1d');

          if (chartData != null) {
            final meta = chartData['meta'];
            if (meta != null) {
              foundQuote['currency'] = meta['currency'];

              final tradingPeriods = meta['currentTradingPeriod'];
              if (tradingPeriods != null) {
                foundQuote['preMarketStart'] = tradingPeriods['pre']?['start'];
                foundQuote['preMarketEnd'] = tradingPeriods['pre']?['end'];
                foundQuote['regularMarketStart'] =
                    tradingPeriods['regular']?['start'];
                foundQuote['regularMarketEnd'] =
                    tradingPeriods['regular']?['end'];
                foundQuote['postMarketStart'] =
                    tradingPeriods['post']?['start'];
                foundQuote['postMarketEnd'] = tradingPeriods['post']?['end'];
                foundQuote['gmtoffset'] = meta['gmtoffset'];
              }
            }
          }

          setState(() {
            if (!_searchResults
                .any((element) => element['symbol'] == foundQuote['symbol'])) {
              _searchResults.add(foundQuote);
            }
          });
          _addMarketFromSearch(foundQuote);
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text('Could not find market data for symbol: $symbol')),
            );
          }
        }
      } catch (e, stack) {
        if (mounted) {
          ref
              .read(talkerProvider)
              .handle(e, stack, 'Error manually adding market');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error finding market: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  Future<void> _saveTransaction() async {
    if (widget.formData.tickers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one market before saving.'),
        ),
      );
      return;
    }

    try {
      await ref.read(portfolioProvider.notifier).saveIsin(
            id: widget.formData.id,
            isinCode: widget.formData.isinCode,
            altName: widget.formData.altName,
            registeredNames: widget.formData.registeredNames,
            shortName: widget.formData.shortName,
            tickersData: widget.formData.tickers,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ISIN saved successfully!')),
        );
        if (widget.isEditing) {
          Navigator.of(context).pop('SAVED');
        } else {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      }
    } catch (e, stack) {
      if (mounted) {
        ref
            .read(talkerProvider)
            .handle(e, stack, 'Error saving ISIN from Markets step');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving: $e')));
      }
    }
  }

  Future<void> _onAdditionalData() async {
    final route = MaterialPageRoute(
      builder: (context) => AdditionalDataStepScreen(
        formData: widget.formData,
        isEditing: widget.isEditing,
        isEntryPoint: false,
      ),
    );
    final result = await Navigator.push(context, route);
    if (result == 'CANCEL' || result == 'SAVED') {
      if (mounted) {
        Navigator.pop(context, result);
      }
    }
  }

  void _onPrevious() {
    // Tickers are implicitly saved when toggled in the UI list, so no explicit
    // property assignment is strictly required here for backward state preservation.

    if (widget.isEntryPoint) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RegisteredNameStepScreen(
            formData: widget.formData,
            isEditing: widget.isEditing,
            isEntryPoint: true,
          ),
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  String _formatTime(int? unixStart, int? unixEnd, int? gmtOffset) {
    if (unixStart == null || unixEnd == null || gmtOffset == null) {
      return '';
    }

    // gmtOffset is in seconds. We adjust the unix timestamp to represent local time
    // in UTC format, so we can format it easily.
    final startLocal = DateTime.fromMillisecondsSinceEpoch(
        (unixStart + gmtOffset) * 1000,
        isUtc: true);
    final endLocal = DateTime.fromMillisecondsSinceEpoch(
        (unixEnd + gmtOffset) * 1000,
        isUtc: true);

    final formatter = DateFormat('HH:mm');
    return '${formatter.format(startLocal)} - ${formatter.format(endLocal)}';
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) => _handleBackNavigation(didPop),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Markets'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Text(
                    'Select Markets:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    onPressed: _showAddMarketDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Manually'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (_isLoading && _searchResults.isEmpty)
                const Center(child: CircularProgressIndicator())
              else if (_searchResults.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'No results found automatically.',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                )
              else
                Expanded(
                  child: Stack(
                    children: [
                      ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final q = _searchResults[index];
                          final name =
                              q['longname'] ?? q['shortname'] ?? 'Unknown';
                          final symbol = q['symbol'] ?? 'Unknown';

                          final isDirect =
                              _isinDirectSymbols.contains(symbol.toString());

                          final currency = q['currency'];
                          final gmtOffset = q['gmtoffset'] as int?;
                          final regStart = q['regularMarketStart'] as int?;
                          final regEnd = q['regularMarketEnd'] as int?;
                          final timeStr =
                              _formatTime(regStart, regEnd, gmtOffset);

                          final isAlreadyAdded = widget.formData.tickers
                              .any((t) => t.symbol == symbol);

                          return CheckboxListTile(
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (isDirect)
                                  const Icon(Icons.star,
                                      color: Colors.amber, size: 16),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    '${q['exchDisp'] ?? q['exchange'] ?? 'Unknown'} - $symbol'),
                                if (currency != null || timeStr.isNotEmpty)
                                  Text(
                                    '${currency ?? ''}${currency != null && timeStr.isNotEmpty ? " • " : ""}$timeStr',
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                              ],
                            ),
                            value: isAlreadyAdded,
                            onChanged: (bool? value) =>
                                _toggleMarketSelection(q, value),
                          );
                        },
                      ),
                      if (_isLoading)
                        const Positioned(
                          bottom: 16,
                          right: 16,
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              WizardBottomActions(
                onCancel: _cancelWizard,
                onPrevious: _onPrevious,
                onContinue: _onAdditionalData,
                onSave: _saveTransaction,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
