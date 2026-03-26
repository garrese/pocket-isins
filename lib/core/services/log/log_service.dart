import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'domain/log_message.dart';

final logServiceProvider = NotifierProvider<LogService, List<LogMessage>>(() {
  return LogService();
});

class LogService extends Notifier<List<LogMessage>> {
  @override
  List<LogMessage> build() {
    return [];
  }

  void _log(int level, String message,
      [dynamic error, StackTrace? stackTrace]) {
    final logMsg = LogMessage(
      timestamp: DateTime.now(),
      level: level,
      message: message,
      error: error?.toString() != null ? '$error\n${stackTrace ?? ''}' : null,
    );

    // Keep state immutable, add new message at the end
    state = [...state, logMsg];

    // Also print to console
    final prefix = _getLevelPrefix(level);
    debugPrint('[$prefix] $message');
    if (error != null) {
      debugPrint(error.toString());
    }
    if (stackTrace != null) {
      debugPrint(stackTrace.toString());
    }
  }

  void verbose(String message, [dynamic error, StackTrace? stackTrace]) {
    _log(0, message, error, stackTrace);
  }

  void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _log(1, message, error, stackTrace);
  }

  void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _log(2, message, error, stackTrace);
  }

  void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _log(3, message, error, stackTrace);
  }

  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _log(4, message, error, stackTrace);
  }

  void clearLogs() {
    state = [];
  }

  String _getLevelPrefix(int level) {
    switch (level) {
      case 0:
        return 'VERB';
      case 1:
        return 'DBUG';
      case 2:
        return 'INFO';
      case 3:
        return 'WARN';
      case 4:
        return 'ERR';
      default:
        return 'UNK';
    }
  }
}
