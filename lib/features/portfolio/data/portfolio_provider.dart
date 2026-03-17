import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/database/isar_service.dart';
import '../../../core/database/models/isin.dart';
import '../../../core/database/models/ticker.dart';
import '../../../core/database/models/position.dart';
import '../domain/portfolio_form_data.dart';

part 'portfolio_provider.g.dart';

@riverpod
class Portfolio extends _$Portfolio {
  @override
  Future<List<Isin>> build() async {
    return _fetchIsins();
  }

  Future<List<Isin>> _fetchIsins() async {
    final isar = ref.read(isarServiceProvider).db;
    final isins = await isar.isins.where().findAll();
    for (var isin in isins) {
      await isin.tickers.load();
      for (var ticker in isin.tickers) {
        await ticker.positions.load();
      }
    }
    return isins;
  }

  Future<void> saveIsin({
    int? id,
    required String isinCode,
    required String name,
    required List<TickerFormData> tickersData,
  }) async {
    final isar = ref.read(isarServiceProvider).db;

    await isar.writeTxn(() async {
      final isin = id != null ? await isar.isins.get(id) : Isin();
      if (isin == null) return;

      isin.isinCode = isinCode;
      isin.name = name;
      await isar.isins.put(isin);

      if (id != null) {
        await isin.tickers.load();
        
        // Identify and remove tickers that are no longer present
        final retainedSymbols = tickersData.map((e) => e.symbol).toSet();
        final toRemove = isin.tickers.where((t) => !retainedSymbols.contains(t.symbol)).toList();
        for (var t in toRemove) {
          await t.positions.load();
          for (var p in t.positions) {
            await isar.positions.delete(p.id);
          }
          await isar.tickers.delete(t.id);
          isin.tickers.remove(t);
        }
      }

      // Upsert current tickers and positions
      for (final tData in tickersData) {
        Ticker? ticker;
        if (id != null) {
          ticker = isin.tickers.cast<Ticker?>().firstWhere((t) => t?.symbol == tData.symbol, orElse: () => null);
        }
        
        if (ticker == null) {
          ticker = Ticker()
            ..symbol = tData.symbol
            ..isin.value = isin;
          isin.tickers.add(ticker);
        }
        
        ticker.exchange = tData.exchange;
        ticker.currency = tData.currency;
        await isar.tickers.put(ticker);

        await ticker.positions.load();
        
        // For simplicity in the dynamic form without position IDs, we replace all nested positions on save
        for (var oldPos in ticker.positions) {
           await isar.positions.delete(oldPos.id);
        }
        ticker.positions.clear();

        // Add positions
        for (final pData in tData.positions) {
          final pos = Position()
            ..capitalInvested = pData.capitalInvested
            ..purchasePrice = pData.purchasePrice
            ..ticker.value = ticker;
          await isar.positions.put(pos);
          ticker.positions.add(pos);
        }
        
        await ticker.positions.save();
      }
      
      await isin.tickers.save();
    });

    state = const AsyncValue.loading();
    state = AsyncValue.data(await _fetchIsins());
  }

  Future<void> removeIsin(int id) async {
    final isar = ref.read(isarServiceProvider).db;

    await isar.writeTxn(() async {
      final isin = await isar.isins.get(id);
      if (isin != null) {
        await isin.tickers.load();
        for (var ticker in isin.tickers) {
          await ticker.positions.load();
          for (var pos in ticker.positions) {
            await isar.positions.delete(pos.id);
          }
          await isar.tickers.delete(ticker.id);
        }
        await isar.isins.delete(id);
      }
    });

    state = const AsyncValue.loading();
    state = AsyncValue.data(await _fetchIsins());
  }
}
