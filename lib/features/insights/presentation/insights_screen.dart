import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../domain/news_card_model.dart';
import '../../../core/services/ai/ai_service.dart';
import '../../../core/theme/app_drawer.dart';

final newsListProvider = StateProvider<List<NewsCardModel>>((ref) => []);
final isSearchingProvider = StateProvider<bool>((ref) => false);
final searchErrorProvider = StateProvider<String?>((ref) => null);

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsList = ref.watch(newsListProvider);
    final isSearching = ref.watch(isSearchingProvider);
    final searchError = ref.watch(searchErrorProvider);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('AI Insights'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: isSearching
                  ? null
                  : () {
                      _searchNews(ref);
                    },
              icon: isSearching
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.search),
              label: Text(
                isSearching ? 'Searching News...' : 'Search Market News',
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          if (searchError != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Error: $searchError',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          Expanded(
            child: newsList.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Text(
                        'No news yet. Tap search to fetch market insights.\nMake sure you configured your API Key in Settings.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: newsList.length,
                    itemBuilder: (context, index) {
                      final news = newsList[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 8.0,
                        ),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap: () async {
                            final url = Uri.parse(news.url);
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            } else {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Could not open the URL.'),
                                  ),
                                );
                              }
                            }
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  news.title,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 4),
                                if (news.relevanceRating != null) ...[
                                  Text(
                                    'Relevance: ${news.relevanceRating}',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueAccent,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                ],
                                Text(
                                  news.summary,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: Colors.grey[400]),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '- ${news.source}',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: Colors.grey[400]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _searchNews(WidgetRef ref) async {
    ref.read(isSearchingProvider.notifier).state = true;
    ref.read(searchErrorProvider.notifier).state = null;

    try {
      final aiService = ref.read(aiServiceProvider);
      final fetchedNews = await aiService.fetchMarketNews();
      fetchedNews.sort((a, b) {
        final aRating = a.relevanceRating ?? 0;
        final bRating = b.relevanceRating ?? 0;
        return bRating.compareTo(aRating);
      });
      ref.read(newsListProvider.notifier).state = fetchedNews;
    } catch (e) {
      ref.read(searchErrorProvider.notifier).state = e.toString();
    } finally {
      ref.read(isSearchingProvider.notifier).state = false;
    }
  }
}
