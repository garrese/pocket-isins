import 'package:isar/isar.dart';
import 'ticker.dart';

part 'position.g.dart';


@Collection(accessor: "positions")
@Name("Position")
class Position {
  Id id = Isar.autoIncrement;

  // The total capital invested in this transaction (in the Ticker's currency)
  double capitalInvested = 0.0;

  // The price of one share at the time of purchase
  double purchasePrice = 0.0;

  // Mathematical derivation to get the number of shares
  @ignore
  double get shares => purchasePrice > 0 ? capitalInvested / purchasePrice : 0.0;

  // Backlink to the parent Ticker
  @Backlink(to: 'positions')
  final ticker = IsarLink<Ticker>();
}
