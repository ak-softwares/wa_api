import 'package:mongo_dart/mongo_dart.dart';

import '../../../utils/constants/db_constants.dart';
import 'user_mongo_base.dart';

class UserMongoInsert extends UsersMongoDatabase {
  // Singleton implementation
  static final UserMongoInsert _instance = UserMongoInsert._internal();
  factory UserMongoInsert() => _instance;
  UserMongoInsert._internal();

  Future<void> _ensureConnected() async {
    await UsersMongoDatabase.ensureConnected();
  }

  // Insert a single document
  Future<void> insertDocument(String collectionName, Map<String, dynamic> data) async {
    await _ensureConnected();
    try {
      await db!.collection(collectionName).insert(data);
    } catch (e) {
      throw Exception('Failed to insert document: $e');
    }
  }

  Future<void> insertMessageToSession({
    required String collectionName,
    required String sessionId,
    required Map<String, dynamic> message,
  }) async {
    await _ensureConnected();
    try {
      await db!.collection(collectionName).update(
        where.eq(ChatsFieldName.sessionId, sessionId),
        modify.push(ChatsFieldName.messages, message),
      );
    } catch (e) {
      throw Exception('Failed to insert message: $e');
    }
  }

}