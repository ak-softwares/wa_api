import '../../../utils/constants/db_constants.dart';
import '../../../utils/constants/enums.dart';

class MessageModel {
  final UserType type;
  final MessageData data;
  final DateTime? timestamp;
  final int? messageIndex;

  MessageModel({
    required this.type,
    required this.data,
    this.timestamp,
    this.messageIndex
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      type: UserType.values.firstWhere(
            (e) => e.name == json[MessageFieldName.type],
        orElse: () => UserType.ai, // fallback if unknown
      ),
      data: MessageData.fromJson(json[MessageFieldName.data]),
      timestamp: json[MessageFieldName.timestamp],
      messageIndex: json[MessageFieldName.messageIndex],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      MessageFieldName.type: type.name,
      MessageFieldName.data: data.toJson(),
      MessageFieldName.timestamp: timestamp,
    };
  }
}

class MessageData {
  final String content;

  MessageData({required this.content});

  factory MessageData.fromJson(Map<String, dynamic> json) {
    return MessageData(
      content: json[MessageFieldName.content],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      MessageFieldName.content: content,
    };
  }
}
