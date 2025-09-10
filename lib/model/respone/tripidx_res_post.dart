import 'dart:convert';

TripIdxGetRes tripIdxGetResFromJson(String str) =>
    TripIdxGetRes.fromJson(json.decode(str));

String tripIdxGetResToJson(TripIdxGetRes data) =>
    json.encode(data.toJson());

class TripIdxGetRes {
  int idx;
  String name;
  String country;
  String coverimage;
  String detail;
  int price;
  int duration;
  String destinationZone;

  TripIdxGetRes({
    required this.idx,
    required this.name,
    required this.country,
    required this.coverimage,
    required this.detail,
    required this.price,
    required this.duration,
    required this.destinationZone,
  });

  factory TripIdxGetRes.fromJson(Map<String, dynamic> json) => TripIdxGetRes(
        idx: json["idx"],
        name: json["name"],
        country: json["country"],
        coverimage: json["coverimage"],
        detail: json["detail"],
        price: json["price"],
        duration: json["duration"],
        destinationZone: json["destination_zone"],
      );

  Map<String, dynamic> toJson() => {
        "idx": idx,
        "name": name,
        "country": country,
        "coverimage": coverimage,
        "detail": detail,
        "price": price,
        "duration": duration,
        "destination_zone": destinationZone,
      };
}