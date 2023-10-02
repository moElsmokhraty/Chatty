class Message {
  String? message;
  String? id;

  Message({
    this.message,
    this.id,
  });

  Message.fromJson(dynamic json) {
    message = json['message'] as String?;
    id = json['id'] as String?;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['id'] = id;
    return map;
  }
}
