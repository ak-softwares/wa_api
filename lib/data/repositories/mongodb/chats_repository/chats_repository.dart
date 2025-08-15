import 'package:get/get.dart';

import '../../../../features/authentication/controllers/authentication_controller/authentication_controller.dart';
import '../../../../features/chat/models/chat_model.dart';
import '../../../../utils/constants/api_constants.dart';
import '../../../../utils/constants/db_constants.dart';
import '../../../database/mongodb/mongo_fetch.dart';
import '../../../database/mongodb/mongo_update.dart';
import '../../../database/n8n_mongo_db/user_mongo_fetch.dart';
import '../../../database/n8n_mongo_db/user_mongo_update.dart';


class ChatsRepository extends GetxController {
  static ChatsRepository get instance => Get.find();

  late final _mongoFetch;
  late final _mongoUpdate;
  late final String collectionName;

  final int chatLoadPerPage = APIConstant.chatLoadPerPage;
  final int messagesLoadPerPage = APIConstant.messagesLoadPerPage;
  final auth = Get.put(AuthenticationController());

  ChatsRepository() {
    final bool isN8n = auth.user.value.isN8nUser ?? false;

    if (isN8n) {
      _mongoFetch = UserMongoFetch();
      _mongoUpdate = UserMongoUpdate();
      collectionName = auth.user.value.mongoDbCredentials?.collectionName ?? DbCollections.chats;
    } else {
      _mongoFetch = MongoFetch();
      _mongoUpdate = MongoUpdate();
      collectionName = DbCollections.chats;
    }
  }

  // Fetch all chats
  Future<List<ChatModel>> fetchAllChats({int page = 1}) async {
    try {
      // Fetch products from MongoDB with pagination
      final List<Map<String, dynamic>> chatsData = await _mongoFetch.getChats(
          collectionName: collectionName,
          page: page,
          itemsPerPage: chatLoadPerPage,
          messageLimit: 1
      );
      // Convert data to a list of ProductModel
      final List<ChatModel> chats = chatsData.map((data) => ChatModel.fromJson(data)).toList();
      return chats;
    } catch (e) {
      rethrow;
    }
  }

  // Update Last seen in chat
  Future<void> updateLastSeenBySessionId({required String sessionId, required int lastSeenIndex}) async {
    try {
      await _mongoUpdate.updateLastSeenBySessionId(
        collectionName: collectionName,
        sessionId: sessionId,
        lastSeenIndex: lastSeenIndex,
      );
    } catch (e) {
      rethrow;
    }
  }

}