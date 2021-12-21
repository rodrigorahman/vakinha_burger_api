
import 'dart:convert';

import 'order_item_view_model.dart';

class OrderViewModel {
  
  int userId;
  String? cpf;
  String address;
  List<OrderItemViewModel> items;
  
  OrderViewModel({
    required this.userId,
    this.cpf,
    required this.address,
    required this.items,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'cpf': cpf,
      'address': address,
      'items': items.map((x) => x.toMap()).toList(),
    };
  }

  factory OrderViewModel.fromMap(Map<String, dynamic> map) {
    return OrderViewModel(
      userId: map['userId']?.toInt() ?? 0,
      cpf: map['cpf'],
      address: map['address'] ?? '',
      items: List<OrderItemViewModel>.from(map['items']?.map((x) => OrderItemViewModel.fromMap(x)) ?? const []),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderViewModel.fromJson(String source) => OrderViewModel.fromMap(json.decode(source));
}
