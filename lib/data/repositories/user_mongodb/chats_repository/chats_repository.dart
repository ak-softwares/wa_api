import 'package:get/get.dart';

import '../../../../features/chat/models/chats_model.dart';
import '../../../../utils/constants/api_constants.dart';
import '../../../../utils/constants/db_constants.dart';
import '../../../database/users_mongo_db/user_mongo_fetch.dart';

class ChatsRepository extends GetxController {
  static ChatsRepository get instance => Get.find();

  final UserMongoFetch _userMongoFetch = UserMongoFetch();
  final String collectionName = DbCollections.n8nChatHistories;
  final int itemsPerPage = int.tryParse(APIConstant.itemsPerPage) ?? 10;

  // Fetch all chats
  Future<List<ChatModel>> fetchAllChats({int page = 1}) async {
    try {
      // Fetch products from MongoDB with pagination
      final List<Map<String, dynamic>> chatsData =
              await _userMongoFetch.fetchDocuments(
                  collectionName:collectionName,
                  page: page
              );

      // Convert data to a list of ProductModel
      final List<ChatModel> chats = chatsData.map((data) => ChatModel.fromJson(data)).toList();
      return chats;
    } catch (e) {
      rethrow;
    }
  }

}