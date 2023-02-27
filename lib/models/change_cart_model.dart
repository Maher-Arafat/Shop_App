//add_cart_model
class ChangeCartModel {
  bool? status;
  String? message;
  late AddToCartData data;

  ChangeCartModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = AddToCartData.fromJson(json['data']);
  }
}

class AddToCartData {
  int? id;
  int? quantity;
  late Product product;
  AddToCartData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    product = Product.fromJson(json['product']);
  }
}

class Product {
  int? id;
  dynamic price;
  dynamic oldPrice;
  int? discount;
  String? image;
  String? name;
  String? descrption;

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    descrption = json['description'];
  }
}
