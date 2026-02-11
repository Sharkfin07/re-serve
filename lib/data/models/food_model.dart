// Model scaffolded by https://app.quicktype.io/

import 'dart:convert';

FoodModel foodModelFromJson(String str) => FoodModel.fromJson(json.decode(str));

String foodModelToJson(FoodModel data) => json.encode(data.toJson());

class FoodModel {
  String id;
  String name;
  String description;
  String? imageUrl;
  List<String> ingredients;
  int price;
  int? priceDiscount;
  int rating;
  int totalLikes;
  bool isLike;

  FoodModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.ingredients,
    required this.price,
    required this.priceDiscount,
    required this.rating,
    required this.totalLikes,
    required this.isLike,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) => FoodModel(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    imageUrl: json["imageUrl"],
    ingredients: List<String>.from(json["ingredients"].map((x) => x)),
    price: json["price"],
    priceDiscount: json["priceDiscount"],
    rating: json["rating"],
    totalLikes: json["totalLikes"],
    isLike: json["isLike"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "imageUrl": imageUrl,
    "ingredients": List<dynamic>.from(ingredients.map((x) => x)),
    "price": price,
    "priceDiscount": priceDiscount,
    "rating": rating,
    "totalLikes": totalLikes,
    "isLike": isLike,
  };
}
