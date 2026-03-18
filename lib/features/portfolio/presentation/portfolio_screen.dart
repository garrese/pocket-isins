import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

import '../data/portfolio_provider.dart';
import 'isin_form_screen.dart';


class PortfolioScreen extends ConsumerWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final portfolioAsync = ref.watch(portfolioProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Portfolio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            tooltip: 'Import Portfolio',
            onPressed: () async {
              try {
                final result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['json'],
                );
                if (result != null && result.files.single.path != null) {
                  final file = File(result.files.single.path!);
                  final jsonString = await file.readAsString();
                  await ref.read(portfolioProvider.notifier).importPortfolio(jsonString);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Portfolio imported successfully')),
                    );
                  }
                }
              } catch (e, st) {
                debugPrint('Error importing portfolio: $e\n$st');
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error importing portfolio: $e')),
                  );
                }
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.upload),
            tooltip: 'Export Portfolio',
            onPressed: () async {
              try {
                final jsonString = await ref.read(portfolioProvider.notifier).exportPortfolio();

                if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
                  // Guardar en PC
                  final String? outputFile = await FilePicker.platform.saveFile(
                    dialogTitle: 'Please select an output file:',
                    fileName: 'portfolio_export.json',
                    type: FileType.custom,
                    allowedExtensions: ['json'],
                  );

                  if (outputFile != null) {
                    final file = File(outputFile);
                    await file.writeAsString(jsonString);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Portfolio exported successfully')),
                      );
                    }
                  }
                } else {
                  // Compartir en móvil
                  final directory = await getTemporaryDirectory();
                  final file = File('${directory.path}/portfolio_export.json');
                  await file.writeAsString(jsonString);

                  final xFile = XFile(file.path);
                  await Share.shareXFiles([xFile], text: 'My Portfolio Export');
                }
              } catch (e, st) {
                debugPrint('Error exporting portfolio: $e\n$st');
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error exporting portfolio: $e')),
                  );
                }
              }
            },
          ),
        ],
      ),
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

              bool hasPositions = numShares > 0 || totalCapital > 0;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => IsinFormScreen(isinToEdit: isin)),
                    );
                  },
                  title: Text(
                    isin.displayName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tickersList),
                      if (hasPositions)
                        Text('$totalCapital $primaryCurrency • $numShares Shares'),
                    ],
                  ),
                  isThreeLine: hasPositions,
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
