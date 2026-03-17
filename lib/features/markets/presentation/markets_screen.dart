import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: isins.length,
            itemBuilder: (context, index) {
              final isin = isins[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      isin.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ...isin.tickers.map((ticker) {
                    final cache = ticker.marketDataCache.value;
                    if (cache == null) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(ticker.symbol),
                          subtitle: const Text(
                              'Data not available. Invalid ticker or not found on Yahoo.',
                              style: TextStyle(color: Colors.redAccent)),
                          trailing: const Icon(Icons.error_outline,
                              color: Colors.red),
                        ),
                      );
                    }

                    final variation =
                        cache.regularMarketPrice - cache.chartPreviousClose;
                    final variationPercent =
                        (variation / cache.chartPreviousClose) * 100;
                    final isPositive = variation >= 0;
                    final color = isPositive ? Colors.green : Colors.red;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  TickerDetailScreen(symbol: ticker.symbol),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              // Ticker Info
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ticker.symbol,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Text(
                                      '${cache.regularMarketPrice.toStringAsFixed(2)} ${ticker.currency}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      '${isPositive ? '+' : ''}${variation.toStringAsFixed(2)} (${variationPercent.toStringAsFixed(2)}%)',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: color,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              // Sparkline Chart (Level 2)
                              Expanded(
                                flex: 2,
                                child: SizedBox(
                                  height: 50,
                                  child: _buildSparkline(
                                      cache.intradayPrices, color),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  const Divider(),
                ],
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: \$err')),
      ),
    );
  }

  Widget _buildSparkline(List<double> prices, Color color) {
    if (prices.isEmpty) return const SizedBox.shrink();

    final minPrice = prices.reduce((a, b) => a < b ? a : b);
    final maxPrice = prices.reduce((a, b) => a > b ? a : b);

    final spots = prices.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value);
    }).toList();

    // The API fetches 5m data for 1d.
    // We assume a minimum of 6 hours of trading to avoid the chart stretching fully
    // if only a few data points are available at the start of the day.
    // 6 hours = 360 minutes / 5 minutes = 72 data points.
    const minExpectedDataPoints = 72;
    final double calculatedMaxX = (spots.length > minExpectedDataPoints)
        ? spots.length.toDouble() - 1
        : minExpectedDataPoints.toDouble() - 1;

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: calculatedMaxX,
        minY: minPrice,
        maxY: maxPrice,
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineTouchData: const LineTouchData(enabled: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
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
    );
  }
}
