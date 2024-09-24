import 'dart:convert';

class BoxModel {
  bool status;
  String msg;
  Data data;
  Pagination pagination;

  BoxModel({
    required this.status,
    required this.msg,
    required this.data,
    required this.pagination,
  });

  factory BoxModel.fromRawJson(String str) =>
      BoxModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BoxModel.fromJson(Map<String, dynamic> json) => BoxModel(
        status: json["status"],
        msg: json["msg"],
        data: Data.fromJson(json["data"]),
        pagination: Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": data.toJson(),
        "pagination": pagination.toJson(),
      };
}

class Data {
  int? currentPage;
  List<ListElement> data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  String? nextPageUrl;
  String? path;
  String? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  Data({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        currentPage: json["current_page"],
        data: List<ListElement>.from(
            json["data"].map((x) => ListElement.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class ListElement {
  int? id;
  String? userId;
  String? name;
  String? city;
  String? time;
  String? time1;
  String? price;
  dynamic rating;
  String? image;
  String? status;
  String? details;
  String? address;
  String? map;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic? latitude;
  dynamic? longitude;

  ListElement({
    required this.id,
    required this.userId,
    required this.name,
    required this.city,
    required this.time,
    required this.time1,
    required this.price,
    required this.rating,
    required this.image,
    required this.status,
    required this.details,
    required this.address,
    required this.map,
    required this.createdAt,
    required this.updatedAt,
    required this.latitude,
    required this.longitude,
  });

  factory ListElement.fromRawJson(String str) =>
      ListElement.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
        id: json["id"],
        userId: json["user_id"],
        name: json["name"],
        city: json["city"],
        time: json["time"],
        time1: json["time1"],
        price: json["price"],
        rating: json["rating"],
        image: json["image"],
        status: json["status"],
        details: json["details"],
        address: json["address"],
        map: json["map"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        latitude: json["latitude"],
        longitude: json["longitude"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "name": name,
        "city": city,
        "time": time,
        "time1": time1,
        "price": price,
        "rating": rating,
        "image": image,
        "status": status,
        "details": details,
        "address": address,
        "map": map,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "latitude": latitude,
        "longitude": longitude,
      };
}

class Pagination {
  int currentPage;
  int total;

  Pagination({
    required this.currentPage,
    required this.total,
  });

  factory Pagination.fromRawJson(String str) =>
      Pagination.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        currentPage: json["current_page"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "total": total,
      };
}
