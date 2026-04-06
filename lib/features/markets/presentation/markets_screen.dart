import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marquee/marquee.dart';

import 'package:intl/intl.dart';
import '../../../core/database/models/ticker.dart';
import '../data/markets_provider.dart';
import 'screens/ticker_detail_screen.dart';
import '../../../core/theme/app_drawer.dart';
import 'models/ticker_view_model.dart';

final sortGroupedByStateProvider = StateProvider<bool>((ref) => true);

class MarketsScreen extends ConsumerWidget {
  const MarketsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketsAsync = ref.watch(marketsProvider);
    final sortGroupedByState = ref.watch(sortGroupedByStateProvider);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        actions: [
          PopupMenuButton<bool>(
            icon: const Icon(Icons.sort),
            tooltip: 'Sort options',
            onSelected: (bool value) {
              ref.read(sortGroupedByStateProvider.notifier).state = value;
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<bool>>[
              CheckedPopupMenuItem<bool>(
                value: true,
                checked: sortGroupedByState,
                child: const Text('Group by Open State'),
              ),
              CheckedPopupMenuItem<bool>(
                value: false,
                checked: !sortGroupedByState,
                child: const Text('Sort by Daily Growth'),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh market data',
            onPressed: () {
              ref.read(marketsProvider.notifier).forceRefresh();
            },
          ),
        ],
      ),
      body: marketsAsync.when(
        data: (isins) {
          if (isins.isEmpty) {
            return const Center(child: Text('No ISINs in your portfolio.'));
          }

          final List<TickerViewModel> allTickers = [];
          for (final isin in isins) {
            for (final ticker in isin.tickers) {
              final cache = ticker.marketDataCache;
              double variation = 0.0;
              double variationPercent = 0.0;
              if (cache != null) {
                variation = cache.regularMarketPrice - cache.chartPreviousClose;
                variationPercent = cache.chartPreviousClose > 0
                    ? (variation / cache.chartPreviousClose) * 100
                    : 0.0;
              }

              allTickers.add(
                TickerViewModel(
                  isin: isin,
                  ticker: ticker,
                  variationPercent: variationPercent,
                  variation: variation,
                  state: _getMarketState(ticker),
                ),
              );
            }
          }

          allTickers.sort((a, b) {
            if (sortGroupedByState) {
              // Group 1: Open, Group 2: Not open
              final aIsOpen = a.state == MarketState.open;
              final bIsOpen = b.state == MarketState.open;

              if (aIsOpen && !bIsOpen) {
                return -1;
              } else if (!aIsOpen && bIsOpen) {
                return 1;
              }
            }

            // Sort by daily variation descending
            return b.variationPercent.compareTo(a.variationPercent);
          });

          return LayoutBuilder(
            builder: (context, constraints) {
              final double availableWidth =
                  constraints.maxWidth - 16; // 8 padding on each side
              int crossAxisCount =
                  (availableWidth + 8) ~/ 368; // 360 width + 8 spacing
              if (crossAxisCount < 1) crossAxisCount = 1;

              final List<List<TickerViewModel>> chunks = [];
              for (int i = 0; i < allTickers.length; i += crossAxisCount) {
                chunks.add(
                  allTickers.sublist(
                    i,
                    i + crossAxisCount > allTickers.length
                        ? allTickers.length
                        : i + crossAxisCount,
                  ),
                );
              }

              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 16.0,
                  ),
                  child: Column(
                    children: chunks.map((rowTickers) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: rowTickers.map((tickerVm) {
                              final cache = tickerVm.ticker.marketDataCache;

                              Widget innerContent;
                              if (cache == null) {
                                innerContent = ListTile(
                                  title: Text(tickerVm.ticker.symbol),
                                  subtitle: const Text(
                                    'Data not available. Invalid ticker or not found on Yahoo.',
                                    style: TextStyle(color: Colors.redAccent),
                                  ),
                                  trailing: const Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                  ),
                                );
                              } else {
                                final isPositive = tickerVm.variation >= 0;
                                final color =
                                    isPositive ? Colors.green : Colors.red;

                                innerContent = InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => TickerDetailScreen(
                                          symbol: tickerVm.ticker.symbol,
                                          displayName:
                                              tickerVm.isin.displayName,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 6,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Header Row: ISIN Name + State
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: _buildMarqueeText(
                                                context,
                                                tickerVm.isin.displayName,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxWidth: (availableWidth < 360
                                                        ? availableWidth
                                                        : 360) -
                                                    80,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              _getMarketStateLabel(
                                                tickerVm.state,
                                              ),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: _getMarketStateColor(
                                                  tickerVm.state,
                                                  context,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        // Ticker Details + Sparkline
                                        Expanded(
                                          child: Row(
                                            children: [
                                              // Ticker Info
                                              SizedBox(
                                                width: 110,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    _buildMarqueeText(
                                                      context,
                                                      tickerVm.ticker.symbol,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                      maxWidth: 110.0,
                                                    ),
                                                    _buildMarqueeText(
                                                      context,
                                                      '${cache.regularMarketPrice.toStringAsFixed(2)} ${tickerVm.ticker.currency}',
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                      ),
                                                      maxWidth: 110.0,
                                                    ),
                                                    _buildMarqueeText(
                                                      context,
                                                      '${isPositive ? '+' : ''}${tickerVm.variation.toStringAsFixed(2)} (${tickerVm.variationPercent.toStringAsFixed(2)}%)',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: color,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      maxWidth: 110.0,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              // Sparkline Chart
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
                                      ],
                                    ),
                                  ),
                                );
                              }

                              return Padding(
                                padding: EdgeInsets.only(
                                  right: tickerVm == rowTickers.last ? 0 : 8.0,
                                ),
                                child: SizedBox(
                                  width: availableWidth < 360
                                      ? availableWidth
                                      : 360,
                                  child: Card(
                                    margin: EdgeInsets.zero,
                                    child: innerContent,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
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

  String _getMarketStateLabel(MarketState state) {
    switch (state) {
      case MarketState.open:
        return 'Open';
      case MarketState.pre:
        return 'Premarket';
      case MarketState.post:
        return 'Postmarket';
      case MarketState.closed:
        return 'Closed';
    }
  }

  Color _getMarketStateColor(MarketState state, BuildContext context) {
    if (state == MarketState.open) {
      return Colors.amber;
    }
    return Colors.grey;
  }

  MarketState _getMarketState(Ticker ticker) {
    final now = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;

    final cache = ticker.marketDataCache;

    final regStart = cache?.regularMarketStart ?? ticker.regularMarketStart;
    final regEnd = cache?.regularMarketEnd ?? ticker.regularMarketEnd;
    final preStart = cache?.preMarketStart ?? ticker.preMarketStart;
    final preEnd = cache?.preMarketEnd ?? ticker.preMarketEnd;
    final postStart = cache?.postMarketStart ?? ticker.postMarketStart;
    final postEnd = cache?.postMarketEnd ?? ticker.postMarketEnd;

    if (regStart != null && regEnd != null) {
      if (now >= regStart && now <= regEnd) {
        return MarketState.open;
      }
    }

    if (preStart != null && preEnd != null) {
      if (now >= preStart && now <= preEnd) {
        return MarketState.pre;
      }
    }

    if (postStart != null && postEnd != null) {
      if (now >= postStart && now <= postEnd) {
        return MarketState.post;
      }
    }

    return MarketState.closed;
  }

  Widget _buildMarqueeText(
    BuildContext context,
    String text, {
    required TextStyle style,
    required double maxWidth,
  }) {
    // Measure the text width
    final textSpan = TextSpan(text: text, style: style);
    final textPainter = TextPainter(
      text: textSpan,
      maxLines: 1,
      textDirection: Directionality.of(context),
    )..layout(minWidth: 0, maxWidth: double.infinity);

    if (textPainter.size.width > maxWidth) {
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
