// ignore_for_file: file_names

class ProductDetailModel {
  bool? status;
  Product? data;
  ProductDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = Product.fromJson(json['data']);
  }
}


class Product {
  int? id;
  double? price;
  double? oldPrice;
  int? discount;
  String? image;
  String? name;
  String? descrption;
  bool? inFav;
  bool? inCart;
  List<String>? images;

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    descrption = json['description'];
    inFav = json['in_favorites'];
    inCart = json['in_cart'];
    images = json['images'].cast<String>();
  }
}
