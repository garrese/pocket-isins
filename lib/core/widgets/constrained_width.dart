import 'package:flutter/material.dart';

enum ConstrainedWidthType { narrow, medium, wide }

class ConstrainedWidth extends StatelessWidget {
  final Widget child;
  final ConstrainedWidthType type;

  const ConstrainedWidth({
    super.key,
    required this.child,
    this.type = ConstrainedWidthType.medium,
  });

  const ConstrainedWidth.narrow({super.key, required this.child})
      : type = ConstrainedWidthType.narrow;

  const ConstrainedWidth.medium({super.key, required this.child})
      : type = ConstrainedWidthType.medium;

  const ConstrainedWidth.wide({super.key, required this.child})
      : type = ConstrainedWidthType.wide;

  double get _maxWidth {
    switch (type) {
      case ConstrainedWidthType.narrow:
        return 600.0;
      case ConstrainedWidthType.medium:
        return 900.0;
      case ConstrainedWidthType.wide:
        return 1200.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: _maxWidth,
              maxHeight: constraints.maxHeight,
            ),
            child: child,
          ),
        );
      },
    );
  }
}
