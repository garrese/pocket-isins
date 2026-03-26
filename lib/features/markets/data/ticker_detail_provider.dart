import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/market_data_service.dart';
import '../../../core/services/log/talker_provider.dart';

part 'ticker_detail_provider.g.dart';

enum TimeRange {
  day('1D', '5m', '1d'),
  week('1W', '1h', '7d'),
  month('1M', '1d', '1mo'),
  threeMonths('3M', '1d', '3mo'),
  sixMonths('6M', '1d', '6mo'),
  year('1Y', '1wk', '1y'),
  fiveYears('5Y', '1mo', '5y'),
  max('Max', '3mo', 'max');

  final String label;
  final String interval;
  final String range;

  const TimeRange(this.label, this.interval, this.range);
}

class TickerDetailState {
  final String symbol;
  final TimeRange selectedRange;
  final bool isLoading;
  final String? error;
  final Map<String, dynamic>? data;

  TickerDetailState({
    required this.symbol,
    required this.selectedRange,
    this.isLoading = false,
    this.error,
    this.data,
  });

  TickerDetailState copyWith({
    String? symbol,
    TimeRange? selectedRange,
    bool? isLoading,
    String? error,
    Map<String, dynamic>? data,
  }) {
    return TickerDetailState(
      symbol: symbol ?? this.symbol,
      selectedRange: selectedRange ?? this.selectedRange,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      data: data ?? this.data,
    );
  }
}

@riverpod
class TickerDetail extends _$TickerDetail {
  @override
  TickerDetailState build(String symbol) {
    // Initial fetch
    Future.microtask(() => fetchHistoricalData(TimeRange.sixMonths));
    return TickerDetailState(
      symbol: symbol,
      selectedRange: TimeRange.sixMonths,
      isLoading: true,
    );
  }

  Future<void> fetchHistoricalData(TimeRange timeRange) async {
    state = state.copyWith(
      isLoading: true,
      selectedRange: timeRange,
      error: null,
    );

    try {
      final marketService = ref.read(marketDataServiceProvider);
      final rawData = await marketService.fetchHistoricalData(
        state.symbol,
        timeRange.interval,
        timeRange.range,
      );

      if (rawData != null && rawData['meta'] != null) {
        state = state.copyWith(isLoading: false, data: rawData);
      } else {
        const errorMsg = 'Failed to fetch data or invalid response.';
        ref.read(talkerProvider).handle(Exception(errorMsg), null, errorMsg);
        state = state.copyWith(
          isLoading: false,
          error: errorMsg,
        );
      }
    } catch (e, stack) {
      ref.read(talkerProvider).handle(
          e, stack, 'Exception fetching historical data for ${state.symbol}');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> changeTimeRange(TimeRange timeRange) async {
    if (state.selectedRange == timeRange) return;
    await fetchHistoricalData(timeRange);
  }
}
