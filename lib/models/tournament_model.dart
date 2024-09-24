import 'dart:convert';

class TournamentModel {
  bool status;
  String msg;
  List<Datum> data;

  TournamentModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory TournamentModel.fromRawJson(String str) => TournamentModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TournamentModel.fromJson(Map<String, dynamic> json) => TournamentModel(
    status: json["status"],
    msg: json["msg"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int id;
  String name;
  String location;
  String registrationNumber;
  String details;
  String image;
  DateTime createdAt;
  DateTime updatedAt;

  Datum({
    required this.id,
    required this.name,
    required this.location,
    required this.registrationNumber,
    required this.details,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    location: json["location"],
    registrationNumber: json["registration_number"],
    details: json["details"],
    image: json["image"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "location": location,
    "registration_number": registrationNumber,
    "details": details,
    "image": image,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
