import 'dart:convert';

class SlotBookingModel {

  bool status;
  String msg;
  Data data;

  SlotBookingModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory SlotBookingModel.fromRawJson(String str) => SlotBookingModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SlotBookingModel.fromJson(Map<String, dynamic> json) => SlotBookingModel(
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
  int id;
  String userId;
  String bookingsId;
  String bookingDate;
  DateTime createdAt;
  DateTime updatedAt;
  Booking booking;

  Data({
    required this.id,
    required this.userId,
    required this.bookingsId,
    required this.bookingDate,
    required this.createdAt,
    required this.updatedAt,
    required this.booking,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    userId: json["user_id"],
    bookingsId: json["bookings_id"],
    bookingDate: json["booking_date"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    booking: Booking.fromJson(json["booking"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "bookings_id": bookingsId,
    "booking_date": bookingDate,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "booking": booking.toJson(),
  };
}

class Booking {
  int id;
  dynamic userId;
  String name;
  String city;
  String time;
  String time1;
  String price;
  dynamic rating;
  String image;
  String status;
  String details;
  String address;
  dynamic map;
  DateTime createdAt;
  DateTime updatedAt;

  Booking({
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
  });

  factory Booking.fromRawJson(String str) => Booking.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
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
  };
}
