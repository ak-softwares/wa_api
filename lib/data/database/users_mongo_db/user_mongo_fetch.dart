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

  // Search documents with pagination
  Future<List<Map<String, dynamic>>> fetchDocumentsBySearchQuery({
    required String collectionName,
    required String query,
    int page = 1,
    int itemsPerPage = 10,
    Map<String, dynamic>? filter,
  }) async {
    await _ensureConnected();
    try {
      final pipeline = [
        {
          "\$search": {
            "index": "default",
            "text": {
              "query": query,
              "path": {"wildcard": "*"}
            }
          }
        },
        if (filter != null && filter.isNotEmpty)
          {"\$match": filter},
        {"\$skip": (page - 1) * itemsPerPage},
        {"\$limit": itemsPerPage}
      ];

      return await db!
          .collection(collectionName)
          .aggregateToStream(pipeline)
          .toList();
    } catch (e) {
      throw Exception('Failed to search documents: $e');
    }
  }

  // Fetch document by ID
  Future<Map<String, dynamic>> fetchDocumentById({required String collectionName, required String id}) async {
    await _ensureConnected();
    try {
      final objectId = ObjectId.fromHexString(id);
      var document = await db!.collection(collectionName).findOne({'_id': objectId});
      if (document == null) {
        throw Exception('Document not found with ID: $id');
      }
      return document;
    } catch (e) {
      throw Exception('Failed to fetch document by ID: $e');
    }
  }



}