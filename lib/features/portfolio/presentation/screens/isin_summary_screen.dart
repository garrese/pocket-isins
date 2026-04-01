import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/models/isin.dart';
import '../../domain/portfolio_form_data.dart';
import '../../data/portfolio_provider.dart';
import 'isin_step_screen.dart';
import 'registered_name_step_screen.dart';
import 'markets_step_screen.dart';
import 'additional_data_step_screen.dart';

class IsinSummaryScreen extends ConsumerWidget {
  final Isin isin;

  const IsinSummaryScreen({super.key, required this.isin});

  IsinFormData _createFormData() {
    return IsinFormData(
      id: isin.id,
      isinCode: isin.isinCode,
      registeredName: isin.name,
      shortName: isin.shortName,
      tickers: isin.tickers.map((t) {
        return TickerFormData(
          symbol: t.symbol,
          exchange: t.exchange,
          currency: t.currency,
          positions: t.positions.map((p) {
            return PositionFormData(
              capitalInvested: p.capitalInvested,
              purchasePrice: p.purchasePrice,
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  void _navigateToEdit(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We want to fetch the updated ISIN from the state if available, so it updates correctly after editing.
    final isinsAsync = ref.watch(portfolioProvider);
    final currentIsin = isinsAsync.whenOrNull(
          data: (isins) =>
              isins.firstWhere((i) => i.id == isin.id, orElse: () => isin),
        ) ??
        isin;

    return Scaffold(
      appBar: AppBar(
        title: Text('${currentIsin.displayName} Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
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
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSection(
                context,
                title: 'ISIN',
                content: Text(
                  currentIsin.isinCode,
                  style: const TextStyle(fontSize: 16),
                ),
                onEdit: () {
                  final formData = _createFormData();
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
                title: 'Registered Name',
                content: Text(
                  currentIsin.name,
                  style: const TextStyle(fontSize: 16),
                ),
                onEdit: () {
                  final formData = _createFormData();
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
                title: 'Markets',
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: currentIsin.tickers.isEmpty
                      ? [
                          const Text(
                            'No markets configured.',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ]
                      : currentIsin.tickers
                          .map(
                            (t) => Padding(
                              padding: const EdgeInsets.only(bottom: 2.0),
                              child: Text('${t.symbol} (${t.currency})'),
                            ),
                          )
                          .toList(),
                ),
                onEdit: () {
                  final formData = _createFormData();
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
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Short Name:',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                    Text(
                      currentIsin.shortName?.isNotEmpty == true
                          ? currentIsin.shortName!
                          : 'Not set',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                onEdit: () {
                  final formData = _createFormData();
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
            ],
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
    return InkWell(
      onTap: onEdit,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 4),
                  content,
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
