import 'dart:convert';
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

  Future<String> exportPortfolio() async {
      final isins = await _fetchIsins();
      final List<Map<String, dynamic>> exportData = [];

      for (var isin in isins) {
        final isinMap = {
          'isinCode': isin.isinCode,
          'name': isin.name,
          'shortName': isin.shortName,
          'tickers': isin.tickers.map((t) {
            return {
              'symbol': t.symbol,
              'exchange': t.exchange,
              'currency': t.currency,
              'positions': t.positions.map((p) {
                return {
                  'capitalInvested': p.capitalInvested,
                  'purchasePrice': p.purchasePrice,
                };
              }).toList(),
            };
          }).toList(),
        };
        exportData.add(isinMap);
      }

      return jsonEncode(exportData);
    }

    Future<void> importPortfolio(String jsonString) async {
      final isar = ref.read(isarServiceProvider).db;
      List<dynamic> importData = [];
      try {
        importData = jsonDecode(jsonString);
      } catch (e) {
        throw Exception('Invalid JSON format');
      }

      await isar.writeTxn(() async {
        for (var isinData in importData) {
          if (isinData is! Map<String, dynamic>) continue;

          final isinCode = isinData['isinCode'] as String?;
          if (isinCode == null) continue;

          // Check if an ISIN with this code already exists
          final existingIsin =
              await isar.isins.filter().isinCodeEqualTo(isinCode).findFirst();
          if (existingIsin != null) {
            // Conflict: we skip this ISIN
            continue;
          }

          final name = isinData['name'] as String? ?? 'Unknown';
          final shortName = isinData['shortName'] as String?;

          final newIsin = Isin()
            ..isinCode = isinCode
            ..name = name
            ..shortName = shortName;

          await isar.isins.put(newIsin);

          final tickersData = isinData['tickers'] as List<dynamic>? ?? [];
          for (var tData in tickersData) {
            if (tData is! Map<String, dynamic>) continue;

            final symbol = tData['symbol'] as String?;
            if (symbol == null) continue;

            // Check for ticker conflict. If symbol already exists, we skip creating it to prevent unique constraint errors
            // Ideally symbols should be unique system-wide, but since it's linked to a new ISIN,
            // a conflict here means the export is corrupted or there's a symbol collision.
            final existingTicker =
                await isar.tickers.filter().symbolEqualTo(symbol).findFirst();
            if (existingTicker != null) continue;

            final exchange = tData['exchange'] as String? ?? '';
            final currency = tData['currency'] as String? ?? 'USD';

            final newTicker = Ticker()
              ..symbol = symbol
              ..exchange = exchange
              ..currency = currency
              ..isin.value = newIsin;

            await isar.tickers.put(newTicker);
            newIsin.tickers.add(newTicker);

            final positionsData = tData['positions'] as List<dynamic>? ?? [];
            for (var pData in positionsData) {
              if (pData is! Map<String, dynamic>) continue;

              final capitalInvested =
                  (pData['capitalInvested'] as num?)?.toDouble() ?? 0.0;
              final purchasePrice =
                  (pData['purchasePrice'] as num?)?.toDouble() ?? 0.0;

              final newPos = Position()
                ..capitalInvested = capitalInvested
                ..purchasePrice = purchasePrice
                ..ticker.value = newTicker;

              await isar.positions.put(newPos);
              newTicker.positions.add(newPos);
            }
            await newTicker.positions.save();
          }
          await newIsin.tickers.save();
        }
      });

      state = const AsyncValue.loading();
      state = AsyncValue.data(await _fetchIsins());
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
    String? shortName,
    required List<TickerFormData> tickersData,
  }) async {
    final isar = ref.read(isarServiceProvider).db;

    await isar.writeTxn(() async {
      final isin = id != null ? await isar.isins.get(id) : Isin();
      if (isin == null) return;

      isin.isinCode = isinCode;
      isin.name = name;
      isin.shortName = shortName;
      await isar.isins.put(isin);

      if (id != null) {
        await isin.tickers.load();

        // Identify and remove tickers that are no longer present
        final retainedSymbols = tickersData.map((e) => e.symbol).toSet();
        final toRemove = isin.tickers
            .where((t) => !retainedSymbols.contains(t.symbol))
            .toList();
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
          ticker = isin.tickers
              .cast<Ticker?>()
              .firstWhere((t) => t?.symbol == tData.symbol, orElse: () => null);
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
