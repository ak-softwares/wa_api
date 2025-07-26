class MessageModel {
  final String type; // "human" or "ai"
  final MessageData data;
  final Map<String, dynamic> additionalKwargs;
  final Map<String, dynamic> responseMetadata;
  final List<dynamic>? toolCalls;
  final List<dynamic>? invalidToolCalls;

  MessageModel({
    required this.type,
    required this.data,
    required this.additionalKwargs,
    required this.responseMetadata,
    this.toolCalls,
    this.invalidToolCalls,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      type: json['type'],
      data: MessageData.fromJson(json['data']),
      additionalKwargs:
      Map<String, dynamic>.from(json['additional_kwargs'] ?? {}),
      responseMetadata:
      Map<String, dynamic>.from(json['response_metadata'] ?? {}),
      toolCalls: json['tool_calls'] ?? [],
      invalidToolCalls: json['invalid_tool_calls'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'data': data.toJson(),
      'additional_kwargs': additionalKwargs,
      'response_metadata': responseMetadata,
      'tool_calls': toolCalls ?? [],
      'invalid_tool_calls': invalidToolCalls ?? [],
    };
  }
}

class MessageData {
  final String content;

  MessageData({required this.content});

  factory MessageData.fromJson(Map<String, dynamic> json) {
    return MessageData(
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
    };
  }
}
