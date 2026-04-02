import re

file_path = "lib/features/portfolio/presentation/screens/wizard_bottom_actions.dart"
with open(file_path, "r") as f:
    content = f.read()

replacement = """import 'package:flutter/material.dart';

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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 600;

          Widget cancelButton = TextButton.icon(
            onPressed: onCancel,
            icon: const Icon(Icons.close),
            label: const Text('Cancel'),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
          );

          Widget? previousButton;
          if (!isFirstStep && onPrevious != null) {
            previousButton = OutlinedButton.icon(
              onPressed: onPrevious,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Previous'),
            );
          }

          Widget? continueButton;
          if (onContinue != null) {
            continueButton = OutlinedButton.icon(
              onPressed: onContinue,
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Continue'),
            );
          }

          Widget? saveButton;
          if (onSave != null) {
            saveButton = FilledButton.icon(
              onPressed: onSave,
              icon: const Icon(Icons.save),
              label: const Text('Save'),
            );
          }

          if (isNarrow) {
            return Column(
              children: [
                Row(
                  children: [
                    if (previousButton != null)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: previousButton,
                        ),
                      )
                    else
                      const Spacer(),
                    if (continueButton != null)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: continueButton,
                        ),
                      )
                    else
                      const Spacer(),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: cancelButton,
                      ),
                    ),
                    if (saveButton != null)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: saveButton,
                        ),
                      )
                    else
                      const Spacer(),
                  ],
                ),
              ],
            );
          } else {
            return Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: cancelButton,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: previousButton ?? const SizedBox.shrink(),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: continueButton ?? const SizedBox.shrink(),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: saveButton ?? const SizedBox.shrink(),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
"""

with open(file_path, "w") as f:
    f.write(replacement)
