// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$feedNewsStreamHash() => r'16c4cf59fda845625678610d095bf8e395e81a8f';

/// See also [feedNewsStream].
@ProviderFor(feedNewsStream)
final feedNewsStreamProvider =
    AutoDisposeStreamProvider<List<FeedNewsModel>>.internal(
  feedNewsStream,
  name: r'feedNewsStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$feedNewsStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FeedNewsStreamRef = AutoDisposeStreamProviderRef<List<FeedNewsModel>>;
String _$feedSortOrderStateHash() =>
    r'130b1208f074b9b1baeff9e57f3ef6cc071ba8dc';

/// See also [FeedSortOrderState].
@ProviderFor(FeedSortOrderState)
final feedSortOrderStateProvider =
    AutoDisposeNotifierProvider<FeedSortOrderState, FeedSortOrder>.internal(
  FeedSortOrderState.new,
  name: r'feedSortOrderStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$feedSortOrderStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FeedSortOrderState = AutoDisposeNotifier<FeedSortOrder>;
String _$feedLoadingStateHash() => r'e9a0c02e6ca59511c501369fa90fd92d138bb0cc';

/// See also [FeedLoadingState].
@ProviderFor(FeedLoadingState)
final feedLoadingStateProvider =
    AutoDisposeNotifierProvider<FeedLoadingState, bool>.internal(
  FeedLoadingState.new,
  name: r'feedLoadingStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$feedLoadingStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FeedLoadingState = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
