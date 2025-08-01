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
        ..sortBy(ChatsFieldName.id, descending: true)
        ..skip(skip)
        ..limit(itemsPerPage);

      if (filter != null) {
        filter.forEach((key, value) {
          query = query.eq(key, value);
        });
      }

      var documents = await collection.find(query).toList();

      for (var doc in documents) {
        if (doc.containsKey(ChatsFieldName.messages) && doc[ChatsFieldName.messages] is List) {
          List messages = doc[ChatsFieldName.messages];
          List<Map<String, dynamic>> indexedMessages = [];

          for (int i = 0; i < messages.length; i++) {
            final msg = Map<String, dynamic>.from(messages[i]);
            msg[MessageFieldName.messageIndex] = i;
            indexedMessages.add(msg);
          }

          // Trim to last `messageLimit` messages
          int startIndex = indexedMessages.length > messageLimit
              ? indexedMessages.length - messageLimit
              : 0;
          doc[ChatsFieldName.messages] = indexedMessages.sublist(startIndex);
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
      final document = await collection.findOne({ChatsFieldName.sessionId: sessionId});

      if (document == null || document[ChatsFieldName.messages] == null) {
        return [];
      }

      List<dynamic> allMessages = document[ChatsFieldName.messages];

      // Keep original order, or reverse if needed
      allMessages = List<Map<String, dynamic>>.from(allMessages.reversed);

      final int start = (page - 1) * itemsPerPage;
      final int end = (start + itemsPerPage).clamp(0, allMessages.length);

      final sublist = allMessages.sublist(start, end);

      // Attach index to each message (original index from the reversed list)
      return List.generate(sublist.length, (i) {
        final message = sublist[i];
        final originalIndex = allMessages.length - 1 - (start + i); // real index from original order
        return {
          ...message,
          MessageFieldName.messageIndex: originalIndex,
        };
      });
    } catch (e) {
      rethrow;
    }
  }



  Future<List<Map<String, dynamic>>> fetchNewUserMessages({
    required String collectionName,
    required String sessionId,
    required int lastIndex, // last seen message index
  }) async {
    final collection = db!.collection(collectionName);

    final doc = await collection.findOne({ChatsFieldName.sessionId: sessionId});
    if (doc == null || !doc.containsKey(ChatsFieldName.messages)) return [];

    final List<dynamic> messages = doc[ChatsFieldName.messages];

    // Get all messages after lastIndex
    final newMessages = messages
        .asMap()
        .entries
        .where((entry) => entry.key > lastIndex)
        .map((entry) => {
      ...Map<String, dynamic>.from(entry.value),
      MessageFieldName.messageIndex: entry.key,
    }).toList();

    return newMessages;
  }




}