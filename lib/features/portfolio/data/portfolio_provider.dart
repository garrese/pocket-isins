import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/database/drift_service.dart';
import '../../../core/database/drift/app_database.dart' as drift;
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
    final db = ref.read(driftServiceProvider).db;
    List<dynamic> importData = [];
    try {
      importData = jsonDecode(jsonString);
    } catch (e) {
      throw Exception('Invalid JSON format');
    }

    await db.transaction(() async {
      for (var isinData in importData) {
        if (isinData is! Map<String, dynamic>) continue;

        final isinCode = isinData['isinCode'] as String?;
        if (isinCode == null) continue;

        // Check if an ISIN with this code already exists
        final existingIsin = await (db.select(
          db.isins,
        )..where((t) => t.isinCode.equals(isinCode)))
            .getSingleOrNull();
        if (existingIsin != null) continue;

        final name = isinData['name'] as String? ?? 'Unknown';
        final shortName = isinData['shortName'] as String?;

        final newIsinId = await db.into(db.isins).insert(
              drift.IsinsCompanion.insert(
                isinCode: isinCode,
                name: name,
                shortName: Value(shortName),
              ),
            );

        final tickersData = isinData['tickers'] as List<dynamic>? ?? [];
        for (var tData in tickersData) {
          if (tData is! Map<String, dynamic>) continue;

          final symbol = tData['symbol'] as String?;
          if (symbol == null) continue;

          final existingTicker = await (db.select(
            db.tickers,
          )..where((t) => t.symbol.equals(symbol)))
              .getSingleOrNull();
          if (existingTicker != null) continue;

          final exchange = tData['exchange'] as String? ?? '';
          final currency = tData['currency'] as String? ?? 'USD';

          final newTickerId = await db.into(db.tickers).insert(
                drift.TickersCompanion.insert(
                  symbol: symbol,
                  exchange: exchange,
                  currency: currency,
                  isinId: newIsinId,
                ),
              );

          final positionsData = tData['positions'] as List<dynamic>? ?? [];
          for (var pData in positionsData) {
            if (pData is! Map<String, dynamic>) continue;

            final capitalInvested =
                (pData['capitalInvested'] as num?)?.toDouble() ?? 0.0;
            final purchasePrice =
                (pData['purchasePrice'] as num?)?.toDouble() ?? 0.0;

            await db.into(db.positions).insert(
                  drift.PositionsCompanion.insert(
                    capitalInvested: Value(capitalInvested),
                    purchasePrice: Value(purchasePrice),
                    tickerId: newTickerId,
                  ),
                );
          }
        }
      }
    });

    state = const AsyncValue.loading();
    state = AsyncValue.data(await _fetchIsins());
  }

  Future<List<Isin>> _fetchIsins() async {
    final db = ref.read(driftServiceProvider).db;

    final isinsData = await db.select(db.isins).get();
    final allTickersData = await db.select(db.tickers).get();
    final allPositionsData = await db.select(db.positions).get();

    final List<Isin> isins = [];
    for (final isinRow in isinsData) {
      final isinModel = Isin(
        id: isinRow.id,
        isinCode: isinRow.isinCode,
        name: isinRow.name,
        shortName: isinRow.shortName,
        tickers: [],
      );

      final isinTickers =
          allTickersData.where((t) => t.isinId == isinRow.id).toList();
      for (final tickerRow in isinTickers) {
        final tickerModel = Ticker(
          id: tickerRow.id,
          symbol: tickerRow.symbol,
          exchange: tickerRow.exchange,
          currency: tickerRow.currency,
          isin: isinModel,
          positions: [],
        );

        final tickerPositions =
            allPositionsData.where((p) => p.tickerId == tickerRow.id).toList();
        for (final posRow in tickerPositions) {
          tickerModel.positions.add(
            Position(
              id: posRow.id,
              capitalInvested: posRow.capitalInvested,
              purchasePrice: posRow.purchasePrice,
              ticker: tickerModel,
            ),
          );
        }
        isinModel.tickers.add(tickerModel);
      }
      isins.add(isinModel);
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
    final db = ref.read(driftServiceProvider).db;

    await db.transaction(() async {
      int currentIsinId;

      if (id != null) {
        currentIsinId = id;
        await (db.update(db.isins)..where((t) => t.id.equals(id))).write(
          drift.IsinsCompanion(
            isinCode: Value(isinCode),
            name: Value(name),
            shortName: Value(shortName),
          ),
        );

        // Identify and remove tickers that are no longer present
        final retainedSymbols = tickersData.map((e) => e.symbol).toSet();
        final currentTickers = await (db.select(
          db.tickers,
        )..where((t) => t.isinId.equals(id)))
            .get();
        final toRemove = currentTickers
            .where((t) => !retainedSymbols.contains(t.symbol))
            .toList();

        for (final t in toRemove) {
          await (db.delete(
            db.positions,
          )..where((p) => p.tickerId.equals(t.id)))
              .go();
          await (db.delete(db.tickers)..where((t2) => t2.id.equals(t.id))).go();
        }
      } else {
        currentIsinId = await db.into(db.isins).insert(
              drift.IsinsCompanion.insert(
                isinCode: isinCode,
                name: name,
                shortName: Value(shortName),
              ),
            );
      }

      // Upsert current tickers and positions
      for (final tData in tickersData) {
        drift.TickerData? tickerRow;

        if (id != null) {
          tickerRow = await (db.select(db.tickers)
                ..where(
                  (t) =>
                      t.isinId.equals(currentIsinId) &
                      t.symbol.equals(tData.symbol),
                ))
              .getSingleOrNull();
        }

        int currentTickerId;
        if (tickerRow == null) {
          currentTickerId = await db.into(db.tickers).insert(
                drift.TickersCompanion.insert(
                  symbol: tData.symbol,
                  exchange: tData.exchange,
                  currency: tData.currency,
                  isinId: currentIsinId,
                ),
              );
        } else {
          currentTickerId = tickerRow.id;
          await (db.update(
            db.tickers,
          )..where((t) => t.id.equals(currentTickerId)))
              .write(
            drift.TickersCompanion(
              exchange: Value(tData.exchange),
              currency: Value(tData.currency),
            ),
          );
        }

        // For simplicity in the dynamic form without position IDs, we replace all nested positions on save
        await (db.delete(
          db.positions,
        )..where((p) => p.tickerId.equals(currentTickerId)))
            .go();

        // Add positions
        for (final pData in tData.positions) {
          await db.into(db.positions).insert(
                drift.PositionsCompanion.insert(
                  capitalInvested: Value(pData.capitalInvested),
                  purchasePrice: Value(pData.purchasePrice),
                  tickerId: currentTickerId,
                ),
              );
        }
      }
    });

    state = const AsyncValue.loading();
    state = AsyncValue.data(await _fetchIsins());
  }

  Future<void> removeIsin(int id) async {
    final db = ref.read(driftServiceProvider).db;

    await db.transaction(() async {
      final tickers = await (db.select(
        db.tickers,
      )..where((t) => t.isinId.equals(id)))
          .get();
      for (final tickerRow in tickers) {
        await (db.delete(
          db.positions,
        )..where((p) => p.tickerId.equals(tickerRow.id)))
            .go();
        await (db.delete(
          db.marketDataCaches,
        )..where((c) => c.tickerId.equals(tickerRow.id)))
            .go();
        await (db.delete(
          db.tickers,
        )..where((t) => t.id.equals(tickerRow.id)))
            .go();
      }
      await (db.delete(db.isins)..where((i) => i.id.equals(id))).go();
    });

    state = const AsyncValue.loading();
    state = AsyncValue.data(await _fetchIsins());
  }
}
