import 'package:drift/drift.dart';
import 'package:pocket_isins/core/services/log/app_logger.dart';

DatabaseConnection connect([AppLogger? logger]) {
  throw UnsupportedError(
    'No suitable database implementation was found on this platform.',
  );
}
