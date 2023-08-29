class ChatRoomModel {
  String? chatroomid;
  List<String>? participants;

  ChatRoomModel({this.chatroomid, this.participants});

  // Factory constructor to create a ChatRoomModel from a map
  factory ChatRoomModel.fromMap(Map<String, dynamic> map) {
    return ChatRoomModel(
      chatroomid: map["chatroomid"],
      participants: List<String>.from(map["participants"]),
    );
  }

  // Convert ChatRoomModel object to a map
  Map<String, dynamic> toMap() {
    return {
      "chatroomid": chatroomid,
      "participants": participants,
    };
  }
}
