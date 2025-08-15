import 'dart:async';
import 'package:get/get.dart';

import '../../../../features/personalization/models/user_model.dart';
import '../../../../utils/constants/api_constants.dart';
import '../../../../utils/constants/db_constants.dart';
import '../../../../utils/constants/enums.dart';
import '../../../database/mongodb/mongo_delete.dart';
import '../../../database/mongodb/mongo_fetch.dart';
import '../../../database/mongodb/mongo_insert.dart';
import '../../../database/mongodb/mongo_update.dart';

class MongoUserRepository extends GetxController {
  static MongoUserRepository get instance => Get.find();
  final MongoFetch _mongoFetch = MongoFetch();
  final MongoInsert _mongoInsert = MongoInsert();
  final MongoUpdate _mongoUpdate = MongoUpdate();
  final MongoDelete _mongoDelete = MongoDelete();
  final String collectionName = DbCollections.users;
  final int itemsPerPage = APIConstant.itemsPerPage;

  // Fetch All Products from MongoDB
  Future<List<UserModel>> fetchAppUsers({int page = 1}) async {
    try {
      // Fetch products from MongoDB with pagination
      final List<Map<String, dynamic>> usersData =
      await _mongoFetch.fetchDocuments(
          collectionName:collectionName,
          page: page
      );

      // Convert data to a list of ProductModel
      final List<UserModel> users = usersData.map((data) => UserModel.fromJson(data)).toList();
      return users;
    } catch (e) {
      throw 'Failed to fetch user: $e';
    }
  }

  // Update a customer
  Future<void> updateUserById({required String userId, required UserModel user}) async {
    try {
      Map<String, dynamic> customerMap = user.toMap();
      await _mongoUpdate.updateDocumentById(
          collectionName: collectionName,
          id: userId,
          updatedData: customerMap
      );
    } catch (e) {
      rethrow;
    }
  }

  // Add a new customer
  Future<void> insertUser({required UserModel customer}) async {
    try {
      Map<String, dynamic> customerMap = customer.toMap(); // Convert customer model to map
      await _mongoInsert.insertDocument(collectionName, customerMap);
    } catch (e) {
      throw 'Failed to add customer: $e';
    }
  }

  Future<UserModel> fetchUserById({required String id}) async {
    try {
      // Fetch a single document by ID
      final Map<String, dynamic>? customerData =
      await _mongoFetch.fetchDocumentById(collectionName: collectionName, id: id);

      // Check if the document exists
      if (customerData == null) {
        throw Exception('Customer not found with ID: $id');
      }

      // Convert the document to a CustomerModel object
      final UserModel customer = UserModel.fromJson(customerData);
      return customer;
    } catch (e) {
      throw 'Failed to fetch customer: $e';
    }
  }

  Future<void> deleteUserById({required String id}) async {
    try {
      await _mongoDelete.deleteDocumentById(id: id, collectionName: collectionName);
    } catch (e) {
      throw 'Failed to delete customer: $e';
    }
  }

}
