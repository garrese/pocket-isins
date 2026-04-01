import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  const MarketsStepScreen({super.key, required this.formData, this.isEditing = false});

  @override
  ConsumerState<MarketsStepScreen> createState() => _MarketsStepScreenState();
}

class _MarketsStepScreenState extends ConsumerState<MarketsStepScreen> {
  bool _isLoading = false;
  List<dynamic> _searchResults = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchMarkets();
    });
  }

  Future<void> _handleBackNavigation(bool didPop) async {
    if (didPop) return;

    if (!widget.isEditing) {
      // In creation flow, just go back to the previous step without warning.
      Navigator.of(context).pop();
      return;
    }

    // In edit flow, going back means cancelling the edit operation.
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
          Navigator.of(context).pop();
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
    });

    try {
      final marketService = ref.read(marketDataServiceProvider);
      // We can use the registered name or the ISIN to search for markets.
      // The previous flow used the name for the autofill symbol search.
      final searchTerm = widget.formData.registeredName.isNotEmpty
          ? widget.formData.registeredName
          : widget.formData.isinCode;
      final quotes = await marketService.searchSymbol(searchTerm);
      if (mounted) {
        setState(() {
          _searchResults = quotes;
        });

        if (quotes.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'No markets found automatically. You can add them manually.',
              ),
            ),
          );
        }
      }
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

  void _addMarketFromSearch(dynamic q) {
    final exchange = q['exchange'] ?? 'Unknown';
    final exchDisp = q['exchDisp'] ?? exchange;
    final symbol = q['symbol'] ?? 'Unknown';

    String? mappedCurrency = kExchangeToCurrencyMap[exchDisp.toString()];
    if (mappedCurrency == null) {
      for (final entry in kSymbolSuffixToCurrencyMap.entries) {
        if (symbol.endsWith(entry.key)) {
          mappedCurrency = entry.value;
          break;
        }
      }
    }

    setState(() {
      // Avoid duplicates if possible
      if (!widget.formData.tickers.any((t) => t.symbol == symbol)) {
        widget.formData.tickers.add(
          TickerFormData(
            symbol: symbol,
            exchange: exchDisp,
            currency: mappedCurrency ?? '',
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
    String selectedCurrency = ticker.currency;

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
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedCurrency.isEmpty ? null : selectedCurrency,
                    decoration: const InputDecoration(labelText: 'Currency'),
                    items: kSupportedCurrencies
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        setStateDialog(() {
                          selectedCurrency = v;
                        });
                      }
                    },
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
                    ticker.currency = selectedCurrency;

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
            name: widget.formData.registeredName,
            shortName: widget.formData.shortName,
            tickersData: widget.formData.tickers,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ISIN saved successfully!')),
        );
        // Pop all step screens
        Navigator.of(context).popUntil((route) => route.isFirst);
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

  void _onAdditionalData() {
    final route = MaterialPageRoute(
      builder: (context) => AdditionalDataStepScreen(
        formData: widget.formData,
        isEditing: widget.isEditing,
      ),
    );
    if (widget.isEditing) {
      Navigator.pushReplacement(context, route);
    } else {
      Navigator.push(context, route);
    }
  }

  void _onPrevious() {
    if (widget.isEditing) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RegisteredNameStepScreen(
            formData: widget.formData,
            isEditing: true,
          ),
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) => _handleBackNavigation(didPop),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Markets - Step 3'),
        ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Registered Name: ${widget.formData.registeredName}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Found Markets:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (_isLoading)
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
              SizedBox(
                height: 200, // Constrain height for top list
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final q = _searchResults[index];
                    final name = q['longname'] ?? q['shortname'] ?? 'Unknown';
                    final symbol = q['symbol'] ?? 'Unknown';

                    return ListTile(
                      title: Text(name),
                      subtitle: Text('${q['exchange']} - $symbol'),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.add_circle,
                          color: Colors.blue,
                        ),
                        onPressed: () => _addMarketFromSearch(q),
                      ),
                    );
                  },
                ),
              ),
            const Divider(thickness: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Added Markets:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: () => _showEditMarketDialog(),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Manually'),
                ),
              ],
            ),
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
                            subtitle: Text('Currency: ${ticker.currency}'),
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
