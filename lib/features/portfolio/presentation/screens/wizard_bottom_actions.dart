import 'package:flutter/material.dart';

class WizardBottomActions extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback? onPrevious;
  final VoidCallback? onContinue;
  final VoidCallback? onSave;
  final bool isFirstStep;

  const WizardBottomActions({
    super.key,
    required this.onCancel,
    this.onPrevious,
    this.onContinue,
    this.onSave,
    this.isFirstStep = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Wrap(
              alignment: WrapAlignment.start,
              spacing: 8,
              runSpacing: 8,
              children: [
                TextButton.icon(
                  onPressed: onCancel,
                  icon: const Icon(Icons.close),
                  label: const Text('Cancel'),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                ),
                if (!isFirstStep)
                  OutlinedButton.icon(
                    onPressed: onPrevious,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Previous'),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Wrap(
              alignment: WrapAlignment.end,
              spacing: 8,
              runSpacing: 8,
              children: [
                if (onContinue != null)
                  ElevatedButton.icon(
                    onPressed: onContinue,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Continue'),
                  ),
                if (onSave != null)
                  FilledButton.icon(
                    onPressed: onSave,
                    icon: const Icon(Icons.save),
                    label: const Text('Save'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
