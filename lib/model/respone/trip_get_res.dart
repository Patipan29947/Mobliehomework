// To parse this JSON data, do
//
//     final tripgetres = tripgetresFromJson(jsonString);

import 'dart:convert';

List<Tripgetres> tripgetresFromJson(String str) => List<Tripgetres>.from(json.decode(str).map((x) => Tripgetres.fromJson(x)));

String tripgetresToJson(List<Tripgetres> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Tripgetres {
    int idx;
    String name;
    String country;
    String coverimage;
    String detail;
    int price;
    int duration;
    String destinationZone;

    Tripgetres({
        required this.idx,
        required this.name,
        required this.country,
        required this.coverimage,
        required this.detail,
        required this.price,
        required this.duration,
        required this.destinationZone,
    });

    factory Tripgetres.fromJson(Map<String, dynamic> json) => Tripgetres(
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
