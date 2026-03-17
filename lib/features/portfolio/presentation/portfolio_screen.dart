import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/models/isin.dart';
import '../data/portfolio_provider.dart';

class PortfolioScreen extends ConsumerWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final portfolioAsync = ref.watch(portfolioProvider);

    return Scaffold(
      body: portfolioAsync.when(
        data: (isins) {
          if (isins.isEmpty) {
            return const Center(child: Text('Your portfolio is empty. Add some ISINs!'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: isins.length,
            itemBuilder: (context, index) {
              final isin = isins[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(
                    isin.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${isin.isinCode} • Position: ${isin.position} • Unit Price: ${isin.purchasePrice} ${isin.currency}\nTickers: ${isin.tickers.map((t) => t.symbol).join(', ')}',
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blueAccent),
                        onPressed: () => _showIsinDialog(context, ref, isinToEdit: isin),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          ref.read(portfolioProvider.notifier).removeIsin(isin.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showIsinDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showIsinDialog(BuildContext context, WidgetRef ref, {Isin? isinToEdit}) {
    final codeController = TextEditingController(text: isinToEdit?.isinCode ?? '');
    final nameController = TextEditingController(text: isinToEdit?.name ?? '');
    final positionController = TextEditingController(text: isinToEdit?.position.toString() ?? '');
    final priceController = TextEditingController(text: isinToEdit?.purchasePrice.toString() ?? '');
    final currencyController = TextEditingController(text: isinToEdit?.currency ?? 'USD');
    final tickersController = TextEditingController(text: isinToEdit?.tickers.map((t) => t.symbol).join(', ') ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isinToEdit == null ? 'Add ISIN' : 'Edit ISIN'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: codeController,
                  decoration: const InputDecoration(labelText: 'ISIN Code (e.g. US0378331005)'),
                  enabled: isinToEdit == null, // Can't edit the ISIN code once created
                ),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Company Name'),
                ),
                TextField(
                  controller: positionController,
                  decoration: const InputDecoration(labelText: 'Position (Shares)'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Purchase Price'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
                TextField(
                  controller: currencyController,
                  decoration: const InputDecoration(labelText: 'Currency (USD, EUR...)'),
                ),
                TextField(
                  controller: tickersController,
                  decoration: const InputDecoration(
                    labelText: 'Tickers (comma separated)',
                    hintText: 'AAPL, 0R2V.L',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final pos = double.tryParse(positionController.text) ?? 0.0;
                final price = double.tryParse(priceController.text) ?? 0.0;
                
                final parsedTickers = tickersController.text
                    .split(',')
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toList();
                
                if (codeController.text.isNotEmpty && nameController.text.isNotEmpty && currencyController.text.isNotEmpty) {
                  if (isinToEdit == null) {
                    ref.read(portfolioProvider.notifier).addIsin(
                          codeController.text,
                          nameController.text,
                          pos,
                          price,
                          currencyController.text,
                          parsedTickers,
                        );
                  } else {
                    ref.read(portfolioProvider.notifier).editIsin(
                          isinToEdit.id,
                          nameController.text,
                          pos,
                          price,
                          currencyController.text,
                          parsedTickers,
                        );
                  }
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
