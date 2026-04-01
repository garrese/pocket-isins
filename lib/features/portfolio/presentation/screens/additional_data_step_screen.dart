import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/portfolio_form_data.dart';
import '../../data/portfolio_provider.dart';
import '../../../../core/services/log/talker_provider.dart';

class AdditionalDataStepScreen extends ConsumerStatefulWidget {
  final IsinFormData formData;

  const AdditionalDataStepScreen({super.key, required this.formData});

  @override
  ConsumerState<AdditionalDataStepScreen> createState() =>
      _AdditionalDataStepScreenState();
}

class _AdditionalDataStepScreenState
    extends ConsumerState<AdditionalDataStepScreen> {
  late TextEditingController _shortNameController;

  @override
  void initState() {
    super.initState();
    _shortNameController = TextEditingController(
      text: widget.formData.shortName,
    );
  }

  @override
  void dispose() {
    _shortNameController.dispose();
    super.dispose();
  }

  Future<void> _saveTransaction() async {
    widget.formData.shortName = _shortNameController.text.trim();

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
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e, stack) {
      if (mounted) {
        ref
            .read(talkerProvider)
            .handle(e, stack, 'Error saving ISIN from Additional Data step');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving: $e')));
      }
    }
  }

  Future<bool> _onWillPop() async {
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
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Additional Data - Step 4'),
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () async {
                await _onWillPop();
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _shortNameController,
                decoration: const InputDecoration(
                  labelText: 'Short Name (Optional)',
                  border: OutlineInputBorder(),
                  helperText:
                      'Used across the app instead of full name if provided.',
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Back'),
                  ),
                  ElevatedButton(
                    onPressed: _saveTransaction,
                    child: const Text('Save ISIN'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
