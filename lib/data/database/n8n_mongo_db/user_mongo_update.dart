import 'package:mongo_dart/mongo_dart.dart';
import '../../../utils/constants/db_constants.dart';
import 'n8n_mongo_base.dart';

class UserMongoUpdate extends N8nMongoDatabase {
  // Singleton implementation
  static final UserMongoUpdate _instance = UserMongoUpdate._internal();
  factory UserMongoUpdate() => _instance;
  UserMongoUpdate._internal();

  Future<void> _ensureConnected() async {
    await N8nMongoDatabase.ensureConnected();
  }

  ObjectId? safeObjectIdFromHex(String? id) {
    if (id == null || id.length != 24) return null;

    try {
      return ObjectId.fromHexString(id);
    } catch (e) {
      print('Invalid ObjectId: $id - Error: $e');
      return null;
    }
  }

  Future<void> updateDocumentById({
    required String collectionName,
    required String id,
    required Map<String, dynamic> updatedData,
  }) async {
    await _ensureConnected();
    try {
      final objectId = ObjectId.fromHexString(id);

      // Remove _id from updatedData (if it exists)
      final filteredData = Map<String, dynamic>.from(updatedData)
        ..remove('_id');

      final result = await db!.collection(collectionName).updateOne(
        {'_id': objectId},
        {
          '\$set': filteredData,
        },
        upsert: true,
      );

      if (!result.isSuccess && result.nModified == 0) {
        throw Exception('No document was updated. Possibly invalid ID or no data changes.');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateLastSeenBySessionId({
    required String collectionName,
    required String sessionId,
    required int lastSeenIndex,
  }) async {
    await _ensureConnected();
    try {
      final result = await db!.collection(collectionName).updateOne(
        {ChatsFieldName.sessionId: sessionId},
        {
          r'$set': {ChatsFieldName.lastSeenIndex: lastSeenIndex},
        },
        upsert: true,
      );

      if (!result.isSuccess || result.nModified == 0) {
        throw Exception('No document was updated. Possibly invalid sessionId.');
      }
    } catch (e) {
      rethrow;
    }
  }


}