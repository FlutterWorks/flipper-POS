import 'dart:convert';

import 'package:objectbox/objectbox.dart';

Message sMessageJson(String str) => Message.fromJson(json.decode(str));

@Entity()
class Message {
  Message(
      {this.id = 0,
      required this.message,
      required this.createdAt,
      required this.receiverId,
      required this.senderId,
      this.status = false,
      this.senderImage,
      required this.senderName,
      this.author,
      required this.lastActiveId});
  @Id(assignable: true)
  int id;
  @Property(uid: 1)
  String message;
  String createdAt;
  int receiverId;
  int lastActiveId;
  @Property(uid: 2)

  /// this is a business Id from business table.
  int senderId;
  String senderName;
  bool status;
  String? senderImage;
  // add extra field
  String? author;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
      id: json["id"],
      message: json["message"],
      createdAt: json["createdAt"],
      receiverId: json["receiverId"],
      lastActiveId: json["lastActiveId"],
      senderName: json["senderName"],
      status: json["status"],
      senderImage: json["senderImage"],
      senderId: json["senderId"]);
  Map<String, dynamic> toJson() => {
        "id": int.parse(id.toString()),
        "message": message,
        "senderName": senderName,
        "createdAt": createdAt,
        "receiverId": receiverId,
        "lastActiveId": lastActiveId,
        "senderId": senderId,
        "status": status,
        "senderImage": senderImage
      };
}
