import 'package:mongo_dart/mongo_dart.dart';

import '../../../utils/constants/db_constants.dart';
import 'message_model.dart';

class ChatModel {
  String? id;
  final String sessionId;
  List<MessageModel>? messages;
  final DateTime? lastModified;
  int? lastSeenIndex;


  ChatModel({
    required this.id,
    required this.sessionId,
    this.messages,
    this.lastModified,
    this.lastSeenIndex,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    final messages = (json[ChatsFieldName.messages] as List<dynamic>)
        .map((e) => MessageModel.fromJson(e))
        .toList();

    return ChatModel(
      id: json[ChatsFieldName.id] is ObjectId
          ? (json[ChatsFieldName.id] as ObjectId).toHexString() // Convert ObjectId to string
          : json[ChatsFieldName.id]?.toString(), // Fallback to string if not ObjectId
      sessionId: json[ChatsFieldName.sessionId],
      messages: messages,
      lastModified: json[ChatsFieldName.lastModified],
      lastSeenIndex: json[ChatsFieldName.lastSeenIndex],
    );
  }

  Map<String, dynamic> toJson() {

    return {
      ChatsFieldName.id: id,
      ChatsFieldName.sessionId: sessionId,
      ChatsFieldName.messages: messages?.map((e) => e.toJson()).toList(),
      ChatsFieldName.lastModified: lastModified,
      ChatsFieldName.lastSeenIndex: lastSeenIndex,
    };
  }
}
