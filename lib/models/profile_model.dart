import 'dart:convert';

class ProfileModel {
  bool status;
  String msg;
  List<Datum> data;

  ProfileModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory ProfileModel.fromRawJson(String str) => ProfileModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
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
  String name;
  String price;
  String status;

  Datum({
    required this.name,
    required this.price,
    required this.status,
  });

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    name: json["name"],
    price: json["price"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "price": price,
    "status": status,
  };
}
