import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/database/models/isin.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../../domain/portfolio_form_data.dart';
import '../../data/portfolio_provider.dart';
import 'isin_step_screen.dart';
import 'registered_name_step_screen.dart';
import 'markets_step_screen.dart';
import 'additional_data_step_screen.dart';
import '../../../../core/widgets/constrained_width.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import 'package:pocket_isins/core/utils/toast_utils.dart';

class IsinSummaryScreen extends ConsumerWidget {
  final Isin isin;

  const IsinSummaryScreen({super.key, required this.isin});

  IsinFormData _createFormData(Isin currentIsin) {
    return IsinFormData(
      id: currentIsin.id,
      isinCode: currentIsin.isinCode ?? '',
      altName: currentIsin.altName ?? '',
      registeredNames: List.from(currentIsin.registeredNames),
      shortName: currentIsin.shortName,
      tickers: currentIsin.tickers.map((t) {
        return TickerFormData(
          symbol: t.symbol,
          exchange: t.exchange,
          currency: t.currency,
          quoteType: t.quoteType,
          regularMarketStart: t.regularMarketStart,
          regularMarketEnd: t.regularMarketEnd,
          preMarketStart: t.preMarketStart,
          preMarketEnd: t.preMarketEnd,
          postMarketStart: t.postMarketStart,
          postMarketEnd: t.postMarketEnd,
        );
      }).toList(),
    );
  }

  void _navigateToEdit(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  String _formatTimeUtc(int? timestamp) {
    if (timestamp == null) return 'N/A';
    final dt = DateTime.fromMillisecondsSinceEpoch(
      timestamp * 1000,
      isUtc: true,
    );
    return DateFormat('HH:mm').format(dt);
  }

  Widget _buildCopyableText(
    BuildContext context,
    String text, {
    TextStyle? style,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: () async {
            await Clipboard.setData(ClipboardData(text: text));
            if (context.mounted) {
              ToastUtils.show(context, 'Copied "$text" to clipboard');
            }
          },
          child: const Padding(
            padding: EdgeInsets.all(4.0),
            child: Icon(Icons.copy, size: 16, color: Colors.grey),
          ),
        ),
        const SizedBox(width: 4),
        Flexible(child: Text(text, style: style)),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isinsAsync = ref.watch(portfolioProvider);
    final currentIsin =
        isinsAsync.whenOrNull(
          data: (isins) =>
              isins.firstWhere((i) => i.id == isin.id, orElse: () => isin),
        ) ??
        isin;

    return Scaffold(
      appBar: CustomAppBar(appBar: AppBar(
        title: Text('${currentIsin.displayName} Details'),
      )),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: ConstrainedWidth.narrow(
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              _buildSection(
                context,
                title: 'ISIN / Name',
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (currentIsin.isinCode?.isNotEmpty == true)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: _buildCopyableText(
                          context,
                          currentIsin.isinCode!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    if (currentIsin.altName?.isNotEmpty == true)
                      _buildCopyableText(
                        context,
                        currentIsin.altName!,
                        style: const TextStyle(fontSize: 16),
                      ),
                  ],
                ),
                onEdit: () {
                  final formData = _createFormData(currentIsin);
                  _navigateToEdit(
                    context,
                    IsinStepScreen(
                      formData: formData,
                      isEditing: true,
                      isEntryPoint: true,
                    ),
                  );
                },
              ),
              const Divider(height: 1),
              _buildSection(
                context,
                title: 'Registered Names',
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: currentIsin.registeredNames.isEmpty
                      ? [
                          const Text(
                            'No registered names selected',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ]
                      : currentIsin.registeredNames
                            .map(
                              (name) => Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: _buildCopyableText(
                                  context,
                                  name,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            )
                            .toList(),
                ),
                onEdit: () {
                  final formData = _createFormData(currentIsin);
                  _navigateToEdit(
                    context,
                    RegisteredNameStepScreen(
                      formData: formData,
                      isEditing: true,
                      isEntryPoint: true,
                    ),
                  );
                },
              ),
              const Divider(height: 1),
              _buildSection(
                context,
                title: 'Tickers',
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: currentIsin.tickers.isEmpty
                      ? [
                          const Text(
                            'No tickers configured.',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ]
                      : currentIsin.tickers
                            .map(
                              (t) => Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          child: _buildCopyableText(
                                            context,
                                            t.symbol,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Theme.of(context).colorScheme.secondary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Exchange: ${t.exchange} (${t.currency ?? "N/A"})',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    if (t.quoteType?.isNotEmpty == true)
                                      Text(
                                        'Type: ${t.quoteType}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    if (t.regularMarketStart != null &&
                                        t.regularMarketEnd != null)
                                      Text(
                                        'Hours: ${_formatTimeUtc(t.regularMarketStart)} - ${_formatTimeUtc(t.regularMarketEnd)} (UTC)',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                ),
                onEdit: () {
                  final formData = _createFormData(currentIsin);
                  _navigateToEdit(
                    context,
                    MarketsStepScreen(
                      formData: formData,
                      isEditing: true,
                      isEntryPoint: true,
                    ),
                  );
                },
              ),
              const Divider(height: 1),
              _buildSection(
                context,
                title: 'Additional Data',
                content: Text(
                  'Short Name: ${currentIsin.shortName?.isNotEmpty == true ? currentIsin.shortName! : "Not set"}',
                  style: const TextStyle(fontSize: 14),
                ),
                onEdit: () {
                  final formData = _createFormData(currentIsin);
                  _navigateToEdit(
                    context,
                    AdditionalDataStepScreen(
                      formData: formData,
                      isEditing: true,
                      isEntryPoint: true,
                    ),
                  );
                },
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    label: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete ISIN'),
                          content: Text(
                            'Are you sure you want to delete ${currentIsin.displayName}?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        await ref
                            .read(portfolioProvider.notifier)
                            .removeIsin(currentIsin.id);
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      }
                    },
                  ),
                ),
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required Widget content,
    required VoidCallback onEdit,
  }) {
    final appThemeExt = Theme.of(context).extension<AppThemeExtension>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.edit,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: onEdit,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                tooltip: 'Edit $title',
              ),
            ],
          ),
          const SizedBox(height: 4),
          content,
        ],
      ),
    );
  }
}
