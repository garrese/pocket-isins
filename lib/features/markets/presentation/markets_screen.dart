import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marquee/marquee.dart';

import 'package:intl/intl.dart';
import '../../../core/database/models/isin.dart';
import '../data/markets_provider.dart';
import 'screens/ticker_detail_screen.dart';

class MarketsScreen extends ConsumerWidget {
  const MarketsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketsAsync = ref.watch(marketsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Markets Overview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh market data',
            onPressed: () => ref.read(marketsProvider.notifier).forceRefresh(),
          ),
        ],
      ),
      body: marketsAsync.when(
        data: (isins) {
          if (isins.isEmpty) {
            return const Center(child: Text('No ISINs in your portfolio.'));
          }

          final sortedIsins = List<Isin>.from(isins);
          sortedIsins.sort((a, b) {
            final varA = _getRepresentativeVariation(a);
            final varB = _getRepresentativeVariation(b);
            // Descending order: highest positive first
            return varB.compareTo(varA);
          });

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                spacing: 16.0,
                runSpacing: 16.0,
                alignment: WrapAlignment.center,
                children: sortedIsins.map((isin) {
                  return Container(
                    width: 360,
                    constraints: const BoxConstraints(maxWidth: 360),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4.0,
                            horizontal: 4.0,
                          ),
                          child: Text(
                            isin.displayName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ...isin.tickers.map((ticker) {
                          final cache = ticker.marketDataCache.value;
                          if (cache == null) {
                            return Card(
                              margin: const EdgeInsets.only(bottom: 4),
                              child: ListTile(
                                title: Text(ticker.symbol),
                                subtitle: const Text(
                                  'Data not available. Invalid ticker or not found on Yahoo.',
                                  style: TextStyle(color: Colors.redAccent),
                                ),
                                trailing: const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                ),
                              ),
                            );
                          }

                          final variation =
                              cache.regularMarketPrice -
                              cache.chartPreviousClose;
                          final variationPercent =
                              (variation / cache.chartPreviousClose) * 100;
                          final isPositive = variation >= 0;
                          final color = isPositive ? Colors.green : Colors.red;

                          return Card(
                            margin: const EdgeInsets.only(bottom: 4),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => TickerDetailScreen(
                                      symbol: ticker.symbol,
                                      displayName: isin.displayName,
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    // Ticker Info
                                    SizedBox(
                                      width: 110,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildMarqueeText(
                                            ticker.symbol,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          _buildMarqueeText(
                                            '${cache.regularMarketPrice.toStringAsFixed(2)} ${ticker.currency}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                          _buildMarqueeText(
                                            '${isPositive ? '+' : ''}${variation.toStringAsFixed(2)} (${variationPercent.toStringAsFixed(2)}%)',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: color,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // Sparkline Chart (Level 2)
                                    Expanded(
                                      child: SizedBox(
                                        height: 50,
                                        child: _buildSparkline(
                                          cache.intradayPrices,
                                          cache.intradayTimestamps,
                                          color,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 8),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) {
          debugPrint('MarketsScreen Error: $err');
          debugPrint('Stacktrace: $stack');
          return Center(child: Text('Error: $err'));
        },
      ),
    );
  }

  double _getRepresentativeVariation(Isin isin) {
    if (isin.tickers.isEmpty) return 0.0;

    double variation = 0.0;
    int mostRecentTimestamp = -1;

    for (final ticker in isin.tickers) {
      final cache = ticker.marketDataCache.value;
      if (cache == null) continue;

      int lastTs = -1;
      if (cache.intradayTimestamps.isNotEmpty) {
        lastTs = cache.intradayTimestamps.lastWhere(
          (ts) => ts > 0,
          orElse: () => -1,
        );
      }

      if (lastTs > mostRecentTimestamp) {
        mostRecentTimestamp = lastTs;
        if (cache.chartPreviousClose > 0) {
          final diff = cache.regularMarketPrice - cache.chartPreviousClose;
          variation = (diff / cache.chartPreviousClose) * 100;
        } else {
          variation = 0.0;
        }
      }
    }

    return variation;
  }

  Widget _buildMarqueeText(String text, {required TextStyle style}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Measure the text width
        final textSpan = TextSpan(text: text, style: style);
        final textPainter = TextPainter(
          text: textSpan,
          maxLines: 1,
          textDirection: Directionality.of(context),
        )..layout(minWidth: 0, maxWidth: double.infinity);

        if (textPainter.size.width > constraints.maxWidth) {
          // If text is wider than container, use Marquee
          return SizedBox(
            height: style.fontSize != null ? style.fontSize! * 1.5 : 20,
            child: Marquee(
              text: text,
              style: style,
              scrollAxis: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.start,
              blankSpace: 20.0,
              velocity: 30.0,
              pauseAfterRound: const Duration(seconds: 1),
              startPadding: 0.0,
              accelerationDuration: const Duration(milliseconds: 500),
              accelerationCurve: Curves.linear,
              decelerationDuration: const Duration(milliseconds: 500),
              decelerationCurve: Curves.easeOut,
            ),
          );
        } else {
          // If it fits, just display the normal Text
          return Text(text, style: style, overflow: TextOverflow.ellipsis);
        }
      },
    );
  }

  Widget _buildSparkline(
    List<double> prices,
    List<int> timestamps,
    Color color,
  ) {
    if (prices.length < 2) return const SizedBox.shrink();

    final minPrice = prices.reduce((a, b) => a < b ? a : b);
    final maxPrice = prices.reduce((a, b) => a > b ? a : b);

    final List<FlSpot> spots = [];
    for (int i = 0; i < prices.length; i++) {
      if (i < timestamps.length) {
        spots.add(FlSpot(timestamps[i].toDouble(), prices[i]));
      }
    }

    if (spots.isEmpty) return const SizedBox.shrink();

    final minX = spots.first.x;
    final maxX = spots.last.x;

    String firstTime = '';
    String lastTime = '';

    if (timestamps.isNotEmpty) {
      // Find first non-zero timestamp
      int firstTs = timestamps.firstWhere((ts) => ts > 0, orElse: () => 0);
      int lastTs = timestamps.lastWhere((ts) => ts > 0, orElse: () => 0);

      if (firstTs > 0) {
        firstTime = DateFormat(
          'HH:mm',
        ).format(DateTime.fromMillisecondsSinceEpoch(firstTs * 1000));
      }
      if (lastTs > 0) {
        lastTime = DateFormat(
          'HH:mm',
        ).format(DateTime.fromMillisecondsSinceEpoch(lastTs * 1000));
      }
    }

    return Stack(
      children: [
        LineChart(
          LineChartData(
            minX: minX,
            maxX: maxX,
            minY: minPrice,
            maxY: maxPrice,
            gridData: const FlGridData(show: false),
            titlesData: const FlTitlesData(show: false),
            borderData: FlBorderData(show: false),
            lineTouchData: const LineTouchData(enabled: false),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: false,
                color: color,
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: color.withValues(alpha: 0.1),
                ),
              ),
            ],
          ),
        ),
        if (firstTime.isNotEmpty)
          Positioned(
            left: 0,
            bottom: 0,
            child: Text(
              firstTime,
              style: TextStyle(fontSize: 9, color: Colors.grey.shade600),
            ),
          ),
        if (lastTime.isNotEmpty)
          Positioned(
            right: 0,
            bottom: 0,
            child: Text(
              lastTime,
              style: TextStyle(fontSize: 9, color: Colors.grey.shade600),
            ),
          ),
      ],
    );
  }
}
