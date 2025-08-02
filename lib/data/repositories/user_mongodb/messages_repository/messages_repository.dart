import 'package:get/get.dart';

import '../../../../features/authentication/controllers/authentication_controller/authentication_controller.dart';
import '../../../../features/chat/models/message_model.dart';
import '../../../../utils/constants/api_constants.dart';
import '../../../database/users_mongo_db/user_mongo_fetch.dart';
import '../../../database/users_mongo_db/user_mongo_insert.dart';
import '../../user_whatsapp/send_message/send_message.dart';

class MessagesRepository extends GetxController {
  static MessagesRepository get instance => Get.find();

  final UserMongoFetch _userMongoFetch = UserMongoFetch();
  final UserMongoInsert _userMongoInsert = UserMongoInsert();
  RxString collectionName = ''.obs;
  final int messagesLoadPerPage = APIConstant.messagesLoadPerPage;
  final whatsappRepo = Get.put(WhatsappRepo());


  @override
  void onInit() {
    super.onInit();
    _initializeUserContext();
  }

  void _initializeUserContext() {
    final auth = Get.put(AuthenticationController());
    collectionName.value = auth.user.value.mongoDbCredentials?.collectionName ?? '';
  }

  // Fetch all chats
  Future<List<MessageModel>> fetchAllMessages({required String sessionId, int page = 1}) async {
    try {
      _initializeUserContext();
      // Fetch products from MongoDB with pagination
      final List<Map<String, dynamic>> chatsData =
      await _userMongoFetch.fetchMessages(
          collectionName: collectionName.value,
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
      _initializeUserContext();

      final messagesData = await _userMongoFetch.fetchNewUserMessages(
        collectionName: collectionName.value,
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
      _initializeUserContext();
      await _userMongoInsert.insertMessageToSession(
        collectionName: collectionName.value,
        sessionId: sessionId,
        message: message.toJson(),
        lastSeenIndex: message.messageIndex,
      );
    } catch (e) {
      rethrow;
    }
  }
}