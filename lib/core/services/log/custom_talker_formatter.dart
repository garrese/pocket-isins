import 'package:talker_flutter/talker_flutter.dart';

class CustomTalkerFormatter implements LoggerFormatter {
  final bool Function() getEnableLongLogDetails;

  const CustomTalkerFormatter(this.getEnableLongLogDetails);

  @override
  String fmt(LogDetails details, TalkerLoggerSettings settings) {
    String msg = details.message.toString();

    if (!getEnableLongLogDetails() && msg.length > 5000) {
      msg = '${msg.substring(0, 5000)}...';
    }

    // Check if it's an HTTP request or response log by matching the title.
    if (msg.contains('[http-request]') || msg.contains('[http-response]')) {
      final parts = msg.split('\nData:');
      if (parts.length > 1) {
        // Find the next section (like Headers: or Redirects:) to append it back
        final afterData = parts[1].split(
          RegExp(r'\n(?=(Headers:|Redirects:))'),
        );
        if (afterData.length > 1) {
          return '${parts[0]}\nData: [Hidden in console]\n${afterData.sublist(1).join('\n')}';
        }
        return '${parts[0]}\nData: [Hidden in console]';
      }
    }

    return msg;
  }
}
