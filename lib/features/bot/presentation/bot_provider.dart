import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/ai/ai_service.dart';
import '../../../core/network/market_data_service.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../../core/services/log/talker_provider.dart';
import '../../../core/database/drift/app_database.dart';
import '../data/bot_repository.dart';
import '../data/ai_settings_repository.dart';

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
  final MarketDataService _marketDataService;
  final AiSettingsRepository _settingsRepo;
  final Talker _log;

  BotController(
    this._repository,
    this._aiService,
    this._marketDataService,
    this._settingsRepo,
    this._log,
  ) : super(BotState(messages: [])) {
    loadHistory();
  }

  Future<void> loadHistory() async {
    final messages = await _repository.getChatHistory();
    state = state.copyWith(messages: messages);
  }

  Future<void> clearHistory() async {
    _log.info('Clearing bot chat history');
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
      final isinsJson = isins
          .map(
            (i) => {
              'isinCode': i.isinCode,
              'name': i.registeredNames.isNotEmpty
                  ? i.registeredNames.first
                  : i.altName,
            },
          )
          .toList();

      final systemPrompt = '''
You are a helpful financial AI assistant.
The user currently has the following ISINs saved in their portfolio:
${jsonEncode(isinsJson)}

Respond to the user's queries accurately. You can search the web if needed.

You have the ability to execute special actions by returning a specific syntax in your response. When you want to execute an action, output the following exactly:

1. To fetch market data for a symbol:
[\$ACTION:MARKET_DATA symbol="SYMBOL" interval="INTERVAL" range="RANGE"]
Example: [\$ACTION:MARKET_DATA symbol="AAPL" interval="1d" range="1mo"]
(When you output this, the system will fetch the data and provide it to you in the next message so you can formulate your answer).

2. To offer the user a quick way to create an ISIN:
[\$ACTION:CREATE_ISIN isinCode="ISIN" name="NAME"]
Example: [\$ACTION:CREATE_ISIN isinCode="US0378331005" name="Apple Inc."]
(When you output this, the user will see a button to automatically create the ISIN).
''';

      // Prepare conversation history for the AI
      final historyMaps = state.messages
          .map((m) => {'role': m.role, 'content': m.content})
          .toList();

      final settings = await _settingsRepo.getSettings();

      final response = await _aiService.getGenericCompletion(
        systemPrompt: systemPrompt,
        messages: historyMaps,
        webSearch: settings.webSearchCapability,
      );

      await _handleAiResponse(response, systemPrompt);
    } catch (e, stack) {
      _log.handle(e, stack, 'Error in bot communication');
      state = state.copyWith(isTyping: false);
    }
  }

  Future<void> _handleAiResponse(String response, String systemPrompt) async {
    // Save the AI response first
    await _repository.saveMessage('assistant', response);

    // Check if there's a market data action
    final marketDataRegExp = RegExp(
      r'\[\$ACTION:MARKET_DATA\s+symbol="([^"]+)"\s+interval="([^"]+)"\s+range="([^"]+)"\]',
    );
    final match = marketDataRegExp.firstMatch(response);

    if (match != null) {
      final symbol = match.group(1)!;
      final interval = match.group(2)!;
      final range = match.group(3)!;

      try {
        final data = await _marketDataService.fetchHistoricalData(
          symbol,
          interval,
          range,
        );
        if (data != null) {
          // Remove the actual chart array to save context window, keep meta, timestamp, and indicators
          final filteredData = Map<String, dynamic>.from(data);

          // Remove actual timestamps to save a lot of space
          if (filteredData.containsKey('timestamp')) {
            filteredData.remove('timestamp');
          }
          // Remove chart indicators (open/high/low/close/volume arrays) which take up massive space
          if (filteredData.containsKey('indicators')) {
            filteredData.remove('indicators');
          }

          final systemMessage = jsonEncode(filteredData);
          await _repository.saveMessage(
            'system',
            'Market data for $symbol: $systemMessage',
          );

          // Re-fetch history and call AI again
          final newHistory = await _repository.getChatHistory();
          final historyMaps = newHistory
              .map((m) => {'role': m.role, 'content': m.content})
              .toList();

          final settings = await _settingsRepo.getSettings();

          final newResponse = await _aiService.getGenericCompletion(
            systemPrompt: systemPrompt,
            messages: historyMaps,
            webSearch: settings.webSearchCapability,
          );

          await _handleAiResponse(newResponse, systemPrompt);
          return;
        } else {
          await _repository.saveMessage(
            'system',
            'Failed to fetch market data for $symbol.',
          );

          // Re-fetch history and call AI again
          final newHistory = await _repository.getChatHistory();
          final historyMaps = newHistory
              .map((m) => {'role': m.role, 'content': m.content})
              .toList();

          final settings = await _settingsRepo.getSettings();

          final newResponse = await _aiService.getGenericCompletion(
            systemPrompt: systemPrompt,
            messages: historyMaps,
            webSearch: settings.webSearchCapability,
          );

          await _handleAiResponse(newResponse, systemPrompt);
          return;
        }
      } catch (e, stack) {
        _log.handle(e, stack, 'Error handling market data action in bot');
        await _repository.saveMessage(
          'system',
          'Error fetching market data: $e',
        );
      }
    }

    // Check for ISIN creation action is handled entirely in UI

    // Update state when all actions and recursive calls are done
    final finalMessages = await _repository.getChatHistory();
    state = state.copyWith(messages: finalMessages, isTyping: false);
  }
}

final botControllerProvider = StateNotifierProvider<BotController, BotState>((
  ref,
) {
  return BotController(
    ref.watch(botRepositoryProvider),
    ref.watch(aiServiceProvider),
    ref.watch(marketDataServiceProvider),
    ref.watch(aiSettingsRepositoryProvider),
    ref.watch(talkerProvider),
  );
});
