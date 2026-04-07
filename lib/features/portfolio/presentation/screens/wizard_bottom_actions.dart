import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/widgets/constrained_width.dart';

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
      child: ConstrainedWidth.medium(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 600;

          int leftItems = 1; // cancel is always there
          if (!isFirstStep && onPrevious != null) leftItems++;

          int rightItems = 0;
          if (onContinue != null) rightItems++;
          if (onSave != null) rightItems++;

          final maxItemsCount = isNarrow ? math.max(leftItems, rightItems) : 1;
          final buttonHeight = (isNarrow && maxItemsCount > 1) ? 42.0 : 56.0;

          // Common style for all buttons: square edges, no margin
          final squareShape = RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          );

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
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.surface, // Gives it a button look vs background
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
                    color: Theme.of(context).dividerColor,
                    width: 0.5,
                  ),
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
                    color: Theme.of(context).dividerColor,
                    width: 0.5,
                  ),
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
                style: FilledButton.styleFrom(shape: squareShape),
              ),
            );
          }

          final previousButton = buildPrevious();
          final cancelButton = buildCancel();
          final continueButton = buildContinue();
          final saveButton = buildSave();

          if (isNarrow) {
            final leftWidgets = <Widget>[];
            if (previousButton != null)
              leftWidgets.add(Expanded(child: previousButton));
            leftWidgets.add(Expanded(child: cancelButton));

            final rightWidgets = <Widget>[];
            if (continueButton != null)
              rightWidgets.add(Expanded(child: continueButton));
            if (saveButton != null)
              rightWidgets.add(Expanded(child: saveButton));

            final totalHeight = maxItemsCount * buttonHeight;

            return SizedBox(
              height: totalHeight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: leftWidgets,
                    ),
                  ),
                  if (rightWidgets.isNotEmpty)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: rightWidgets,
                      ),
                    ),
                ],
              ),
            );
          } else {
            final leftWidgets = <Widget>[];
            leftWidgets.add(Expanded(child: cancelButton));
            if (previousButton != null)
              leftWidgets.add(Expanded(child: previousButton));

            final rightWidgets = <Widget>[];
            if (continueButton != null)
              rightWidgets.add(Expanded(child: continueButton));
            if (saveButton != null)
              rightWidgets.add(Expanded(child: saveButton));

            return SizedBox(
              height: buttonHeight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: leftWidgets,
                    ),
                  ),
                  if (rightWidgets.isNotEmpty)
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: rightWidgets,
                      ),
                    ),
                ],
              ),
            );
          }
        },
      ),
      ),
    );
  }
}
