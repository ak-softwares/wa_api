import 'package:get/get.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../../../features/authentication/controllers/authentication_controller/authentication_controller.dart';
import '../../../features/personalization/models/user_model.dart';

class N8nMongoDatabase {

  static Db? _db;
  static String? _host;
  static String? _dbName; // store DB name

  // Initialize the database connection
  static Future<void> initialize() async {
    final auth = Get.put(AuthenticationController());
    final UserModel user = auth.user.value;
    _host = user.mongoDbCredentials?.connectionString;
    if (_host == null || _host!.isEmpty) {
      throw Exception('MongoDB connection string is not configured');
    }
  }

  // Connect to the database
  static Future<void> connect() async {
    if (_host == null) {
      await initialize();
    }
    if (_db == null || !_db!.isConnected) {
      _db = await Db.create(_host!);
      await _db!.open();
    }
  }

  // Check if database is connected
  static Future<void> ensureConnected() async {
    try {
      await connect();
    } catch (e) {
      throw Exception('Failed to connect to database: $e');
    }
  }

  // Close database connection
  Future<void> close() async {
    await _db?.close();
    _db = null;
  }

  // Getter for the database instance
  Db? get db => _db;
}