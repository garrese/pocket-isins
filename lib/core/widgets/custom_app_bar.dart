import 'package:flutter/material.dart';
import 'constrained_width.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget appBar;
  final ConstrainedWidthType type;

  const CustomAppBar({
    super.key,
    required this.appBar,
    this.type = ConstrainedWidthType.medium,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).appBarTheme.backgroundColor ??
             Theme.of(context).colorScheme.surface,
      child: Center(
        child: ConstrainedWidth(
          type: type,
          child: appBar,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => (appBar as PreferredSizeWidget).preferredSize;
}
