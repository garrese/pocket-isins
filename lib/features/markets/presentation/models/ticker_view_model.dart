import '../../../../core/database/models/isin.dart';
import '../../../../core/database/models/ticker.dart';

enum MarketState { open, pre, post, closed }

class TickerViewModel {
  final Isin isin;
  final Ticker ticker;
  final double variationPercent;
  final double variation;
  final MarketState state;

  TickerViewModel({
    required this.isin,
    required this.ticker,
    required this.variationPercent,
    required this.variation,
    required this.state,
  });
}
