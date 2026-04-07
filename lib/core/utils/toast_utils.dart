import 'package:flutter/material.dart';

class ToastUtils {
  static void show(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.of(context);
    // Hide any currently showing snackbar first
    messenger.hideCurrentSnackBar();

    final screenHeight = MediaQuery.of(context).size.height;
    final bottomMargin = screenHeight * 0.33;

    messenger.showSnackBar(
      SnackBar(
        content: GestureDetector(
          onTap: () {
            messenger.hideCurrentSnackBar();
          },
          behavior: HitTestBehavior.opaque,
          child: Text(message),
        ),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: bottomMargin,
          left: 16.0,
          right: 16.0,
        ),
        duration: const Duration(milliseconds: 1500),
        dismissDirection: DismissDirection.none,
      ),
    );
  }
}
