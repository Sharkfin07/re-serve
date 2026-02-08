// Model scaffolded by https://app.quicktype.io/

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String id;
  String name;
  String email;
  String role;
  String profilePictureUrl;
  String phoneNumber;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.profilePictureUrl,
    required this.phoneNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    role: json["role"],
    profilePictureUrl: json["profilePictureUrl"],
    phoneNumber: json["phoneNumber"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "role": role,
    "profilePictureUrl": profilePictureUrl,
    "phoneNumber": phoneNumber,
  };
}
