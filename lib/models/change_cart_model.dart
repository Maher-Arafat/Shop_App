//add_cart_model
class ChangeCartModel {
  late bool status;
  late String message;
  late AddToCartData data;

  ChangeCartModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = AddToCartData.fromJson(json['data']);
  }
}

class AddToCartData {
  late int id;
  late int quantity;
  late Product product;
  AddToCartData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    product = Product.fromJson(json['product']);
  }
}

class Product {
  late int id;
  late double price;
  late double oldPrice;
  late int discount;
  late String image;
  late String name;
  late String descrption;

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
