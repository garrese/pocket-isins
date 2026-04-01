import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/portfolio_form_data.dart';
import '../../../../core/network/market_data_service.dart';
import '../../../../core/services/log/talker_provider.dart';
import '../../../../core/constants/market_constants.dart';
import '../../data/portfolio_provider.dart';
import 'additional_data_step_screen.dart';
import 'wizard_bottom_actions.dart';
import 'registered_name_step_screen.dart';

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
  bool _isFoundExpanded = true;

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
        altNameQuotes = await marketService.searchSymbol(widget.formData.altName);
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
          final chartData = await marketService.fetchHistoricalData(symbol.toString(), '1d', '1d');

          if (chartData != null) {
             final meta = chartData['meta'];
             if (meta != null) {
                // We create a mutable map for the UI state
                final Map<String, dynamic> mutableQ = Map<String, dynamic>.from(q);

                mutableQ['currency'] = meta['currency'];

                final tradingPeriods = meta['currentTradingPeriod'];
                if (tradingPeriods != null) {
                  mutableQ['preMarketStart'] = tradingPeriods['pre']?['start'];
                  mutableQ['preMarketEnd'] = tradingPeriods['pre']?['end'];
                  mutableQ['regularMarketStart'] = tradingPeriods['regular']?['start'];
                  mutableQ['regularMarketEnd'] = tradingPeriods['regular']?['end'];
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

  void _addMarketFromSearch(dynamic q) {
    final exchange = q['exchange'] ?? 'Unknown';
    final exchDisp = q['exchDisp'] ?? exchange;
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
            exchange: exchDisp,
            currency: currency,
            quoteType: quoteType,
            regularMarketStart: regularMarketStart is int ? regularMarketStart : null,
            regularMarketEnd: regularMarketEnd is int ? regularMarketEnd : null,
            preMarketStart: preMarketStart is int ? preMarketStart : null,
            preMarketEnd: preMarketEnd is int ? preMarketEnd : null,
            postMarketStart: postMarketStart is int ? postMarketStart : null,
            postMarketEnd: postMarketEnd is int ? postMarketEnd : null,
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added market: $symbol'),
            duration: const Duration(seconds: 1),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Market $symbol is already in the list.'),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    });
  }

  Future<void> _showEditMarketDialog({
    TickerFormData? existingTicker,
    int? index,
  }) async {
    final isNew = existingTicker == null;
    final ticker = isNew ? TickerFormData() : existingTicker;

    final symbolController = TextEditingController(text: ticker.symbol);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(isNew ? 'Add Market Manually' : 'Edit Market'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: symbolController,
                    decoration: const InputDecoration(
                      labelText: 'Symbol (e.g., AAPL)',
                    ),
                  ),
                ],
              ),
              actions: [
                if (!isNew)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        widget.formData.tickers.removeAt(index!);
                      });
                      Navigator.pop(context, false);
                    },
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('Delete'),
                  ),
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (symbolController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Symbol cannot be empty.'),
                        ),
                      );
                      return;
                    }
                    ticker.symbol = symbolController.text.trim();

                    if (isNew) {
                      setState(() {
                        widget.formData.tickers.add(ticker);
                      });
                    } else {
                      setState(() {
                        widget.formData.tickers[index!] = ticker;
                      });
                    }
                    Navigator.pop(context, true);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
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
    final startLocal = DateTime.fromMillisecondsSinceEpoch((unixStart + gmtOffset) * 1000, isUtc: true);
    final endLocal = DateTime.fromMillisecondsSinceEpoch((unixEnd + gmtOffset) * 1000, isUtc: true);

    final formatter = DateFormat('HH:mm');
    return '${formatter.format(startLocal)} - ${formatter.format(endLocal)}';
  }

  @override
  Widget build(BuildContext context) {
    final isTallScreen = MediaQuery.of(context).size.height > 800;
    final showFound = isTallScreen || _isFoundExpanded;
    final showAdded = isTallScreen || !_isFoundExpanded;

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
              InkWell(
                onTap: isTallScreen
                    ? null
                    : () {
                        setState(() {
                          _isFoundExpanded = !_isFoundExpanded;
                        });
                      },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Found Markets:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (!isTallScreen)
                        Icon(_isFoundExpanded
                            ? Icons.expand_less
                            : Icons.expand_more),
                    ],
                  ),
                ),
              ),
              if (showFound) ...[
                if (_isLoading && _searchResults.isEmpty)
                  const Center(child: CircularProgressIndicator())
                else if (_searchResults.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
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

                            final isDirect = _isinDirectSymbols.contains(symbol.toString());

                            final currency = q['currency'];
                            final gmtOffset = q['gmtoffset'] as int?;
                            final regStart = q['regularMarketStart'] as int?;
                            final regEnd = q['regularMarketEnd'] as int?;
                            final timeStr = _formatTime(regStart, regEnd, gmtOffset);

                            final isAlreadyAdded = widget.formData.tickers
                                .any((t) => t.symbol == symbol);

                            return ListTile(
                              title: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      name,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (isDirect)
                                    const Icon(Icons.star, color: Colors.amber, size: 16),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${q['exchange']} - $symbol'),
                                  if (currency != null || timeStr.isNotEmpty)
                                    Text(
                                      '${currency ?? ''}${currency != null && timeStr.isNotEmpty ? " • " : ""}$timeStr',
                                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  isAlreadyAdded
                                      ? Icons.check_circle
                                      : Icons.add_circle,
                                  color:
                                      isAlreadyAdded ? Colors.green : Colors.blue,
                                ),
                                onPressed: () => _addMarketFromSearch(q),
                              ),
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
              ],
              const Divider(thickness: 2),
              InkWell(
                onTap: isTallScreen
                    ? null
                    : () {
                        setState(() {
                          _isFoundExpanded = !_isFoundExpanded;
                        });
                      },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Added Markets:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          TextButton.icon(
                            onPressed: () => _showEditMarketDialog(),
                            icon: const Icon(Icons.add),
                            label: const Text('Add Manually'),
                          ),
                          if (!isTallScreen)
                            Icon(!_isFoundExpanded
                                ? Icons.expand_less
                                : Icons.expand_more),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (showAdded) ...[
                Expanded(
                  child: widget.formData.tickers.isEmpty
                      ? const Center(
                          child: Text(
                            'No markets added yet.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: widget.formData.tickers.length,
                          itemBuilder: (context, index) {
                            final ticker = widget.formData.tickers[index];
                            return Card(
                              child: ListTile(
                                title: Text(ticker.symbol),
                                subtitle: Text('Currency: ${ticker.currency ?? 'N/A'}'),
                                trailing: const Icon(Icons.edit, size: 20),
                                onTap: () => _showEditMarketDialog(
                                  existingTicker: ticker,
                                  index: index,
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
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
