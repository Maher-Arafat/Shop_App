import 'package:newapp/models/home_model.dart';
//get_cart_model
class CartsModel {
  bool? status;
  CartData? data;

  CartsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = CartData.fromJson(json['data']);
  }
}

class CartData {
  List<CartItem>? crtItms = [];
  late int total;
  CartData.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    //subTotl = json['sub_total'];
    json['cart_items'].forEach((elemnet) {
      crtItms!.add(CartItem.fromJson(elemnet));
    });
  }
}

class CartItem {
  int? id;
  int? quantity;
  ProductsModel? product;
  CartItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    product = ProductsModel.fromJson(json['product']);
  }
}
