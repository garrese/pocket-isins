import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/ticker_detail_provider.dart';

class TickerDetailScreen extends ConsumerWidget {
  final String symbol;

  const TickerDetailScreen({super.key, required this.symbol});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailState = ref.watch(tickerDetailProvider(symbol));

    return Scaffold(
      appBar: AppBar(
        title: Text(symbol),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTimeRangeSelector(context, ref, detailState),
            const SizedBox(height: 16),
            Expanded(
              child: _buildChartArea(context, detailState),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeRangeSelector(
      BuildContext context, WidgetRef ref, TickerDetailState state) {
    return Wrap(
      spacing: 8.0,
      alignment: WrapAlignment.center,
      children: TimeRange.values.map((range) {
        final isSelected = state.selectedRange == range;
        return ChoiceChip(
          label: Text(range.label),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              ref.read(tickerDetailProvider(symbol).notifier).changeTimeRange(range);
            }
          },
        );
      }).toList(),
    );
  }

  Widget _buildChartArea(BuildContext context, TickerDetailState state) {
    if (state.isLoading && state.data == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Text(
          'Error: ${state.error}',
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (state.data == null) {
      return const Center(child: Text('No data available'));
    }

    try {
      final result = state.data!['chart']['result'][0];
      final meta = result['meta'];
      final indicators = result['indicators']?['quote']?[0];
      final List<dynamic>? timestampsDynamic = result['timestamp'];

      if (meta == null || indicators == null || timestampsDynamic == null) {
        return const Center(child: Text('Invalid data format.'));
      }

      final regularMarketPrice = (meta['regularMarketPrice'] as num).toDouble();
      final chartPreviousClose = (meta['chartPreviousClose'] as num?)?.toDouble() ?? regularMarketPrice;
      final variation = regularMarketPrice - chartPreviousClose;
      final variationPercent = (variation / chartPreviousClose) * 100;
      final isPositive = variation >= 0;
      final color = isPositive ? Colors.green : Colors.red;
      final currency = meta['currency'] ?? '';

      final List<double> prices = [];
      final closeArray = indicators['close'] as List<dynamic>? ?? [];

      for (var i = 0; i < closeArray.length; i++) {
        final val = closeArray[i];
        if (val != null) {
          prices.add((val as num).toDouble());
        }
      }

      if (prices.length < 2) {
        return const Center(child: Text('Not enough price data available.'));
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${regularMarketPrice.toStringAsFixed(2)} $currency',
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          Text(
            '${isPositive ? "+" : ""}${variation.toStringAsFixed(2)} (${variationPercent.toStringAsFixed(2)}%)',
            style: TextStyle(fontSize: 18, color: color, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: _buildLineChart(prices, color),
          ),
          if (state.isLoading) const LinearProgressIndicator(),
        ],
      );
    } catch (e) {
      return Center(
        child: Text(
          'Error parsing data: $e',
          style: const TextStyle(color: Colors.red),
        ),
      );
    }
  }

  Widget _buildLineChart(List<double> prices, Color color) {
    final minPrice = prices.reduce((a, b) => a < b ? a : b);
    final maxPrice = prices.reduce((a, b) => a > b ? a : b);

    final padding = (maxPrice - minPrice) * 0.1;
    final minY = minPrice - padding;
    final maxY = maxPrice + padding;

    final spots = prices.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value);
    }).toList();

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: (spots.length - 1).toDouble(),
        minY: minY,
        maxY: maxY,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withValues(alpha: 0.2),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    value.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (spot) => Colors.blueGrey,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((LineBarSpot touchedSpot) {
                return LineTooltipItem(
                  touchedSpot.y.toStringAsFixed(2),
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                );
              }).toList();
            },
          ),
          handleBuiltInTouches: true,
        ),
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
