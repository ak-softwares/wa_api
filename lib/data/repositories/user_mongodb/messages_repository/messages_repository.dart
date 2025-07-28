import 'package:get/get.dart';

import '../../../../features/authentication/controllers/authentication_controller/authentication_controller.dart';
import '../../../../features/chat/models/message_model.dart';
import '../../../../utils/constants/api_constants.dart';
import '../../../database/users_mongo_db/user_mongo_fetch.dart';

class MessagesRepository extends GetxController {
  static MessagesRepository get instance => Get.find();

  final UserMongoFetch _userMongoFetch = UserMongoFetch();
  RxString collectionName = ''.obs;
  final int itemsPerPage = int.tryParse(APIConstant.itemsPerPage) ?? 10;


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
          page: page
      );
      // Convert data to a list of ProductModel
      final List<MessageModel> chats = chatsData.map((data) => MessageModel.fromJson(data)).toList();
      return chats;
    } catch (e) {
      rethrow;
    }
  }

}