// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticker_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tickerDetailHash() => r'1347c87c0fbdf0e23ecfd5a9eee1e41e4bb20b35';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$TickerDetail
    extends BuildlessAutoDisposeNotifier<TickerDetailState> {
  late final String symbol;

  TickerDetailState build(
    String symbol,
  );
}

/// See also [TickerDetail].
@ProviderFor(TickerDetail)
const tickerDetailProvider = TickerDetailFamily();

/// See also [TickerDetail].
class TickerDetailFamily extends Family<TickerDetailState> {
  /// See also [TickerDetail].
  const TickerDetailFamily();

  /// See also [TickerDetail].
  TickerDetailProvider call(
    String symbol,
  ) {
    return TickerDetailProvider(
      symbol,
    );
  }

  @override
  TickerDetailProvider getProviderOverride(
    covariant TickerDetailProvider provider,
  ) {
    return call(
      provider.symbol,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'tickerDetailProvider';
}

/// See also [TickerDetail].
class TickerDetailProvider
    extends AutoDisposeNotifierProviderImpl<TickerDetail, TickerDetailState> {
  /// See also [TickerDetail].
  TickerDetailProvider(
    String symbol,
  ) : this._internal(
          () => TickerDetail()..symbol = symbol,
          from: tickerDetailProvider,
          name: r'tickerDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$tickerDetailHash,
          dependencies: TickerDetailFamily._dependencies,
          allTransitiveDependencies:
              TickerDetailFamily._allTransitiveDependencies,
          symbol: symbol,
        );

  TickerDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.symbol,
  }) : super.internal();

  final String symbol;

  @override
  TickerDetailState runNotifierBuild(
    covariant TickerDetail notifier,
  ) {
    return notifier.build(
      symbol,
    );
  }

  @override
  Override overrideWith(TickerDetail Function() create) {
    return ProviderOverride(
      origin: this,
      override: TickerDetailProvider._internal(
        () => create()..symbol = symbol,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        symbol: symbol,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<TickerDetail, TickerDetailState>
      createElement() {
    return _TickerDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TickerDetailProvider && other.symbol == symbol;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, symbol.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TickerDetailRef on AutoDisposeNotifierProviderRef<TickerDetailState> {
  /// The parameter `symbol` of this provider.
  String get symbol;
}

class _TickerDetailProviderElement
    extends AutoDisposeNotifierProviderElement<TickerDetail, TickerDetailState>
    with TickerDetailRef {
  _TickerDetailProviderElement(super.provider);

  @override
  String get symbol => (origin as TickerDetailProvider).symbol;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
