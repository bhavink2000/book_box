import 'dart:convert';

class DeeplinkingModel {
  bool status;
  String deep_link;
  String box_id;
  String date;

  DeeplinkingModel({
    required this.status,
    required this.deep_link,
    required this.box_id,
    required this.date,
  });

  factory DeeplinkingModel.fromRawJson(String str) =>
      DeeplinkingModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DeeplinkingModel.fromJson(Map<String, dynamic> json) =>
      DeeplinkingModel(
        status: json["status"],
        deep_link: json["deep_link"],
        box_id: json["box_id"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "deep_link": deep_link,
        "box_id": box_id,
        "date": date,
      };
}
