class LogMessage {
  final DateTime timestamp;
  final int level; // 0: VERBOSE, 1: DEBUG, 2: INFO, 3: WARNING, 4: ERROR
  final String message;
  final String? error;

  LogMessage({
    required this.timestamp,
    required this.level,
    required this.message,
    this.error,
  });
}
