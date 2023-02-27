class CategoryDetailModel {
  late bool status;
  late String message;
  late Data data;

  CategoryDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'] ?? '';
    data = (json['data'] != null ? Data.fromJson(json['data']) : null)!;
  }
}

class Data {
  late int currentPage;
  late List<Product> data=[];
  late String firstPageUrl;
  late int from;
  late int lastPage;
  late String lastPageUrl;
  late String nextPageUrl;
  late String path;
  late int perPage;
  late String prevPageUrl;
  late int to;
  late double total;

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data.add(Product.fromJson(v));
      });
    }

    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
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
  late bool inFav;
  late bool inCart;
  late List<String> images;

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
