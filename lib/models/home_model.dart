class HomeModel {
  bool? status;
  HomeDataModel? data;
  HomeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = HomeDataModel.fromJson(json['data']);
  }
}

class HomeDataModel {
  List<BannerModel>? banners = [];
  List<ProductsModel>? products = [];
  HomeDataModel.fromJson(Map<String, dynamic> json) {
    json['banners'].forEach((element) {
      banners!.add(BannerModel.fromJson(element));
    });
    json['products'].forEach((element) {
      products!.add(ProductsModel.fromJson(element));
    });
  }
}

class BannerModel {
  int? id;
  String? image;
  BannerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
  }
}

class ProductsModel {
   int? id;
   dynamic price;
   dynamic oldPrice;
   String? image;
   String? name;
   bool? inFavs;
   bool? inCart;
   dynamic discount;
  ProductsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    image = json['image'];
    name = json['name'];
    inFavs = json['in_favorites'];
    inCart = json['in_cart'];
    discount = json['discount'];
  }
}
