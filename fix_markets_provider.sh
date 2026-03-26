sed -i 's/fetchHistoricalData(isin.defaultTicker, '\''.*\'', '\''.*'\'')/fetchHistoricalData(isin.defaultTicker, range: '\''1mo'\'')/' lib/features/markets/data/markets_provider.dart
sed -i 's/fetchHistoricalData(symbol, '\''.*\'', '\''.*'\'')/fetchHistoricalData(symbol, range: '\''1mo'\'')/' lib/features/markets/data/ticker_detail_provider.dart
