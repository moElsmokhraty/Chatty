class Message {

  Message({
    this.message,
    this.id
  });

  Message.fromJson(dynamic json) {
    message = json['message'];
    id = json['id'];
  }
  String? message;

  String? id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['id'] = id;
    return map;
  }

}