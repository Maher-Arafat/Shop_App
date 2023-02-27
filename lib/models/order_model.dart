class AddOrderModel {
  bool? status;
  String? message;
  AddOrderModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }
}

class CancelOrderModel {
  bool? status;
  String? message;
  CancelOrderModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }
}

class GetOrderModel {
  bool? status;
  late GetOrdersData data;
  GetOrderModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = GetOrdersData.fromJson(json['data']);
  }
}

class GetOrdersData {
  int? totalOrders;
  List<GetOrderData> data = [];
  GetOrdersData.fromJson(Map<String, dynamic> json) {
    totalOrders = json['total'];
    data =
        List.from(json['data']).map((e) => GetOrderData.fromJson(e)).toList();
    data.sort((a, b) => b.status!.compareTo(a.status!));
  }
}

class GetOrderData {
  int? id;
  dynamic total;
  String? date;
  String? status;
  GetOrderData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    total = json['total'];
    date = json['date'];
    status = json['status'];
  }
}

class OrderDetailsModel {
  bool? status;
  late OrderDetailsData data;
  OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = OrderDetailsData.fromJson(json['data']);
  }
}

class OrderDetailsData {
  int? id;
  double? cost;
  double? vat;
  double? total;
  String? date;
  String? status;
  String? paymentMethod;
  OrderDetailsData.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    cost = json["cost"];
    vat = json["vat"];
    total = json["total"];
    paymentMethod = json["payment_method"];
    date = json["date"];
    status = json["status"];
  }
}
