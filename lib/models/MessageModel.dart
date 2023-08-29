class MessageModel {
  String? sender;
  String? text;
  bool? seen;
  DateTime? createdOn;

  MessageModel({
    this.sender,
    this.text,
    this.seen,
    this.createdOn,
  });

  // Convert MessageModel object to a map
  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'text': text,
      'seen': seen,
      'createdOn': createdOn?.toIso8601String(),
    };
  }

  // Create a MessageModel object from a map
  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      sender: map['sender'],
      text: map['text'],
      seen: map['seen'],
      createdOn: map['createdOn'] != null
          ? DateTime.parse(map['createdOn'])
          : null,
    );
  }
}
