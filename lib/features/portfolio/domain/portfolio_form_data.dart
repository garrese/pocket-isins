class PositionFormData {
  double capitalInvested;
  double purchasePrice;

  PositionFormData({this.capitalInvested = 0.0, this.purchasePrice = 0.0});
}

class TickerFormData {
  String symbol;
  String exchange;
  String currency;
  List<PositionFormData> positions;

  TickerFormData({
    this.symbol = '',
    this.exchange = 'UNKNOWN',
    this.currency = '',
    List<PositionFormData>? positions,
  }) : positions = positions ?? [];
}
