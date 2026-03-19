import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:intl/intl.dart';
import '../../data/ticker_detail_provider.dart';

class ChartPoint {
  final double close;
  final double? high;
  final double? low;
  final int? volume;
  final int timestamp;

  ChartPoint({
    required this.close,
    this.high,
    this.low,
    this.volume,
    required this.timestamp,
  });
}

class TickerDetailScreen extends ConsumerWidget {
  final String symbol;
  final String? displayName;

  const TickerDetailScreen({super.key, required this.symbol, this.displayName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailState = ref.watch(tickerDetailProvider(symbol));

    return Scaffold(
      appBar: AppBar(
        title: Text(displayName != null ? '$displayName ($symbol)' : symbol),
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
      runSpacing: 8.0,
      alignment: WrapAlignment.center,
      children: TimeRange.values.map((range) {
        final isSelected = state.selectedRange == range;
        return ChoiceChip(
          label: Text(range.label),
          selected: isSelected,
          showCheckmark: false,
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
      final List<dynamic> timestampsDynamic = result['timestamp'] as List<dynamic>? ?? [];

      if (meta == null || indicators == null) {
        return const Center(child: Text('Invalid data format.'));
      }

      final regularMarketPrice = (meta['regularMarketPrice'] as num).toDouble();
      final chartPreviousClose = (meta['chartPreviousClose'] as num?)?.toDouble() ?? regularMarketPrice;
      final variation = regularMarketPrice - chartPreviousClose;
      final variationPercent = (variation / chartPreviousClose) * 100;
      final isPositive = variation >= 0;
      final color = isPositive ? Colors.green : Colors.red;
      final currency = meta['currency'] ?? '';

      // Yahoo Finance API provides parallel arrays for timestamps and Open/High/Low/Close/Volume values.
      // We iterate over the 'close' array (as it's our primary metric) and build a consolidated list
      // of ChartPoint objects using the corresponding index across all arrays.
      final List<ChartPoint> chartPoints = [];
      final closeArray = indicators['close'] as List<dynamic>? ?? [];
      final highArray = indicators['high'] as List<dynamic>? ?? [];
      final lowArray = indicators['low'] as List<dynamic>? ?? [];
      final volumeArray = indicators['volume'] as List<dynamic>? ?? [];

      for (var i = 0; i < closeArray.length; i++) {
        final val = closeArray[i];
        if (val != null) {
          final closePrice = (val as num).toDouble();

          double? high;
          if (i < highArray.length && highArray[i] != null) {
            high = (highArray[i] as num).toDouble();
          }

          double? low;
          if (i < lowArray.length && lowArray[i] != null) {
            low = (lowArray[i] as num).toDouble();
          }

          int? volume;
          if (i < volumeArray.length && volumeArray[i] != null) {
            volume = (volumeArray[i] as num).toInt();
          }

          int timestamp = 0;
          if (i < timestampsDynamic.length) {
            timestamp = (timestampsDynamic[i] as num).toInt();
          }

          chartPoints.add(ChartPoint(
            close: closePrice,
            high: high,
            low: low,
            volume: volume,
            timestamp: timestamp,
          ));
        }
      }

      // Yahoo Finance sometimes returns out-of-order timestamps, and fl_chart requires X values to be strictly sorted.
      chartPoints.sort((a, b) => a.timestamp.compareTo(b.timestamp));

      // Remove duplicates with the same timestamp (keeping the last one) to prevent fl_chart errors with multiple Y values for the exact same X.
      final List<ChartPoint> uniquePoints = [];
      for (var point in chartPoints) {
        if (uniquePoints.isNotEmpty && uniquePoints.last.timestamp == point.timestamp) {
          uniquePoints[uniquePoints.length - 1] = point; // Replace with the latest data for this timestamp
        } else {
          uniquePoints.add(point);
        }
      }
      chartPoints.clear();
      chartPoints.addAll(uniquePoints);

      if (chartPoints.length < 2) {
        return const Center(child: Text('Not enough price data available.'));
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${regularMarketPrice.toStringAsFixed(2)} $currency',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            '${isPositive ? "+" : ""}${variation.toStringAsFixed(2)} (${variationPercent.toStringAsFixed(2)}%)',
            style: TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _buildLineChart(chartPoints, state.selectedRange, color),
          ),
          const SizedBox(height: 16),
          _buildMetaData(meta),
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

  Widget _buildLineChart(List<ChartPoint> chartPoints, TimeRange timeRange, Color color) {
    final prices = chartPoints.map((e) => e.close).toList();
    final minPrice = prices.reduce((a, b) => a < b ? a : b);
    final maxPrice = prices.reduce((a, b) => a > b ? a : b);

    final padding = (maxPrice - minPrice) * 0.1;
    final minY = minPrice - padding;
    final maxY = maxPrice + padding;

    final spots = chartPoints.map((point) {
      return FlSpot(point.timestamp.toDouble(), point.close);
    }).toList();

    final minX = spots.first.x;
    final maxX = spots.last.x;

    String firstTime = '';
    String lastTime = '';

    if (chartPoints.isNotEmpty) {
      int firstTs = chartPoints.map((e) => e.timestamp).firstWhere((ts) => ts > 0, orElse: () => 0);
      int lastTs = chartPoints.map((e) => e.timestamp).lastWhere((ts) => ts > 0, orElse: () => 0);

      String formatString = (timeRange == TimeRange.day || timeRange == TimeRange.week)
          ? 'HH:mm'
          : 'dd/MM/yy';

      if (firstTs > 0) {
        firstTime = DateFormat(formatString).format(DateTime.fromMillisecondsSinceEpoch(firstTs * 1000));
      }
      if (lastTs > 0) {
        lastTime = DateFormat(formatString).format(DateTime.fromMillisecondsSinceEpoch(lastTs * 1000));
      }
    }

    return Stack(
      children: [
        LineChart(
          LineChartData(
            minX: minX,
            maxX: maxX,
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
                    // Hide exactly the min and max auto-generated labels,
                    // preserving all the intermediate grid-aligned ones.
                    if (value == meta.min || value == meta.max) {
                      return const SizedBox.shrink();
                    }

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
                    // touchedSpot.x is the timestamp
                    final timestamp = touchedSpot.x.toInt();

                    try {
                      final point = chartPoints.firstWhere((p) => p.timestamp == timestamp);
                      String timeStr = '';
                      if (point.timestamp > 0) {
                        final formatString = (timeRange == TimeRange.day || timeRange == TimeRange.week)
                            ? 'HH:mm'
                            : 'dd/MM/yy';
                        timeStr = DateFormat(formatString).format(DateTime.fromMillisecondsSinceEpoch(point.timestamp * 1000));
                      }

                      return LineTooltipItem(
                        '$timeStr\n'
                        'Close: ${point.close.toStringAsFixed(2)}\n'
                        'High: ${point.high?.toStringAsFixed(2) ?? '-'}\n'
                        'Low: ${point.low?.toStringAsFixed(2) ?? '-'}\n'
                        'Vol: ${_formatVolume(point.volume)}',
                        const TextStyle(color: Colors.white, fontSize: 12),
                        textAlign: TextAlign.left,
                      );
                    } catch (e) {
                      return LineTooltipItem(
                        touchedSpot.y.toStringAsFixed(2),
                        const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      );
                    }
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
        ),
        if (firstTime.isNotEmpty)
          Positioned(
            left: 48, // left padding for the Y-axis labels
            bottom: 0,
            child: Text(
              firstTime,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ),
        if (lastTime.isNotEmpty)
          Positioned(
            right: 0,
            bottom: 0,
            child: Text(
              lastTime,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ),
      ],
    );
  }

  Widget _buildMetaData(Map<String, dynamic> meta) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Market Info',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _buildMetaRow('Prev Close', meta['chartPreviousClose'], 'Volume', _formatVolume(meta['regularMarketVolume'])),
        _buildMetaRow('Day Low', meta['regularMarketDayLow'], 'Day High', meta['regularMarketDayHigh']),
        _buildMetaRow('52w Low', meta['fiftyTwoWeekLow'], '52w High', meta['fiftyTwoWeekHigh']),
      ],
    );
  }

  Widget _buildMetaRow(String label1, dynamic val1, String label2, dynamic val2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: _buildMetaItem(label1, val1),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: _buildMetaItem(label2, val2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaItem(String label, dynamic val) {
    String formattedVal = '-';
    if (val != null) {
      if (val is num) {
        formattedVal = val.toStringAsFixed(2);
      } else {
        formattedVal = val.toString();
      }
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 13),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          formattedVal,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          textAlign: TextAlign.right,
        ),
      ],
    );
  }

  String _formatVolume(dynamic vol) {
    if (vol == null) return '-';
    if (vol is num) {
      if (vol >= 1000000000) {
        return '${(vol / 1000000000).toStringAsFixed(2)}B';
      } else if (vol >= 1000000) {
        return '${(vol / 1000000).toStringAsFixed(2)}M';
      } else if (vol >= 1000) {
        return '${(vol / 1000).toStringAsFixed(2)}K';
      }
      return vol.toString();
    }
    return vol.toString();
  }
}
