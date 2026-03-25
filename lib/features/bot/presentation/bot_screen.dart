import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_drawer.dart';
import 'bot_provider.dart';

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
        title: const Text('Bot'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
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
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              itemCount: botState.messages.length,
              itemBuilder: (context, index) {
                final message = botState.messages[index];
                final isUser = message.role == 'user';
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: isUser
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75),
                    child: Text(
                      message.content,
                      style: TextStyle(
                        color: isUser
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                );
              },
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                botState.error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          const Divider(height: 1),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24.0)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
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
        ],
      ),
    );
  }
}
