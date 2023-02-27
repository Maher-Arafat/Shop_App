import 'package:newapp/models/change_cart_model.dart';

class UpdateCartModel {
  bool? status;
  String? message;
  UpdateCart? data;
  UpdateCartModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = UpdateCart.fromJson(json['data']);
  }
}

class UpdateCart {
  late double total;
  UpdateCartData? cart;
  UpdateCart.fromJson(Map<String, dynamic> json) {
    cart = UpdateCartData.fromJson(json['cart']);
    total = json['total'];
  }
}

class UpdateCartData {
  int? id;
  int? quantity;
  Product? product;
  UpdateCartData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = int.parse(json['quantity']);
    product = Product.fromJson(json['product']);
  }
}
