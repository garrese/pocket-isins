import 'ticker.dart';

class Position {
  int id;
  double capitalInvested;
  double purchasePrice;

  Ticker? ticker;

  Position({
    this.id = 0,
    this.capitalInvested = 0.0,
    this.purchasePrice = 0.0,
    this.ticker,
  });

  double get shares =>
      purchasePrice > 0 ? capitalInvested / purchasePrice : 0.0;

  @override
  String toString() {
    return 'Position{id: $id, capitalInvested: $capitalInvested, purchasePrice: $purchasePrice, ticker: ${ticker?.symbol}}';
  }
}
