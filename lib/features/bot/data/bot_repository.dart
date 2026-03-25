import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';

import '../../../core/database/drift_service.dart';
import '../../../core/database/drift/app_database.dart';

final botRepositoryProvider = Provider<BotRepository>((ref) {
  return BotRepository(ref.watch(driftServiceProvider).db);
});

class BotRepository {
  final AppDatabase _db;

  BotRepository(this._db);

  Future<List<ChatMessageData>> getChatHistory() async {
    return await (_db.select(_db.chatMessages)
          ..orderBy([
            (t) => OrderingTerm(expression: t.timestamp, mode: OrderingMode.asc)
          ]))
        .get();
  }

  Future<void> saveMessage(String role, String content) async {
    await _db.into(_db.chatMessages).insert(
          ChatMessagesCompanion.insert(
            role: role,
            content: content,
            timestamp: DateTime.now(),
          ),
        );
  }

  Future<void> clearChatHistory() async {
    await _db.delete(_db.chatMessages).go();
  }

  Future<List<IsinData>> getAllIsins() async {
    return await _db.select(_db.isins).get();
  }
}
