import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/database/isar_service.dart';
import '../../../core/database/models/isin.dart';
import '../../../core/database/models/ticker.dart';

part 'portfolio_provider.g.dart';

@riverpod
class Portfolio extends _$Portfolio {
  @override
  Future<List<Isin>> build() async {
    return _fetchIsins();
  }

  Future<List<Isin>> _fetchIsins() async {
    final isar = ref.read(isarServiceProvider).db;
    // We load all Isins. Also we need to make sure the tickers are loaded.
    // In Isar, IsarLinks are loaded lazily, so we might need to load them if accessed,
    // but put/putAll with save() populates them.
    final isins = await isar.isins.where().findAll();
    for (var isin in isins) {
      await isin.tickers.load();
    }
    return isins;
  }

  Future<void> addIsin(String isinCode, String name, double position, double purchasePrice, String currency, List<String> newTickers) async {
    final isar = ref.read(isarServiceProvider).db;

    final newIsin = Isin()
      ..isinCode = isinCode
      ..name = name
      ..position = position
      ..purchasePrice = purchasePrice
      ..currency = currency;

    await isar.writeTxn(() async {
      await isar.isins.put(newIsin);

      if (newTickers.isNotEmpty) {
        final tickersObj = newTickers.map((t) => Ticker()
          ..symbol = t
          ..exchange = 'UNKNOWN'
          ..currency = currency
          ..isin.value = newIsin).toList();
        
        await isar.tickers.putAll(tickersObj);
        newIsin.tickers.addAll(tickersObj);
        await newIsin.tickers.save();
      }
    });

    // Refresh state
    state = const AsyncValue.loading();
    state = AsyncValue.data(await _fetchIsins());
  }

  Future<void> removeIsin(int id) async {
    final isar = ref.read(isarServiceProvider).db;

    await isar.writeTxn(() async {
      // Deleting an Isin also requires deleting or unlinking its Tickers
      final isin = await isar.isins.get(id);
      if (isin != null) {
        await isin.tickers.load();
        // Delete all associated tickers
        for (var ticker in isin.tickers) {
          await isar.tickers.delete(ticker.id);
        }
        await isar.isins.delete(id);
      }
    });

    // Refresh state
    state = const AsyncValue.loading();
    state = AsyncValue.data(await _fetchIsins());
  }

  Future<void> editIsin(int id, String name, double position, double purchasePrice, String currency, List<String> currentTickers) async {
    final isar = ref.read(isarServiceProvider).db;

    await isar.writeTxn(() async {
      final isin = await isar.isins.get(id);
      if (isin != null) {
        isin.name = name;
        isin.position = position;
        isin.purchasePrice = purchasePrice;
        isin.currency = currency;
        await isar.isins.put(isin);

        await isin.tickers.load();
        
        // Remove tickers that are no longer in the list
        final toRemove = isin.tickers.where((t) => !currentTickers.contains(t.symbol)).toList();
        for (var t in toRemove) {
          await isar.tickers.delete(t.id);
          isin.tickers.remove(t);
        }

        // Add new tickers that are not in the database yet
        final existingSymbols = isin.tickers.map((t) => t.symbol).toSet();
        final toAddSymbols = currentTickers.where((sym) => !existingSymbols.contains(sym)).toList();
        
        if (toAddSymbols.isNotEmpty) {
          final newObjs = toAddSymbols.map((sym) => Ticker()
            ..symbol = sym
            ..exchange = 'UNKNOWN'
            ..currency = currency
            ..isin.value = isin).toList();

          await isar.tickers.putAll(newObjs);
          isin.tickers.addAll(newObjs);
        }

        await isin.tickers.save();
      }
    });

    // Refresh state
    state = const AsyncValue.loading();
    state = AsyncValue.data(await _fetchIsins());
  }
}
