import 'package:mongo_dart/mongo_dart.dart';

import '../../../utils/constants/db_constants.dart';
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
    this.mongoDbCredentials
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
    addIfNotNull(UserFieldConstants.password, password);
    addIfNotNull(UserFieldConstants.phone, phone);
    addIfNotNull(UserFieldConstants.address, address?.toMap());
    addIfNotNull(UserFieldConstants.dateCreated, dateCreated);
    addIfNotNull(UserFieldConstants.dateModified, dateModified);
    addIfNotNull(UserFieldConstants.mongoDbCredentials, mongoDbCredentials?.toJson());

    return map;
  }
}
