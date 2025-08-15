import 'package:mongo_dart/mongo_dart.dart';
import '../../../utils/constants/db_constants.dart';
import 'mongo_base.dart';

class MongoInsert extends MongoDatabase {
  // Singleton implementation
  static final MongoInsert _instance = MongoInsert._internal();
  factory MongoInsert() => _instance;
  MongoInsert._internal();

  Future<void> _ensureConnected() async {
    await MongoDatabase.ensureConnected();
  }

  Future<String> insertDocument(String collectionName, Map<String, dynamic> data) async {
    await _ensureConnected();
    try {
      final result = await db!.collection(collectionName).insertOne(data);
      if (result.isSuccess) {
        final ObjectId id = data['_id'];
        return id.toHexString(); // or: id.toString()
      } else {
        throw Exception('Insert failed: ${result.errmsg}');
      }
    } catch (e) {
      throw Exception('Failed to insert document: $e');
    }
  }

  Future<void> insertMessageToSession({
    required String collectionName,
    required String sessionId,
    required Map<String, dynamic> message,
    int? lastSeenIndex,
  }) async {
    await _ensureConnected();
    try {
      await db!.collection(collectionName).update(
        where.eq(ChatsFieldName.sessionId, sessionId),
        modify.push(ChatsFieldName.messages, message)
            .set(ChatsFieldName.lastModified, DateTime.now().toUtc())
            .set(ChatsFieldName.lastSeenIndex, lastSeenIndex),
        upsert: true, // <-- insert if not found
      );
    } catch (e) {
      throw Exception('Failed to insert message: $e');
    }
  }
}