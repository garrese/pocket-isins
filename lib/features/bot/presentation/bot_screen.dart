import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import '../../../core/theme/app_drawer.dart';
import '../../portfolio/presentation/screens/isin_step_screen.dart';
import '../../portfolio/domain/portfolio_form_data.dart';
import 'bot_provider.dart';
import '../../../core/widgets/constrained_width.dart';

class BotScreen extends ConsumerStatefulWidget {
  const BotScreen({super.key});

  @override
  ConsumerState<BotScreen> createState() => _BotScreenState();
}

class _BotScreenState extends ConsumerState<BotScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;
    ref.read(botControllerProvider.notifier).sendMessage(text);
    _textController.clear();
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }

  @override
  Widget build(BuildContext context) {
    final botState = ref.watch(botControllerProvider);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Restart Conversation',
            onPressed: () {
              ref.read(botControllerProvider.notifier).clearHistory();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ConstrainedWidth.medium(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(8.0),
                itemCount: botState.messages.length,
                itemBuilder: (context, index) {
                  final message = botState.messages[index];
                  final isUser = message.role == 'user';
                  final isSystem = message.role == 'system';

                  if (isSystem) {
                    return const SizedBox.shrink(); // Hide system messages
                  }

                  // Check for action commands
                  final createIsinRegExp = RegExp(
                    r'\[\$ACTION:CREATE_ISIN\s+isinCode="([^"]+)"\s+name="([^"]+)"\]',
                  );
                  final marketDataRegExp = RegExp(
                    r'\[\$ACTION:MARKET_DATA\s+symbol="([^"]+)"\s+interval="([^"]+)"\s+range="([^"]+)"\]',
                  );

                  String displayContent = message.content;
                  Widget? actionWidget;

                  if (!isUser) {
                    // Handle CREATE_ISIN
                    final isinMatch = createIsinRegExp.firstMatch(
                      displayContent,
                    );
                    if (isinMatch != null) {
                      final isinCode = isinMatch.group(1)!;
                      final name = isinMatch.group(2)!;

                      // Replace the raw command with empty string for rendering
                      displayContent = displayContent
                          .replaceAll(createIsinRegExp, '')
                          .trim();

                      actionWidget = Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.add_circle_outline),
                          label: Text('Create ISIN: $name'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Theme.of(
                              context,
                            ).colorScheme.secondary,
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          onPressed: () {
                            // Navigate to ISIN wizard with prefilled data
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => IsinStepScreen(
                                  formData: IsinFormData(
                                    isinCode: isinCode,
                                    altName: name,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }

                    // Handle MARKET_DATA (just hide the raw command)
                    final marketMatch = marketDataRegExp.firstMatch(
                      displayContent,
                    );
                    if (marketMatch != null) {
                      final symbol = marketMatch.group(1)!;
                      final interval = marketMatch.group(2)!;
                      final range = marketMatch.group(3)!;
                      displayContent = displayContent
                          .replaceAll(marketDataRegExp, '')
                          .trim();

                      actionWidget ??= Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Fetching market data for $symbol ($interval, $range)...',
                          style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      );
                    }
                  }

                  // If content is empty and there's no action widget, don't show an empty bubble
                  if (displayContent.isEmpty && actionWidget == null) {
                    return const SizedBox.shrink();
                  }

                  return Align(
                    alignment: isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: isUser
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.85,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (displayContent.isNotEmpty)
                            isUser
                                ? SelectableText(
                                    displayContent,
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimaryContainer,
                                    ),
                                  )
                                : MarkdownBody(
                                    selectable: true,
                                    data: displayContent,
                                    styleSheet: MarkdownStyleSheet(
                                      p: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                          if (actionWidget != null) actionWidget,
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          if (botState.isTyping)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
          if (botState.error != null)
            ConstrainedWidth.medium(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  botState.error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ),
          const Divider(height: 1),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: SafeArea(
              child: ConstrainedWidth.medium(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: const InputDecoration(
                          hintText: 'Type a message...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(24.0),
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                        ),
                        onSubmitted: _handleSubmitted,
                        textInputAction: TextInputAction.send,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    IconButton(
                      icon: const Icon(Icons.send),
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () => _handleSubmitted(_textController.text),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
