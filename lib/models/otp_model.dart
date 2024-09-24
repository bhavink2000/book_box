import 'dart:convert';

class OtpModel {
  Data data;
  bool status;
  String msg;

  OtpModel({
    required this.data,
    required this.status,
    required this.msg,
  });

  factory OtpModel.fromRawJson(String str) => OtpModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OtpModel.fromJson(Map<String, dynamic> json) => OtpModel(
    data: Data.fromJson(json["data"]),
    status: json["status"],
    msg: json["msg"],
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
    "status": status,
    "msg": msg,
  };
}

class Data {
  int id;
  dynamic name;
  dynamic firstName;
  dynamic lastName;
  String number;
  dynamic image;
  dynamic email;
  dynamic emailVerifiedAt;
  String token;
  String roleId;
  dynamic location;
  String status;
  String otp;
  DateTime createdAt;
  DateTime updatedAt;

  Data({
    required this.id,
    required this.name,
    required this.firstName,
    required this.lastName,
    required this.number,
    required this.image,
    required this.email,
    required this.emailVerifiedAt,
    required this.token,
    required this.roleId,
    required this.location,
    required this.status,
    required this.otp,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    number: json["number"],
    image: json["image"],
    email: json["email"],
    emailVerifiedAt: json["email_verified_at"],
    token: json["token"],
    roleId: json["role_id"],
    location: json["location"],
    status: json["status"],
    otp: json["otp"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "first_name": firstName,
    "last_name": lastName,
    "number": number,
    "image": image,
    "email": email,
    "email_verified_at": emailVerifiedAt,
    "token": token,
    "role_id": roleId,
    "location": location,
    "status": status,
    "otp": otp,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
