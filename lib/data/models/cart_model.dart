class CartModel {
  final String id;
  final String foodId;
  final int quantity;
  final Map<String, dynamic>? food;

  CartModel({
    required this.id,
    required this.foodId,
    required this.quantity,
    this.food,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'] as String? ?? json['cartId'] as String? ?? '',
      foodId: json['foodId'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      food: json['food'] is Map<String, dynamic>
          ? json['food'] as Map<String, dynamic>
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'foodId': foodId,
    'quantity': quantity,
    'food': food,
  };
}
