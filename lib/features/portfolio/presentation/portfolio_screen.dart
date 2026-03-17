import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/portfolio_provider.dart';
import 'isin_form_screen.dart';

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
              
              // Helper to calculate total position metrics across all nested instances
              double totalCapital = 0.0;
              double numShares = 0.0;
              String primaryCurrency = 'USD';

              if (isin.tickers.isNotEmpty) {
                 primaryCurrency = isin.tickers.first.currency;
                 for (var t in isin.tickers) {
                    for (var p in t.positions) {
                       totalCapital += p.capitalInvested;
                       numShares += p.shares;
                    }
                 }
              }
              String tickersList = isin.tickers.map((t) => t.symbol).join(', '); // Although we change UI to Yahoo Symbol, we keep variable names internal as isin.tickers.map((t) => t.symbol)

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(
                    isin.displayName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${isin.isinCode} • ${numShares.toStringAsFixed(2)} Shares • Capital: $totalCapital $primaryCurrency\nYahoo Symbols: $tickersList',
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blueAccent),
                        onPressed: () {
                           Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => IsinFormScreen(isinToEdit: isin)),
                           );
                        },
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
        error: (err, stack) {
          debugPrint('PortfolioScreen Error: $err');
          debugPrint('Stacktrace: $stack');
          return Center(child: Text('Error: $err'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
             context,
             MaterialPageRoute(builder: (_) => const IsinFormScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
