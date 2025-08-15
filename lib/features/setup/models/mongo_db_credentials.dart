import '../../../utils/constants/db_constants.dart';
import '../../../utils/helpers/encryption_helper.dart';

class MongoDbCredentials {
  final String connectionString;
  final String dataBaseName;
  final String collectionName;

  MongoDbCredentials({
    required this.connectionString,
    required this.dataBaseName,
    required this.collectionName,
  });

  // Create class from JSON map
  factory MongoDbCredentials.fromJson(Map<String, dynamic> json) {
    return MongoDbCredentials(
      connectionString: EncryptionHelper.decryptText(json[MongoDBCredentialsFieldName.connectionString]),
      dataBaseName: json[MongoDBCredentialsFieldName.dataBaseName],
      collectionName: json[MongoDBCredentialsFieldName.collectionName],
    );
  }

  // Convert class to JSON map
  Map<String, dynamic> toJson() {
    return {
      MongoDBCredentialsFieldName.connectionString: EncryptionHelper.encryptText(connectionString),
      MongoDBCredentialsFieldName.dataBaseName: dataBaseName,
      MongoDBCredentialsFieldName.collectionName: collectionName,
    };
  }
}
