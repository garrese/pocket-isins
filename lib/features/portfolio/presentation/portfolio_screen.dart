import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

import '../data/portfolio_provider.dart';
import 'screens/isin_step_screen.dart';
import 'screens/isin_summary_screen.dart';
import '../domain/portfolio_form_data.dart';
import '../../../core/theme/app_drawer.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../core/widgets/constrained_width.dart';
import '../../../core/widgets/custom_app_bar.dart';
import 'package:pocket_isins/core/utils/toast_utils.dart';

class PortfolioScreen extends ConsumerWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final portfolioAsync = ref.watch(portfolioProvider);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: CustomAppBar(appBar: AppBar(
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
                  await ref
                      .read(portfolioProvider.notifier)
                      .importPortfolio(jsonString);
                  if (context.mounted) {
                    ToastUtils.show(context, 'Portfolio imported successfully');
                  }
                }
              } catch (e, st) {
                debugPrint('Error importing portfolio: $e\n$st');
                if (context.mounted) {
                  ToastUtils.show(context, 'Error importing portfolio: $e');
                }
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.upload),
            tooltip: 'Export Portfolio',
            onPressed: () async {
              try {
                final jsonString = await ref
                    .read(portfolioProvider.notifier)
                    .exportPortfolio();

                if (!kIsWeb &&
                    (Platform.isWindows ||
                        Platform.isLinux ||
                        Platform.isMacOS)) {
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
                      ToastUtils.show(context, 'Portfolio exported successfully');
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
                  ToastUtils.show(context, 'Error exporting portfolio: $e');
                }
              }
            },
          ),
        ],
      )),
      body: portfolioAsync.when(
        data: (isins) {
          if (isins.isEmpty) {
            return const Center(
              child: Text('You have no ISINs yet. Add some!'),
            );
          }
          return ConstrainedWidth.narrow(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              itemCount: isins.length,
              itemBuilder: (context, index) {
              final isin = isins[index];

              String tickersList = isin.tickers.map((t) => t.symbol).join(', ');

              final appThemeExt = Theme.of(
                context,
              ).extension<AppThemeExtension>();

              return Card(
                margin: const EdgeInsets.only(bottom: 4.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => IsinSummaryScreen(isin: isin),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isin.displayName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: appThemeExt?.mainTitleColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if ((isin.shortName != null && isin.shortName!.isNotEmpty) ||
                            (isin.isinCode != null && isin.isinCode!.isNotEmpty) ||
                            tickersList.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (isin.shortName != null &&
                                    isin.shortName!.isNotEmpty)
                                  Text(
                                    isin.shortName!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                if (isin.isinCode != null && isin.isinCode!.isNotEmpty)
                                  Text(
                                    isin.isinCode!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                if (tickersList.isNotEmpty)
                                  Text(
                                    tickersList,
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) {
          debugPrint('PortfolioScreen Error: $err');
          debugPrint('Stacktrace: $stack');
          return Center(child: Text('Error: $err'));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ConstrainedWidth.narrow(
        child: Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => IsinStepScreen(formData: IsinFormData()),
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ),
    );
  }
}
