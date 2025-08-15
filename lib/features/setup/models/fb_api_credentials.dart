import '../../../utils/constants/db_constants.dart';
import '../../../utils/helpers/encryption_helper.dart';

class FBApiCredentials {
  final String accessToken;
  final String phoneNumberID;

  FBApiCredentials({
    required this.accessToken,
    required this.phoneNumberID,
  });

  // Convert class to JSON map
  Map<String, dynamic> toJson() {
    return {
      FBApiCredentialsFieldName.accessToken: EncryptionHelper.encryptText(accessToken),
      FBApiCredentialsFieldName.phoneNumberID: phoneNumberID,
    };
  }

  // Create class from JSON map
  factory FBApiCredentials.fromJson(Map<String, dynamic> json) {
    return FBApiCredentials(
      accessToken: EncryptionHelper.decryptText(json[FBApiCredentialsFieldName.accessToken]),
      phoneNumberID: json[FBApiCredentialsFieldName.phoneNumberID],
    );
  }
}
