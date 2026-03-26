sed -i 's/import '\''dio_provider.dart'\'';/import '\''dio_provider.dart'\'';\nimport '\''..\/services\/log\/log_service.dart'\'';/' lib/core/network/market_data_service.dart

sed -i 's/    ref.watch(dioProvider),/    ref.watch(dioProvider),\n    ref.watch(logServiceProvider.notifier),/' lib/core/network/market_data_service.dart

sed -i 's/  final Dio _dio;/  final Dio _dio;\n  final LogService _log;/' lib/core/network/market_data_service.dart

sed -i 's/  MarketDataService(this._dio);/  MarketDataService(this._dio, this._log);/' lib/core/network/market_data_service.dart

sed -i 's/      if (response.statusCode == 200) {/      _log.info('\''Fetching ticker data for $symbol'\'');\n      if (response.statusCode == 200) {/' lib/core/network/market_data_service.dart
