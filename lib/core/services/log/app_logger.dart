import 'package:talker_flutter/talker_flutter.dart';

class AppLogger {
  final Talker _talker;
  final bool Function() _getEnableLongLogDetails;

  AppLogger(this._talker, this._getEnableLongLogDetails);

  String _truncateIfNeeded(String msg) {
    if (!_getEnableLongLogDetails() && msg.length > 5000) {
      return '${msg.substring(0, 5000)}...';
    }
    return msg;
  }

  void info(String message) {
    _talker.info(_truncateIfNeeded(message));
  }

  void debug(String message) {
    _talker.debug(_truncateIfNeeded(message));
  }

  void verbose(String message) {
    _talker.verbose(_truncateIfNeeded(message));
  }

  void warning(String message, [String? exception, StackTrace? stackTrace]) {
    _talker.warning(_truncateIfNeeded(message), exception, stackTrace);
  }

  void handle(Object exception, [StackTrace? stackTrace, String? msg]) {
    _talker.handle(
        exception, stackTrace, msg != null ? _truncateIfNeeded(msg) : null);
  }

  // Allow access to underlying Talker if strictly necessary (e.g., TalkerScreen)
  Talker get talker => _talker;
}
