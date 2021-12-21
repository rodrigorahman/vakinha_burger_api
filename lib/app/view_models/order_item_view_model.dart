import 'dart:convert';

class OrderItemViewModel {
  int quantity;
  int productId;
  OrderItemViewModel({
    required this.quantity,
    required this.productId,
  });

  Map<String, dynamic> toMap() {
    return {
      'quantity': quantity,
      'productId': productId,
    };
  }

  factory OrderItemViewModel.fromMap(Map<String, dynamic> map) {
    return OrderItemViewModel(
      quantity: map['quantity']?.toInt() ?? 0,
      productId: map['productId']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderItemViewModel.fromJson(String source) =>
      OrderItemViewModel.fromMap(json.decode(source));
}
