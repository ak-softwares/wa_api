import 'package:mongo_dart/mongo_dart.dart';

import '../../../utils/constants/db_constants.dart';
import '../../../utils/helpers/encryption_helper.dart';
import '../../setup/models/fb_api_credentials.dart';
import '../../setup/models/mongo_db_credentials.dart';

class UserModel {
  String? id;
  String? email;
  String? password;
  String? name;
  String? phone;
  DateTime? dateCreated;
  DateTime? dateModified;
  String? fCMToken;
  FBApiCredentials? fBApiCredentials;
  bool? isN8nUser;
  MongoDbCredentials? mongoDbCredentials;

  UserModel({
    this.id,
    this.email,
    this.password,
    this.name,
    this.phone,
    this.dateCreated,
    this.dateModified,
    this.fCMToken,
    this.fBApiCredentials,
    this.isN8nUser,
    this.mongoDbCredentials,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, {bool isLocal = false}) {

    return UserModel(
      id: json[UserFieldConstants.id] is ObjectId
          ? (json[UserFieldConstants.id] as ObjectId).toHexString() // Convert ObjectId to string
          : json[UserFieldConstants.id]?.toString(), // Fallback to string if not ObjectId
      email: json[UserFieldConstants.email],
      password: json[UserFieldConstants.password],
      name: json[UserFieldConstants.name],
      phone: json[UserFieldConstants.phone] ?? (json[UserFieldConstants.address]?[UserFieldConstants.phone] ?? ''),
      dateCreated: isLocal && json[UserFieldConstants.dateCreated] != null
          ? DateTime.parse(json[UserFieldConstants.dateCreated])
          : json[UserFieldConstants.dateCreated],
      dateModified: isLocal && json[UserFieldConstants.dateModified] != null
          ? DateTime.parse(json[UserFieldConstants.dateModified])
          : json[UserFieldConstants.dateModified],
      fCMToken: json[UserFieldConstants.fCMToken],
      mongoDbCredentials: json[UserFieldConstants.mongoDbCredentials] != null
          ? MongoDbCredentials.fromJson(json[UserFieldConstants.mongoDbCredentials])
          : null,
      isN8nUser: json[UserFieldConstants.isN8nUser],
      fBApiCredentials: json[UserFieldConstants.fBApiCredentials] != null
          ? FBApiCredentials.fromJson(json[UserFieldConstants.fBApiCredentials])
          : null,

    );
  }

  Map<String, dynamic> toMap({bool isLocal = false}) {
    final map = <String, dynamic>{};

    void addIfNotNull(String key, dynamic value) {
      if (value != null) map[key] = value;
    }
    addIfNotNull(UserFieldConstants.id, id);
    addIfNotNull(UserFieldConstants.email, email);
    addIfNotNull(UserFieldConstants.name, name);
    addIfNotNull(UserFieldConstants.password, EncryptionHelper.hashPassword(password: password ?? ''));
    addIfNotNull(UserFieldConstants.phone, phone);
    addIfNotNull(UserFieldConstants.dateCreated, isLocal ? dateCreated?.toIso8601String() : dateCreated);
    addIfNotNull(UserFieldConstants.dateModified, isLocal ? dateModified?.toIso8601String() : dateModified);
    addIfNotNull(UserFieldConstants.fCMToken, fCMToken);
    addIfNotNull(UserFieldConstants.fBApiCredentials, fBApiCredentials?.toJson());
    addIfNotNull(UserFieldConstants.isN8nUser, isN8nUser);
    addIfNotNull(UserFieldConstants.mongoDbCredentials, mongoDbCredentials?.toJson());

    return map;
  }

}
