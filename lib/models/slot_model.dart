import 'dart:convert';

class SlotModel {
  bool status;
  String msg;
  Data data;

  SlotModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory SlotModel.fromRawJson(String str) =>
      SlotModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SlotModel.fromJson(Map<String, dynamic> json) => SlotModel(
        status: json["status"],
        msg: json["msg"],
        data: Data.fromJson(json["data"]),
      );
  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": data.toJson(),
      };
}

class Data {
  dynamic book;
  List<SlotElement> slots;

  Data({
    required this.book,
    required this.slots,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        book: json["book"],
        slots: List<SlotElement>.from(
            json["slots"].map((x) => SlotElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "book": book,
        "slots": List<dynamic>.from(slots.map((x) => x.toJson())),
      };
}

class SlotElement {
  int? id;
  String? slot;
  String? startTime;
  String startTimeFormate;
  String? endTime;
  String endTimeFormate;
  dynamic price;
  String? status;
  DateTime createdAt;
  DateTime updatedAt;
  String? slotDisabled;
  bool isBooked;

  SlotElement({
    required this.id,
    required this.slot,
    required this.startTime,
    required this.startTimeFormate,
    required this.endTime,
    required this.endTimeFormate,
    required this.price,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.slotDisabled,
    required this.isBooked,
  });

  factory SlotElement.fromRawJson(String str) =>
      SlotElement.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SlotElement.fromJson(Map<String, dynamic> json) => SlotElement(
        id: json["id"],
        slot: json["slot"],
        startTime: json["start_time"],
        startTimeFormate: json["start_time_formate"]!,
        endTime: json["end_time"],
        endTimeFormate: json["end_time_formate"]!,
        price: json["price"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        slotDisabled: json["slot_disabled"],
        isBooked: json["isBooked"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "slot": slotEnumValues.reverse[slot],
        "start_time": startTime,
        "start_time_formate": timeFormateValues.reverse[startTimeFormate],
        "end_time": endTime,
        "end_time_formate": timeFormateValues.reverse[endTimeFormate],
        "price": price,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "slot_disabled": slotDisabledValues.reverse[slotDisabled],
        "isBooked": isBooked
      };
}

enum TimeFormate { AM, PM }

final timeFormateValues =
    EnumValues({"AM": TimeFormate.AM, "PM": TimeFormate.PM});

enum SlotEnum { MORNING }

final slotEnumValues = EnumValues({"morning": SlotEnum.MORNING});

enum SlotDisabled { DISABLE, ENABLE }

final slotDisabledValues = EnumValues(
    {"disable": SlotDisabled.DISABLE, "enable": SlotDisabled.ENABLE});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
