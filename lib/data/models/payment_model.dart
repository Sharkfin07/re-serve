// Model scaffolded by https://app.quicktype.io/

import 'dart:convert';

PaymentModel paymentModelFromJson(String str) =>
    PaymentModel.fromJson(json.decode(str));

String paymentModelToJson(PaymentModel data) => json.encode(data.toJson());

class PaymentModel {
  String id;
  String name;
  String imageUrl;

  PaymentModel({required this.id, required this.name, required this.imageUrl});

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
    id: json["id"],
    name: json["name"],
    imageUrl: json["imageUrl"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "imageUrl": imageUrl,
  };
}
