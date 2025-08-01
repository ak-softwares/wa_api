import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../../utils/constants/api_constants.dart';
import '../../../../features/authentication/controllers/authentication_controller/authentication_controller.dart';

class WhatsappRepo extends GetxController {
  WhatsappRepo get instance => Get.find();

  final String whatsappBaseDomain      = 'graph.facebook.com';
  final String whatsappApiVersion      = 'v19.0';
  RxString whatsappApiToken = ''.obs;
  RxString whatsappPhoneNumberId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeUserContext();
  }

  void _initializeUserContext() {
    final auth = Get.put(AuthenticationController());
    whatsappApiToken.value = auth.user.value.fBApiCredentials?.accessToken ?? '';
    whatsappPhoneNumberId.value = auth.user.value.fBApiCredentials?.phoneNumberID ?? '';
  }


  // Send OTP via WhatsApp Cloud API
  Future<bool> sendMessage({required String phoneNumber, required String message}) async {

    final Uri uri = Uri.https(
      whatsappBaseDomain,
      '/$whatsappApiVersion/$whatsappPhoneNumberId/messages', // your phone number ID
    );

    final Map<String, dynamic> body = {
      "messaging_product": "whatsapp",
      "to": phoneNumber,
      "type": "text",
      "text": {
        "preview_url": false,
        "body": message
      }
    };

    try {
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $whatsappApiToken',
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        throw Exception(errorJson['error']['message'] ?? 'Failed to send message');
      }
    } catch (e) {
      rethrow;
    }
  }
}
