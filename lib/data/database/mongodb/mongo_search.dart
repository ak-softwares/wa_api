import 'package:mongo_dart/mongo_dart.dart';
import 'mongo_base.dart';

class MongoSearch extends MongoDatabase {
  static final MongoSearch _instance = MongoSearch._internal();
  factory MongoSearch() => _instance;
  MongoSearch._internal();

  Future<void> _ensureConnected() async {
    await MongoDatabase.ensureConnected();
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

  Future<List<Map<String, dynamic>>> searchDocumentsByFields1({
    required String collectionName,
    required String searchTerm,
    required List<String> searchFields,
    Map<String, dynamic>? filter,
    int page = 1,
    int itemsPerPage = 10,
    int sortOrder = 1,
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

      query = query.eq(searchFields.first, int.tryParse(searchTerm));

      final documents = await collection.find(query).toList();

      return documents;
    } catch (e) {
      throw Exception('Search failed: ${e.toString()}');
    }
  }




}