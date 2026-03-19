import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../core/network/dio_provider.dart';

import '../../../core/database/models/isin.dart';
import '../domain/portfolio_form_data.dart';
import '../data/portfolio_provider.dart';

class IsinFormScreen extends ConsumerStatefulWidget {
  final Isin? isinToEdit;

  const IsinFormScreen({super.key, this.isinToEdit});

  @override
  ConsumerState<IsinFormScreen> createState() => _IsinFormScreenState();
}

class _IsinFormScreenState extends ConsumerState<IsinFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _codeController;
  late TextEditingController _nameController;
  late TextEditingController _shortNameController;

  final List<TickerFormData> _tickers = [];
  int? _searchingIndex;
  bool _isAutoFillingName = false;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: widget.isinToEdit?.isinCode ?? '');
    _nameController = TextEditingController(text: widget.isinToEdit?.name ?? '');
    _shortNameController = TextEditingController(text: widget.isinToEdit?.shortName ?? '');

    if (widget.isinToEdit != null) {
      for (final ticker in widget.isinToEdit!.tickers) {
        final positions = ticker.positions.map((p) {
          return PositionFormData(
            capitalInvested: p.capitalInvested,
            purchasePrice: p.purchasePrice,
          );
        }).toList();

        _tickers.add(
          TickerFormData(
            symbol: ticker.symbol,
            exchange: ticker.exchange,
            currency: ticker.currency,
            positions: positions,
          ),
        );
      }
    } else {
      // Add one empty ticker by default
      _tickers.add(TickerFormData());
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _shortNameController.dispose();
    super.dispose();
  }

  Future<void> _autoFillName() async {
    final isin = _codeController.text.trim();
    if (isin.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor se necesita un ISIN primero.')),
      );
      return;
    }

    setState(() {
      _isAutoFillingName = true;
    });

    try {
      final dio = ref.read(dioProvider);
      final response = await dio.get(
        'https://query2.finance.yahoo.com/v1/finance/search',
        queryParameters: {'newsCount': 0, 'q': isin},
        options: Options(
          headers: {
            'User-Agent': 'yaak',
            'Accept': '*/*',
          },
        ),
      );
      final quotes = response.data['quotes'] as List<dynamic>? ?? [];

      if (quotes.isNotEmpty) {
        final firstQuote = quotes[0];
        final longname = firstQuote['longname'];
        final shortname = firstQuote['shortname'];

        final nameToUse = longname ?? shortname;

        if (nameToUse != null) {
          setState(() {
            _nameController.text = nameToUse;
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Name auto-filled successfully.')),
            );
          }
        } else {
           if (mounted) {
             ScaffoldMessenger.of(context).showSnackBar(
               const SnackBar(content: Text('Could not find a name for this ISIN.')),
             );
           }
        }
      } else {
         if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text('No results found for this ISIN.')),
           );
         }
      }
    } catch (e, stack) {
      debugPrint('Error auto-filling name: $e');
      debugPrint('Stacktrace: $stack');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error auto-filling name.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAutoFillingName = false;
        });
      }
    }
  }

  Future<void> _searchSymbol(int tIndex) async {
    final isin = _codeController.text.trim();
    final name = _nameController.text.trim();

    if (isin.isEmpty && name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an ISIN or Company Name first.')),
      );
      return;
    }

    setState(() {
      _searchingIndex = tIndex;
    });

    try {
      final dio = ref.read(dioProvider);
      final options = Options(
        headers: {
          'User-Agent': 'yaak',
          'Accept': '*/*',
        },
      );

      List<dynamic> quotes = [];

      if (isin.isNotEmpty) {
        final response = await dio.get(
          'https://query2.finance.yahoo.com/v1/finance/search',
          queryParameters: {'newsCount': 0, 'q': isin},
          options: options,
        );
        final firstQuotes = response.data['quotes'] as List<dynamic>? ?? [];

        if (firstQuotes.isNotEmpty) {
           final firstQuote = firstQuotes[0];
           final longname = firstQuote['longname'];
           final shortname = firstQuote['shortname'];

           final nameToSearch = longname ?? shortname;

           if (nameToSearch != null && nameToSearch.toString().isNotEmpty) {
             final secondResponse = await dio.get(
               'https://query2.finance.yahoo.com/v1/finance/search',
               queryParameters: {'newsCount': 0, 'q': nameToSearch},
               options: options,
             );
             quotes = secondResponse.data['quotes'] as List<dynamic>? ?? [];
           } else {
             // fallback to direct ISIN search if no name available
             quotes = firstQuotes;
           }
        } else {
           quotes = firstQuotes;
        }
      } else if (name.isNotEmpty) {
        final response = await dio.get(
          'https://query2.finance.yahoo.com/v1/finance/search',
          queryParameters: {'newsCount': 0, 'q': name},
          options: options,
        );
        quotes = response.data['quotes'] as List<dynamic>? ?? [];
      }

      if (quotes.isEmpty && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not find a symbol. Please enter the Yahoo Symbol manually.')),
        );
      } else if (mounted) {
         _showSymbolSelectionDialog(tIndex, quotes);
      }

    } catch (e, stack) {
      debugPrint('Error searching symbol: $e');
      debugPrint('Stacktrace: $stack');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error searching symbol. Please enter the Yahoo Symbol manually.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _searchingIndex = null;
        });
      }
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Ensure we don't save empty symbols
      final validTickers = _tickers.where((t) => t.symbol.trim().isNotEmpty).toList();

      ref.read(portfolioProvider.notifier).saveIsin(
        id: widget.isinToEdit?.id,
        isinCode: _codeController.text.trim(),
        name: _nameController.text.trim(),
        shortName: _shortNameController.text.trim().isEmpty ? null : _shortNameController.text.trim(),
        tickersData: validTickers,
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isinToEdit == null ? 'Add ISIN' : 'Edit ISIN'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _save,
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            widget.isinToEdit == null
                ? TextFormField(
                    controller: _codeController,
                    decoration: const InputDecoration(labelText: 'ISIN Code (e.g., US0378331005)', border: OutlineInputBorder()),
                    validator: (v) => v!.trim().isEmpty ? 'Required' : null,
                  )
                : InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: _codeController.text));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('ISIN copied to clipboard!')),
                      );
                    },
                    child: IgnorePointer(
                      child: TextFormField(
                        controller: _codeController,
                        decoration: const InputDecoration(
                          labelText: 'ISIN Code (e.g., US0378331005)',
                          border: OutlineInputBorder(),
                        ),
                        enabled: false,
                      ),
                    ),
                  ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: _isAutoFillingName
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.auto_awesome),
                  onPressed: _isAutoFillingName ? null : _autoFillName,
                  tooltip: 'Auto-fill from Yahoo',
                ),
              ),
              validator: (v) => v!.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _shortNameController,
              decoration: const InputDecoration(
                labelText: 'Short Name (Optional)',
                border: OutlineInputBorder(),
                helperText: 'Used across the app instead of full name if provided.',
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Market Data', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add Market'),
                  onPressed: () {
                    setState(() {
                      _tickers.add(TickerFormData());
                    });
                  },
                )
              ],
            ),
            const Divider(),
            ..._tickers.asMap().entries.map((entry) {
              int tIndex = entry.key;
              TickerFormData ticker = entry.value;
              return _buildTickerSection(tIndex, ticker);
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _save,
        icon: const Icon(Icons.save),
        label: const Text('Save ISIN'),
      ),
    );
  }

  Widget _buildTickerSection(int tIndex, TickerFormData ticker) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Market', style: TextStyle(fontWeight: FontWeight.w600)),
                _searchingIndex == tIndex
                    ? const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                      )
                    : TextButton.icon(
                        icon: const Icon(Icons.search, size: 16),
                        label: const Text('Search Market'),
                        onPressed: _searchingIndex != null ? null : () => _searchSymbol(tIndex),
                      ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    key: ValueKey('symbol_${tIndex}_${ticker.symbol}'),
                    initialValue: ticker.symbol,
                    decoration: const InputDecoration(labelText: 'Yahoo Symbol (e.g., AAPL)'),
                    onChanged: (v) => ticker.symbol = v,
                    validator: (v) => v!.trim().isEmpty ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: ticker.currency.isEmpty ? null : ticker.currency,
                    decoration: const InputDecoration(labelText: 'Currency'),
                    items: const [
                      DropdownMenuItem(value: 'USD', child: Text('USD')),
                      DropdownMenuItem(value: 'EUR', child: Text('EUR')),
                      DropdownMenuItem(value: 'GBP', child: Text('GBP')),
                      DropdownMenuItem(value: 'CHF', child: Text('CHF')),
                      DropdownMenuItem(value: 'JPY', child: Text('JPY')),
                      DropdownMenuItem(value: 'CAD', child: Text('CAD')),
                      DropdownMenuItem(value: 'AUD', child: Text('AUD')),
                      DropdownMenuItem(value: 'HKD', child: Text('HKD')),
                      DropdownMenuItem(value: 'SEK', child: Text('SEK')),
                      DropdownMenuItem(value: 'NOK', child: Text('NOK')),
                      DropdownMenuItem(value: 'DKK', child: Text('DKK')),
                    ],
                    onChanged: (v) {
                      if (v != null) {
                        setState(() {
                          ticker.currency = v;
                        });
                      }
                    },
                    validator: (v) {
                      if (ticker.positions.isNotEmpty && (v == null || v.isEmpty)) {
                        return 'Required with positions';
                      }
                      return null;
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      _tickers.removeAt(tIndex);
                    });
                  },
                )
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Positions', style: TextStyle(fontWeight: FontWeight.w600)),
                TextButton.icon(
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Position'),
                  onPressed: () {
                    setState(() {
                      ticker.positions.add(PositionFormData());
                    });
                  },
                ),
              ],
            ),
            ...ticker.positions.asMap().entries.map((pEntry) {
              int pIndex = pEntry.key;
              PositionFormData pos = pEntry.value;
              return Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: pos.capitalInvested > 0 ? pos.capitalInvested.toString() : '',
                      decoration: const InputDecoration(labelText: 'Capital Invested'),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (v) => pos.capitalInvested = double.tryParse(v) ?? 0.0,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      initialValue: pos.purchasePrice > 0 ? pos.purchasePrice.toString() : '',
                      decoration: const InputDecoration(labelText: 'Purchase Unit Price'),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (v) => pos.purchasePrice = double.tryParse(v) ?? 0.0,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.grey),
                    onPressed: () {
                      setState(() {
                        ticker.positions.removeAt(pIndex);
                      });
                    },
                  )
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showSymbolSelectionDialog(int tIndex, List<dynamic> quotes) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: quotes.length,
          itemBuilder: (context, index) {
            final q = quotes[index];
            final shortname = q['longname'] ?? q['shortname'] ?? 'Unknown';
            final exchange = q['exchange'] ?? 'Unknown';
            final exchDisp = q['exchDisp'] ?? exchange;
            final symbol = q['symbol'] ?? 'Unknown';
            final title = '$shortname ($exchDisp) - $symbol';

            return ListTile(
              title: Text(title),
              onTap: () {
                setState(() {
                  _tickers[tIndex].symbol = symbol;

                  // Auto-map currency based on exchDisp
                  final currencyMap = {
                    'XETRA': 'EUR',
                    'Milan': 'EUR',
                    'Stockholm': 'SEK',
                    'London': 'GBP',
                    'Stuttgart': 'EUR',
                    'Swiss': 'CHF',
                    'Paris': 'EUR',
                    'NYSE': 'USD',
                    'NASDAQ': 'USD',
                    'Toronto': 'CAD',
                    'Amsterdam': 'EUR',
                    'Frankfurt': 'EUR',
                    'Madrid': 'EUR',
                    'Oslo': 'NOK',
                    'Copenhagen': 'DKK',
                    'Helsinki': 'EUR',
                    'Tokyo': 'JPY',
                    'Hong Kong': 'HKD',
                    'Sydney': 'AUD',
                  };

                  // Reset currency first
                  _tickers[tIndex].currency = '';

                  // Try to find a match
                  final matchingCurrency = currencyMap[exchDisp.toString()];
                  if (matchingCurrency != null) {
                    _tickers[tIndex].currency = matchingCurrency;
                  } else {
                     // Check common symbol suffixes if exchDisp wasn't mapped
                     if (symbol.endsWith('.L')) { _tickers[tIndex].currency = 'GBP'; }
                     else if (symbol.endsWith('.MI')) { _tickers[tIndex].currency = 'EUR'; }
                     else if (symbol.endsWith('.DE') || symbol.endsWith('.F') || symbol.endsWith('.SG') || symbol.endsWith('.MU') || symbol.endsWith('.HM')) { _tickers[tIndex].currency = 'EUR'; }
                     else if (symbol.endsWith('.PA')) { _tickers[tIndex].currency = 'EUR'; }
                     else if (symbol.endsWith('.AS')) { _tickers[tIndex].currency = 'EUR'; }
                     else if (symbol.endsWith('.MA')) { _tickers[tIndex].currency = 'EUR'; }
                     else if (symbol.endsWith('.SW')) { _tickers[tIndex].currency = 'CHF'; }
                     else if (symbol.endsWith('.TO')) { _tickers[tIndex].currency = 'CAD'; }
                     else if (symbol.endsWith('.AX')) { _tickers[tIndex].currency = 'AUD'; }
                     else if (symbol.endsWith('.T')) { _tickers[tIndex].currency = 'JPY'; }
                     else if (symbol.endsWith('.HK')) { _tickers[tIndex].currency = 'HKD'; }
                  }

                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }
}

