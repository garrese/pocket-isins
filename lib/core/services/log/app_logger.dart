import 'package:talker_flutter/talker_flutter.dart';

class AppLogger {
  final Talker _talker;
  final bool Function() _getEnableLongLogDetails;

  AppLogger(this._talker, this._getEnableLongLogDetails);

  // Truncation is now handled globally by CustomTalkerFormatter.
  // We can just pass the messages directly to talker.

  void info(String message) {
    _talker.info(message);
  }

  void debug(String message) {
    _talker.debug(message);
  }

  void verbose(String message) {
    _talker.verbose(message);
  }

  void warning(String message, [String? exception, StackTrace? stackTrace]) {
    _talker.warning(message, exception, stackTrace);
  }

  void handle(Object exception, [StackTrace? stackTrace, String? msg]) {
    _talker.handle(exception, stackTrace, msg);
  }

  // Allow access to underlying Talker if strictly necessary (e.g., TalkerScreen)
  Talker get talker => _talker;
}
