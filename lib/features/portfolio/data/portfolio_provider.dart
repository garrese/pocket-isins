import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/database/drift_service.dart';
import '../../../core/database/drift/app_database.dart' as drift;
import '../../../core/database/models/isin.dart';
import '../../../core/database/models/ticker.dart';
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
        'altName': isin.altName,
        'registeredNames': isin.registeredNames,
        'shortName': isin.shortName,
        'tickers': isin.tickers.map((t) {
          return {
            'symbol': t.symbol,
            'exchange': t.exchange,
            'currency': t.currency,
            'quoteType': t.quoteType,
            'regularMarketStart': t.regularMarketStart,
            'regularMarketEnd': t.regularMarketEnd,
            'preMarketStart': t.preMarketStart,
            'preMarketEnd': t.preMarketEnd,
            'postMarketStart': t.postMarketStart,
            'postMarketEnd': t.postMarketEnd,
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
        final altName = isinData['altName'] as String?;

        if (isinCode == null && altName == null) continue;

        // Check if an ISIN with this code already exists
        if (isinCode != null) {
          final existingIsin = await (db.select(
            db.isins,
          )..where((t) => t.isinCode.equals(isinCode)))
              .getSingleOrNull();
          if (existingIsin != null) continue;
        }

        final registeredNames = (isinData['registeredNames'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [];
        final shortName = isinData['shortName'] as String?;

        final newIsinId = await db.into(db.isins).insert(
              drift.IsinsCompanion.insert(
                isinCode: Value(isinCode),
                altName: Value(altName),
                registeredNames: Value(registeredNames),
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
          final currency = tData['currency'] as String?;
          final quoteType = tData['quoteType'] as String?;
          final regularMarketStart = tData['regularMarketStart'] as int?;
          final regularMarketEnd = tData['regularMarketEnd'] as int?;
          final preMarketStart = tData['preMarketStart'] as int?;
          final preMarketEnd = tData['preMarketEnd'] as int?;
          final postMarketStart = tData['postMarketStart'] as int?;
          final postMarketEnd = tData['postMarketEnd'] as int?;

          await db.into(db.tickers).insert(
                drift.TickersCompanion.insert(
                  symbol: symbol,
                  exchange: exchange,
                  currency: Value(currency),
                  quoteType: Value(quoteType),
                  regularMarketStart: Value(regularMarketStart),
                  regularMarketEnd: Value(regularMarketEnd),
                  preMarketStart: Value(preMarketStart),
                  preMarketEnd: Value(preMarketEnd),
                  postMarketStart: Value(postMarketStart),
                  postMarketEnd: Value(postMarketEnd),
                  isinId: newIsinId,
                ),
              );
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

    final List<Isin> isins = [];
    for (final isinRow in isinsData) {
      final isinModel = Isin(
        id: isinRow.id,
        isinCode: isinRow.isinCode,
        altName: isinRow.altName,
        registeredNames: isinRow.registeredNames,
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
          quoteType: tickerRow.quoteType,
          regularMarketStart: tickerRow.regularMarketStart,
          regularMarketEnd: tickerRow.regularMarketEnd,
          preMarketStart: tickerRow.preMarketStart,
          preMarketEnd: tickerRow.preMarketEnd,
          postMarketStart: tickerRow.postMarketStart,
          postMarketEnd: tickerRow.postMarketEnd,
          isin: isinModel,
        );

        isinModel.tickers.add(tickerModel);
      }
      isins.add(isinModel);
    }
    return isins;
  }

  Future<void> saveIsin({
    int? id,
    String? isinCode,
    String? altName,
    List<String> registeredNames = const [],
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
            isinCode: Value(isinCode != null && isinCode.trim().isNotEmpty ? isinCode : null),
            altName: Value(altName != null && altName.trim().isNotEmpty ? altName : null),
            registeredNames: Value(registeredNames),
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
          await (db.delete(db.tickers)..where((t2) => t2.id.equals(t.id))).go();
        }
      } else {
        currentIsinId = await db.into(db.isins).insert(
              drift.IsinsCompanion.insert(
                isinCode: Value(isinCode != null && isinCode.trim().isNotEmpty ? isinCode : null),
                altName: Value(altName != null && altName.trim().isNotEmpty ? altName : null),
                registeredNames: Value(registeredNames),
                shortName: Value(shortName),
              ),
            );
      }

      // Upsert current tickers
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

        if (tickerRow == null) {
          await db.into(db.tickers).insert(
                drift.TickersCompanion.insert(
                  symbol: tData.symbol,
                  exchange: tData.exchange,
                  currency: Value(tData.currency),
                  quoteType: Value(tData.quoteType),
                  regularMarketStart: Value(tData.regularMarketStart),
                  regularMarketEnd: Value(tData.regularMarketEnd),
                  preMarketStart: Value(tData.preMarketStart),
                  preMarketEnd: Value(tData.preMarketEnd),
                  postMarketStart: Value(tData.postMarketStart),
                  postMarketEnd: Value(tData.postMarketEnd),
                  isinId: currentIsinId,
                ),
              );
        } else {
          int currentTickerId = tickerRow.id;
          await (db.update(
            db.tickers,
          )..where((t) => t.id.equals(currentTickerId)))
              .write(
            drift.TickersCompanion(
              exchange: Value(tData.exchange),
              currency: Value(tData.currency),
              quoteType: Value(tData.quoteType),
              regularMarketStart: Value(tData.regularMarketStart),
              regularMarketEnd: Value(tData.regularMarketEnd),
              preMarketStart: Value(tData.preMarketStart),
              preMarketEnd: Value(tData.preMarketEnd),
              postMarketStart: Value(tData.postMarketStart),
              postMarketEnd: Value(tData.postMarketEnd),
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
