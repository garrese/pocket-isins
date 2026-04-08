import 'package:flutter/material.dart';

class ToastUtils {
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void show(BuildContext? context, String message) {
    final messenger = context != null
        ? ScaffoldMessenger.of(context)
        : scaffoldMessengerKey.currentState;

    if (messenger == null) return;

    // Hide any currently showing snackbar first
    messenger.hideCurrentSnackBar();

    final screenHeight = context != null
        ? MediaQuery.of(context).size.height
        : 800.0; // Fallback height if no context
    final bottomMargin = screenHeight * 0.33;

    messenger.showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: GestureDetector(
                  onTap: () {
                    messenger.hideCurrentSnackBar();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C2C3E),
                      borderRadius: BorderRadius.circular(24.0),
                      border: Border.all(
                        color: context != null
                              ? Theme.of(context).colorScheme.primary.withAlpha((255 * 0.2).round())
                              : const Color(0xFF00E5FF).withAlpha((255 * 0.2).round()),
                        width: 1,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black54,
                          blurRadius: 10.0,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
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
