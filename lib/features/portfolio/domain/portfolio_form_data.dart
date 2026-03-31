class TickerFormData {
  String symbol;
  String exchange;
  String? currency;
  String? quoteType;
  int? regularMarketStart;
  int? regularMarketEnd;
  int? preMarketStart;
  int? preMarketEnd;
  int? postMarketStart;
  int? postMarketEnd;

  TickerFormData({
    this.symbol = '',
    this.exchange = 'UNKNOWN',
    this.currency,
    this.quoteType,
    this.regularMarketStart,
    this.regularMarketEnd,
    this.preMarketStart,
    this.preMarketEnd,
    this.postMarketStart,
    this.postMarketEnd,
  });
}

class IsinFormData {
  int? id;
  String isinCode;
  String altName;
  List<String> registeredNames;
  String? shortName;
  List<TickerFormData> tickers;

  IsinFormData({
    this.id,
    this.isinCode = '',
    this.altName = '',
    List<String>? registeredNames,
    this.shortName,
    List<TickerFormData>? tickers,
  })  : registeredNames = registeredNames ?? [],
        tickers = tickers ?? [];
}
