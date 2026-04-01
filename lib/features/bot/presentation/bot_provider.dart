import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/ai/ai_service.dart';
import '../../../core/database/drift/app_database.dart';
import '../data/bot_repository.dart';

class BotState {
  final List<ChatMessageData> messages;
  final bool isTyping;
  final String? error;

  BotState({required this.messages, this.isTyping = false, this.error});

  BotState copyWith({
    List<ChatMessageData>? messages,
    bool? isTyping,
    String? error,
  }) {
    return BotState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      error: error ?? this.error,
    );
  }
}

class BotController extends StateNotifier<BotState> {
  final BotRepository _repository;
  final AiService _aiService;

  BotController(this._repository, this._aiService)
      : super(BotState(messages: [])) {
    loadHistory();
  }

  Future<void> loadHistory() async {
    final messages = await _repository.getChatHistory();
    state = state.copyWith(messages: messages);
  }

  Future<void> clearHistory() async {
    await _repository.clearChatHistory();
    state = BotState(messages: [], error: null, isTyping: false);
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Save user message
    await _repository.saveMessage('user', text);

    // Update local state immediately for fast feedback
    final currentUserMessages = await _repository.getChatHistory();
    state = state.copyWith(
      messages: currentUserMessages,
      isTyping: true,
      error: null,
    );

    try {
      // Fetch ISINs and generate system prompt
      final isins = await _repository.getAllIsins();
      final isinsJson =
          isins.map((i) => {'isinCode': i.isinCode, 'name': i.registeredNames.isNotEmpty ? i.registeredNames.first : i.altName}).toList();

      final systemPrompt = '''
You are a helpful financial AI assistant.
The user currently has the following ISINs saved in their portfolio:
${jsonEncode(isinsJson)}

Respond to the user's queries accurately. You can search the web if needed.
''';

      // Prepare conversation history for the AI
      final historyMaps = state.messages
          .map((m) => {'role': m.role, 'content': m.content})
          .toList();

      final response = await _aiService.getGenericCompletion(
        systemPrompt: systemPrompt,
        messages: historyMaps,
        webSearch: true,
      );

      // Save AI response
      await _repository.saveMessage('assistant', response);

      final finalMessages = await _repository.getChatHistory();
      state = state.copyWith(messages: finalMessages, isTyping: false);
    } catch (e) {
      state = state.copyWith(isTyping: false, error: e.toString());
    }
  }
}

final botControllerProvider = StateNotifierProvider<BotController, BotState>((
  ref,
) {
  return BotController(
    ref.watch(botRepositoryProvider),
    ref.watch(aiServiceProvider),
  );
});
