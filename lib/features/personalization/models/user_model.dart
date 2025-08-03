import 'package:mongo_dart/mongo_dart.dart';

import '../../../utils/constants/db_constants.dart';
import '../../../utils/helpers/encryption_hepler.dart';
import '../../setup/models/fb_api_credentials.dart';
import '../../setup/models/mongo_db_credentials.dart';
import 'address_model.dart';

class UserModel {
  String? id;
  String? email;
  String? password;
  String? name;
  String? phone;
  AddressModel? address;
  DateTime? dateCreated;
  DateTime? dateModified;
  String? fCMToken;
  MongoDbCredentials? mongoDbCredentials;
  FBApiCredentials? fBApiCredentials;

  UserModel({
    this.id,
    this.email,
    this.password,
    this.name,
    this.phone,
    this.address,
    this.dateCreated,
    this.dateModified,
    this.fCMToken,
    this.mongoDbCredentials,
    this.fBApiCredentials,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {

    return UserModel(
      id: json[UserFieldConstants.id] is ObjectId
          ? (json[UserFieldConstants.id] as ObjectId).toHexString() // Convert ObjectId to string
          : json[UserFieldConstants.id]?.toString(), // Fallback to string if not ObjectId
      email: json[UserFieldConstants.email],
      password: json[UserFieldConstants.password],
      name: json[UserFieldConstants.name],
      phone: json[UserFieldConstants.phone] ?? (json[UserFieldConstants.address]?[UserFieldConstants.phone] ?? ''),
      address: AddressModel.fromJson(json[UserFieldConstants.address] ?? {}),
      dateCreated: json[UserFieldConstants.dateCreated],
      dateModified: json[UserFieldConstants.dateModified],
      fCMToken: json[UserFieldConstants.fCMToken],
      mongoDbCredentials: json[UserFieldConstants.mongoDbCredentials] != null
          ? MongoDbCredentials.fromJson(json[UserFieldConstants.mongoDbCredentials])
          : null,
      fBApiCredentials: json[UserFieldConstants.fBApiCredentials] != null
          ? FBApiCredentials.fromJson(json[UserFieldConstants.fBApiCredentials])
          : null,

    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};

    void addIfNotNull(String key, dynamic value) {
      if (value != null) map[key] = value;
    }
    addIfNotNull(UserFieldConstants.id, id);
    addIfNotNull(UserFieldConstants.email, email);
    addIfNotNull(UserFieldConstants.name, name);
    addIfNotNull(UserFieldConstants.password, EncryptionHelper.hashPassword(password: password ?? ''));
    addIfNotNull(UserFieldConstants.phone, phone);
    addIfNotNull(UserFieldConstants.address, address?.toMap());
    addIfNotNull(UserFieldConstants.dateCreated, dateCreated);
    addIfNotNull(UserFieldConstants.dateModified, dateModified);
    addIfNotNull(UserFieldConstants.mongoDbCredentials, mongoDbCredentials?.toJson());
    addIfNotNull(UserFieldConstants.fBApiCredentials, fBApiCredentials?.toJson());

    return map;
  }

  factory UserModel.fromJsonForLocal(Map<String, dynamic> json) {

    return UserModel(
      id: json[UserFieldConstants.id] is ObjectId
          ? (json[UserFieldConstants.id] as ObjectId).toHexString() // Convert ObjectId to string
          : json[UserFieldConstants.id]?.toString(), // Fallback to string if not ObjectId
      email: json[UserFieldConstants.email],
      name: json[UserFieldConstants.name],
      phone: json[UserFieldConstants.phone] ?? (json[UserFieldConstants.address]?[UserFieldConstants.phone] ?? ''),
      address: AddressModel.fromJson(json[UserFieldConstants.address] ?? {}),
      dateCreated: json[UserFieldConstants.dateCreated] != null
          ? DateTime.parse(json[UserFieldConstants.dateCreated])
          : null,
      dateModified: json[UserFieldConstants.dateModified] != null
          ? DateTime.parse(json[UserFieldConstants.dateModified])
          : null,
      fCMToken: json[UserFieldConstants.fCMToken],
      mongoDbCredentials: json[UserFieldConstants.mongoDbCredentials] != null
          ? MongoDbCredentials.fromJson(json[UserFieldConstants.mongoDbCredentials])
          : null,
      fBApiCredentials: json[UserFieldConstants.fBApiCredentials] != null
          ? FBApiCredentials.fromJson(json[UserFieldConstants.fBApiCredentials])
          : null,

    );
  }

  Map<String, dynamic> toMapForLocal() {
    final map = <String, dynamic>{};

    void addIfNotNull(String key, dynamic value) {
      if (value != null) map[key] = value;
    }

    addIfNotNull(UserFieldConstants.id, id);
    addIfNotNull(UserFieldConstants.email, email);
    addIfNotNull(UserFieldConstants.name, name);
    addIfNotNull(UserFieldConstants.phone, phone);
    // addIfNotNull(UserFieldConstants.address, address?.toMap()); // Assuming address has toJson()
    addIfNotNull(UserFieldConstants.dateCreated, dateCreated?.toIso8601String());
    addIfNotNull(UserFieldConstants.dateModified, dateModified?.toIso8601String());
    addIfNotNull(UserFieldConstants.mongoDbCredentials, mongoDbCredentials?.toJson());
    addIfNotNull(UserFieldConstants.fBApiCredentials, fBApiCredentials?.toJson());

    return map;
  }
}
