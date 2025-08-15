import 'package:get/get.dart';

import '../../../../features/authentication/controllers/authentication_controller/authentication_controller.dart';
import '../../../../features/chat/models/message_model.dart';
import '../../../../utils/constants/api_constants.dart';
import '../../../../utils/constants/db_constants.dart';
import '../../../database/mongodb/mongo_fetch.dart';
import '../../../database/mongodb/mongo_insert.dart';
import '../../../database/n8n_mongo_db/user_mongo_fetch.dart';
import '../../../database/n8n_mongo_db/user_mongo_insert.dart';
import '../../user_whatsapp/send_message/send_message.dart';

class MessagesRepository extends GetxController {
  static MessagesRepository get instance => Get.find();

  late final _mongoFetch;
  late final _mongoInsert;
  late final String collectionName;

  final int messagesLoadPerPage = APIConstant.messagesLoadPerPage;
  final auth = Get.put(AuthenticationController());
  final whatsappRepo = Get.put(WhatsappRepo());

  MessagesRepository() {
    final bool isN8n = auth.user.value.isN8nUser ?? false;

    if (isN8n) {
      _mongoFetch = UserMongoFetch();
      _mongoInsert = UserMongoInsert();
      collectionName = auth.user.value.mongoDbCredentials?.collectionName ?? DbCollections.chats;
    } else {
      _mongoFetch = MongoFetch();
      _mongoInsert = MongoInsert();
      collectionName = DbCollections.chats;
    }
  }

  // Fetch all chats
  Future<List<MessageModel>> fetchAllMessages({required String sessionId, int page = 1}) async {
    try {
      // Fetch products from MongoDB with pagination
      final List<Map<String, dynamic>> chatsData =
      await _mongoFetch.fetchMessages(
          collectionName: collectionName,
          sessionId: sessionId,
          page: page,
          itemsPerPage: messagesLoadPerPage
      );
      // Convert data to a list of ProductModel
      final List<MessageModel> chats = chatsData.map((data) => MessageModel.fromJson(data)).toList();
      return chats;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MessageModel>> fetchNewUserMessages({
    required String sessionId,
    required int lastIndex,
  }) async {
    try {
      final messagesData = await _mongoFetch.fetchUsersNewMessages(
        collectionName: collectionName,
        sessionId: sessionId,
        lastIndex: lastIndex,
      );

      return messagesData.map((json) => MessageModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }



  Future<void> sendMessage({required String phoneNumber, required String message}) async {
    try {
      await whatsappRepo.sendMessage(phoneNumber: phoneNumber, message: message);
    }catch(e) {
      rethrow;
    }
  }

  // Update message
  Future<void> insertMessages({required String sessionId, required MessageModel message}) async {
    try {
      await _mongoInsert.insertMessageToSession(
        collectionName: collectionName,
        sessionId: sessionId,
        message: message.toJson(),
        lastSeenIndex: message.messageIndex,
      );
    } catch (e) {
      rethrow;
    }
  }
}