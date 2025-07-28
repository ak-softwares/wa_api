import 'package:mongo_dart/mongo_dart.dart';
import 'user_mongo_base.dart';
import '../../../utils/constants/db_constants.dart';
import '../../../utils/constants/enums.dart';

class UserMongoFetch extends UsersMongoDatabase {
  // Singleton implementation
  static final UserMongoFetch _instance = UserMongoFetch._internal();

  factory UserMongoFetch() => _instance;

  UserMongoFetch._internal();

  Future<void> _ensureConnected() async {
    await UsersMongoDatabase.ensureConnected();
  }

  // Fetch documents with pagination
  Future<List<Map<String, dynamic>>> fetchDocuments({
    required String collectionName,
    Map<String, dynamic>? filter,
    int page = 1,
    int itemsPerPage = 10
  }) async {
    await _ensureConnected();
    var collection = db!.collection(collectionName);
    int skip = (page - 1) * itemsPerPage;

    try {
      var query = where
        ..sortBy('_id', descending: true)
        ..skip(skip)
        ..limit(itemsPerPage);

      if (filter != null) {
        filter.forEach((key, value) {
          query = query.eq(key, value);
        });
      }

      var documents = await collection.find(query).toList();
      return documents;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getChats({
    required String collectionName,
    Map<String, dynamic>? filter,
    int page = 1,
    int itemsPerPage = 10,
    int messageLimit = 10,
  }) async {
    await _ensureConnected();
    var collection = db!.collection(collectionName);
    int skip = (page - 1) * itemsPerPage;

    try {
      var query = where
        ..sortBy('_id', descending: true)
        ..skip(skip)
        ..limit(itemsPerPage);

      if (filter != null) {
        filter.forEach((key, value) {
          query = query.eq(key, value);
        });
      }

      var documents = await collection.find(query).toList();

      // If documents have a 'messages' array, trim it
      for (var doc in documents) {
        if (doc.containsKey('messages') && doc['messages'] is List) {
          List messages = doc['messages'];
          int startIndex = messages.length > messageLimit ? messages.length - messageLimit : 0;
          doc['messages'] = messages.sublist(startIndex);
        }
      }

      return documents;
    } catch (e) {
      rethrow;
    }
  }


  Future<List<Map<String, dynamic>>> fetchMessages({
    required String collectionName,
    required String sessionId,
    int page = 1,
    int itemsPerPage = 10,
  }) async {
    await _ensureConnected();
    final collection = db!.collection(collectionName);

    try {
      // Fetch the document with the matching sessionId
      final document = await collection.findOne({'sessionId': sessionId});

      if (document == null || document['messages'] == null) {
        return [];
      }

      List<dynamic> allMessages = document['messages'];

      // Sort messages by insertion order (latest last), or reverse it if needed
      allMessages = List<Map<String, dynamic>>.from(allMessages.reversed);

      // Paginate messages manually
      final int start = (page - 1) * itemsPerPage;
      final int end = (start + itemsPerPage).clamp(0, allMessages.length);

      return allMessages.sublist(start, end).cast<Map<String, dynamic>>();
    } catch (e) {
      rethrow;
    }
  }




}