import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

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

  final List<TickerFormData> _tickers = [];
  int? _searchingIndex;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: widget.isinToEdit?.isinCode ?? '');
    _nameController = TextEditingController(text: widget.isinToEdit?.name ?? '');

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
    super.dispose();
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
      final dio = Dio();
      dio.options.headers['User-Agent'] = 'yaak';
      dio.options.headers['Accept'] = '*/*';

      List<dynamic> quotes = [];

      if (isin.isNotEmpty) {
        final response = await dio.get(
          'https://query2.finance.yahoo.com/v1/finance/search',
          queryParameters: {'newsCount': 0, 'q': isin},
        );
        final firstQuotes = response.data['quotes'] as List<dynamic>? ?? [];

        if (firstQuotes.isNotEmpty && firstQuotes[0]['shortname'] != null) {
           final shortname = firstQuotes[0]['shortname'];
           final secondResponse = await dio.get(
             'https://query2.finance.yahoo.com/v1/finance/search',
             queryParameters: {'newsCount': 0, 'q': shortname},
           );
           quotes = secondResponse.data['quotes'] as List<dynamic>? ?? [];
        } else {
           // fallback to direct ISIN search if shortname missing
           quotes = firstQuotes;
        }
      } else if (name.isNotEmpty) {
        final response = await dio.get(
          'https://query2.finance.yahoo.com/v1/finance/search',
          queryParameters: {'newsCount': 0, 'q': name},
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
              decoration: const InputDecoration(labelText: 'Company Name', border: OutlineInputBorder()),
              validator: (v) => v!.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Yahoo Symbols', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add Yahoo Symbol'),
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
                const Text('Symbol Data', style: TextStyle(fontWeight: FontWeight.w600)),
                _searchingIndex == tIndex
                    ? const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                      )
                    : TextButton.icon(
                        icon: const Icon(Icons.search, size: 16),
                        label: const Text('Search Symbol'),
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
                  child: TextFormField(
                    initialValue: ticker.currency,
                    decoration: const InputDecoration(labelText: 'Currency (USD)'),
                    onChanged: (v) => ticker.currency = v,
                    validator: (v) => v!.trim().isEmpty ? 'Required' : null,
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
            final shortname = q['shortname'] ?? 'Unknown';
            final exchange = q['exchange'] ?? 'Unknown';
            final symbol = q['symbol'] ?? 'Unknown';
            final title = '$shortname ($exchange) - $symbol';

            return ListTile(
              title: Text(title),
              onTap: () {
                setState(() {
                  _tickers[tIndex].symbol = symbol;
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

