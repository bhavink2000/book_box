import 'dart:convert';

class LoginModel {
  bool status;
  String msg;
  String data;

  LoginModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory LoginModel.fromRawJson(String str) =>
      LoginModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        status: json["status"],
        msg: json["msg"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": data,
      };
}
