import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/feed_provider.dart';
import '../application/feed_service.dart';
import 'widgets/feed_news_card.dart';
import '../../../core/theme/app_drawer.dart';
import '../../../core/widgets/constrained_width.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 200 && !_showScrollToTop) {
      setState(() => _showScrollToTop = true);
    } else if (_scrollController.offset <= 200 && _showScrollToTop) {
      setState(() => _showScrollToTop = false);
    }
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _analyzeRatings() async {
    ref.read(feedLoadingStateProvider.notifier).setLoading(true);
    try {
      await ref.read(feedServiceProvider).analyzeRatings();
    } finally {
      ref.read(feedLoadingStateProvider.notifier).setLoading(false);
    }
  }

  Future<void> _startSearch() async {
    // 1. Change sort order to natural automatically
    ref
        .read(feedSortOrderStateProvider.notifier)
        .setOrder(FeedSortOrder.natural);
    // 2. Scroll to top
    _scrollToTop();
    // 3. Start fetching
    ref.read(feedLoadingStateProvider.notifier).setLoading(true);

    // We run it without awaiting in the UI thread so the UI remains responsive,
    // but we await it to turn off the loading indicator
    try {
      await ref.read(feedServiceProvider).startNewRound();
    } finally {
      ref.read(feedLoadingStateProvider.notifier).setLoading(false);
    }
  }

  void _setSortOrder(FeedSortOrder newOrder) {
    ref.read(feedSortOrderStateProvider.notifier).setOrder(newOrder);
    _scrollToTop();
  }

  Future<void> _confirmAndClearFeed() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Feed'),
        content: const Text(
          'Are you sure you want to delete all news from the feed?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(feedServiceProvider).clearFeed();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(feedLoadingStateProvider);
    final sortOrder = ref.watch(feedSortOrderStateProvider);
    final newsStream = ref.watch(feedNewsStreamProvider);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        actions: [
          if (_showScrollToTop)
            IconButton(
              icon: const Icon(Icons.arrow_upward),
              tooltip: 'Scroll to top',
              onPressed: _scrollToTop,
            ),
          PopupMenuButton<FeedSortOrder>(
            icon: const Icon(Icons.sort),
            tooltip: 'Sort Options',
            enabled: !isLoading,
            onSelected: _setSortOrder,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: FeedSortOrder.natural,
                child: Row(
                  children: [
                    Icon(
                      Icons.sort_by_alpha,
                      color: sortOrder == FeedSortOrder.natural
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                    const SizedBox(width: 8),
                    const Text('Natural'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: FeedSortOrder.date,
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: sortOrder == FeedSortOrder.date
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                    const SizedBox(width: 8),
                    const Text('Date'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: FeedSortOrder.relevance,
                child: Row(
                  children: [
                    Icon(
                      Icons.star_outline,
                      color: sortOrder == FeedSortOrder.relevance
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                    const SizedBox(width: 8),
                    const Text('Relevance'),
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.auto_awesome),
            tooltip: 'Analyze ratings with AI',
            onPressed: isLoading ? null : _analyzeRatings,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Clear feed',
            onPressed: isLoading ? null : _confirmAndClearFeed,
          ),
        ],
      ),
      body: Column(
        children: [
          if (isLoading) const LinearProgressIndicator(),
          Expanded(
            child: newsStream.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, st) => Center(child: Text('Error: $err')),
              data: (newsList) {
                if (newsList.isEmpty) {
                  return const Center(
                    child: Text('No news available. Try searching.'),
                  );
                }

                // Using ListView with center key to maintain scroll position natively in Flutter 3.13+
                // However, an easier and very reliable way to maintain scroll when inserting at index 0
                // is to just use ListView.builder without modifications if we are NOT at the top.
                // Flutter's ListView doesn't jump automatically to top if items are inserted at index 0
                // IF we use keepScrollOffset (default). But actually, if we insert at 0, everything shifts down.
                // To anchor it, reverse: true could be used, but since we want standard order, we can use a custom CustomScrollView with center.
                // Actually, standard ListView.builder *does* shift content down if index 0 is modified.
                // For simplicity and since user wants it simple, let's use ListView.builder and
                // maintainScrollPositionForThisScrollDirection if possible, or just standard for now.

                return ConstrainedWidth.medium(
                  child: CustomScrollView(
                    controller: _scrollController,
                    // In flutter 3.x, if we want to anchor to bottom when inserting top, we'd use a special package or key.
                    // For now, we keep it simple. If we want it to not move when reading, one trick is reverse list but we want newest on top.
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 80.0),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return FeedNewsCard(
                                key: ValueKey(newsList[index].id),
                                news: newsList[index],
                              );
                            },
                            childCount: newsList.length,
                            // This keeps the scroll from jumping if elements are added above the viewport in some setups
                            findChildIndexCallback: (Key key) {
                              final int? id = (key as ValueKey<int?>).value;
                              final index = newsList.indexWhere(
                                (n) => n.id == id,
                              );
                              return index == -1 ? null : index;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ConstrainedWidth.medium(
        child: Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: FloatingActionButton(
              onPressed: isLoading ? null : _startSearch,
              tooltip: 'Search news',
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ),
    );
  }
}
