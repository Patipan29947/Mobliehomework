// To parse this JSON data, do
//
//     final customerRegPostRes = customerRegPostResFromJson(jsonString);

import 'dart:convert';

CustomerRegPostRes customerRegPostResFromJson(String str) => CustomerRegPostRes.fromJson(json.decode(str));

String customerRegPostResToJson(CustomerRegPostRes data) => json.encode(data.toJson());

class CustomerRegPostRes {
    String fullname;
    String phone;
    String email;
    String image;
    String password;

    CustomerRegPostRes({
        required this.fullname,
        required this.phone,
        required this.email,
        required this.image,
        required this.password,
    });

    factory CustomerRegPostRes.fromJson(Map<String, dynamic> json) => CustomerRegPostRes(
        fullname: json["fullname"],
        phone: json["phone"],
        email: json["email"],
        image: json["image"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "fullname": fullname,
        "phone": phone,
        "email": email,
        "image": image,
        "password": password,
    };
}
