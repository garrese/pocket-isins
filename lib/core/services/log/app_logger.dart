import 'package:talker_flutter/talker_flutter.dart';
import '../../utils/toast_utils.dart';

class AppLogger {
  final Talker _talker;
  final bool Function() _getEnableLongLogDetails;

  AppLogger(this._talker, this._getEnableLongLogDetails);

  String _truncateMessage(String message) {
    if (!_getEnableLongLogDetails() && message.length > 5000) {
      return '${message.substring(0, 5000)}...';
    }
    return message;
  }

  void info(String message) {
    _talker.info(_truncateMessage(message));
  }

  void debug(String message) {
    _talker.debug(_truncateMessage(message));
  }

  void verbose(String message) {
    _talker.verbose(_truncateMessage(message));
  }

  void warning(String message, [String? exception, StackTrace? stackTrace]) {
    _talker.warning(_truncateMessage(message), exception, stackTrace);
  }

  void handle(Object exception, [StackTrace? stackTrace, String? msg]) {
    _talker.handle(exception, stackTrace, msg != null ? _truncateMessage(msg) : null);
    ToastUtils.show(null, 'An unexpected error occurred. Please check the logs.');
  }

  // Allow access to underlying Talker if strictly necessary (e.g., TalkerScreen)
  Talker get talker => _talker;
}
