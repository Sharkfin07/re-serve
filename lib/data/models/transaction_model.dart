// Model scaffolded by https://app.quicktype.io/

import 'dart:convert';

TransactionModel transactionModelFromJson(String str) =>
    TransactionModel.fromJson(json.decode(str));

String transactionModelToJson(TransactionModel data) =>
    json.encode(data.toJson());

class TransactionModel {
  String id;
  String userId;
  String paymentMethodId;
  String invoiceId;
  String status;
  int totalAmount;
  dynamic proofPaymentUrl;
  DateTime orderDate;
  DateTime expiredDate;
  DateTime createdAt;
  DateTime updatedAt;
  PaymentMethod paymentMethod;
  List<TransactionItem> transactionItems;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.paymentMethodId,
    required this.invoiceId,
    required this.status,
    required this.totalAmount,
    required this.proofPaymentUrl,
    required this.orderDate,
    required this.expiredDate,
    required this.createdAt,
    required this.updatedAt,
    required this.paymentMethod,
    required this.transactionItems,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        id: json["id"],
        userId: json["userId"],
        paymentMethodId: json["paymentMethodId"],
        invoiceId: json["invoiceId"],
        status: json["status"],
        totalAmount: json["totalAmount"],
        proofPaymentUrl: json["proofPaymentUrl"],
        orderDate: DateTime.parse(json["orderDate"]),
        expiredDate: DateTime.parse(json["expiredDate"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        paymentMethod: PaymentMethod.fromJson(json["payment_method"]),
        transactionItems: List<TransactionItem>.from(
          json["transaction_items"].map((x) => TransactionItem.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "paymentMethodId": paymentMethodId,
    "invoiceId": invoiceId,
    "status": status,
    "totalAmount": totalAmount,
    "proofPaymentUrl": proofPaymentUrl,
    "orderDate": orderDate.toIso8601String(),
    "expiredDate": expiredDate.toIso8601String(),
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "payment_method": paymentMethod.toJson(),
    "transaction_items": List<dynamic>.from(
      transactionItems.map((x) => x.toJson()),
    ),
  };
}

class PaymentMethod {
  String id;
  String name;
  String virtualAccountNumber;
  String virtualAccountName;
  String imageUrl;
  DateTime createdAt;
  DateTime updatedAt;

  PaymentMethod({
    required this.id,
    required this.name,
    required this.virtualAccountNumber,
    required this.virtualAccountName,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
    id: json["id"],
    name: json["name"],
    virtualAccountNumber: json["virtualAccountNumber"],
    virtualAccountName: json["virtualAccountName"],
    imageUrl: json["imageUrl"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "virtualAccountNumber": virtualAccountNumber,
    "virtualAccountName": virtualAccountName,
    "imageUrl": imageUrl,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}

class TransactionItem {
  String id;
  String transactionId;
  String name;
  String description;
  String imageUrl;
  int price;
  dynamic priceDiscount;
  int quantity;
  DateTime createdAt;
  DateTime updatedAt;

  TransactionItem({
    required this.id,
    required this.transactionId,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.priceDiscount,
    required this.quantity,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> json) =>
      TransactionItem(
        id: json["id"],
        transactionId: json["transactionId"],
        name: json["name"],
        description: json["description"],
        imageUrl: json["imageUrl"],
        price: json["price"],
        priceDiscount: json["priceDiscount"],
        quantity: json["quantity"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "transactionId": transactionId,
    "name": name,
    "description": description,
    "imageUrl": imageUrl,
    "price": price,
    "priceDiscount": priceDiscount,
    "quantity": quantity,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}
