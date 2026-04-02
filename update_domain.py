file_path = "lib/features/portfolio/domain/portfolio_form_data.dart"
with open(file_path, "w") as f:
    f.write("""import 'package:flutter/foundation.dart';

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

  TickerFormData clone() {
    return TickerFormData(
      symbol: symbol,
      exchange: exchange,
      currency: currency,
      quoteType: quoteType,
      regularMarketStart: regularMarketStart,
      regularMarketEnd: regularMarketEnd,
      preMarketStart: preMarketStart,
      preMarketEnd: preMarketEnd,
      postMarketStart: postMarketStart,
      postMarketEnd: postMarketEnd,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TickerFormData &&
      other.symbol == symbol &&
      other.exchange == exchange &&
      other.currency == currency &&
      other.quoteType == quoteType &&
      other.regularMarketStart == regularMarketStart &&
      other.regularMarketEnd == regularMarketEnd &&
      other.preMarketStart == preMarketStart &&
      other.preMarketEnd == preMarketEnd &&
      other.postMarketStart == postMarketStart &&
      other.postMarketEnd == postMarketEnd;
  }

  @override
  int get hashCode {
    return symbol.hashCode ^
      exchange.hashCode ^
      currency.hashCode ^
      quoteType.hashCode ^
      regularMarketStart.hashCode ^
      regularMarketEnd.hashCode ^
      preMarketStart.hashCode ^
      preMarketEnd.hashCode ^
      postMarketStart.hashCode ^
      postMarketEnd.hashCode;
  }
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

  IsinFormData clone() {
    return IsinFormData(
      id: id,
      isinCode: isinCode,
      altName: altName,
      registeredNames: List<String>.from(registeredNames),
      shortName: shortName,
      tickers: tickers.map((t) => t.clone()).toList(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is IsinFormData &&
      other.id == id &&
      other.isinCode == isinCode &&
      other.altName == altName &&
      listEquals(other.registeredNames, registeredNames) &&
      other.shortName == shortName &&
      listEquals(other.tickers, tickers);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      isinCode.hashCode ^
      altName.hashCode ^
      registeredNames.hashCode ^
      shortName.hashCode ^
      tickers.hashCode;
  }
}
""")
