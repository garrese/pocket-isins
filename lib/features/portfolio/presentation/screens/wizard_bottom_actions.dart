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
      // Remove top padding here since it should stick to the bottom and be full bleed
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 600;

          // Common style for all buttons: square edges, no margin
          final squareShape =
              RoundedRectangleBorder(borderRadius: BorderRadius.zero);
          final buttonHeight = 56.0;

          Widget buildCancel() {
            return SizedBox(
              height: buttonHeight,
              child: TextButton.icon(
                onPressed: onCancel,
                icon: const Icon(Icons.close),
                label: const Text('Cancel'),
                style: TextButton.styleFrom(
                  shape: squareShape,
                  foregroundColor: Theme.of(context).colorScheme.error,
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .surface, // Gives it a button look vs background
                ),
              ),
            );
          }

          Widget? buildPrevious() {
            if (isFirstStep || onPrevious == null) return null;
            return SizedBox(
              height: buttonHeight,
              child: OutlinedButton.icon(
                onPressed: onPrevious,
                icon: const Icon(Icons.arrow_back),
                label: const Text('Previous'),
                style: OutlinedButton.styleFrom(
                  shape: squareShape,
                  side: BorderSide(
                      color: Theme.of(context).dividerColor, width: 0.5),
                  backgroundColor: Theme.of(context).colorScheme.surface,
                ),
              ),
            );
          }

          Widget? buildContinue() {
            if (onContinue == null) return null;
            return SizedBox(
              height: buttonHeight,
              child: OutlinedButton.icon(
                onPressed: onContinue,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Continue'),
                style: OutlinedButton.styleFrom(
                  shape: squareShape,
                  side: BorderSide(
                      color: Theme.of(context).dividerColor, width: 0.5),
                  backgroundColor: Theme.of(context).colorScheme.surface,
                ),
              ),
            );
          }

          Widget? buildSave() {
            if (onSave == null) return null;
            return SizedBox(
              height: buttonHeight,
              child: FilledButton.icon(
                onPressed: onSave,
                icon: const Icon(Icons.save),
                label: const Text('Save'),
                style: FilledButton.styleFrom(
                  shape: squareShape,
                ),
              ),
            );
          }

          final previousButton = buildPrevious();
          final cancelButton = buildCancel();
          final continueButton = buildContinue();
          final saveButton = buildSave();

          // Left Group: Cancel, Previous
          final leftGroup = <Widget>[];
          leftGroup.add(Expanded(child: cancelButton));
          if (previousButton != null) {
            leftGroup.add(Expanded(child: previousButton));
          }

          // Right Group: Continue, Save
          final rightGroup = <Widget>[];
          if (continueButton != null) {
            rightGroup.add(Expanded(child: continueButton));
          }
          if (saveButton != null) {
            rightGroup.add(Expanded(child: saveButton));
          }

          if (isNarrow) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (rightGroup.isNotEmpty)
                  Row(
                    children: rightGroup,
                  ),
                Row(
                  children: leftGroup,
                ),
              ],
            );
          } else {
            return Row(
              children: [
                Expanded(
                  child: Row(
                    children: leftGroup,
                  ),
                ),
                Expanded(
                  child: Row(
                    children: rightGroup,
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
