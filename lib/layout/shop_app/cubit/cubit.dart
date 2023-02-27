// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newapp/layout/shop_app/cubit/states.dart';
import 'package:newapp/models/Product_detail_model.dart';
import 'package:newapp/models/carts_model.dart';
import 'package:newapp/models/categories_model.dart';
import 'package:newapp/models/change_cart_model.dart';
import 'package:newapp/models/change_favorites_model.dart';
import 'package:newapp/models/favorites_model.dart';
import 'package:newapp/models/home_model.dart';
import 'package:newapp/models/login_model.dart';
import 'package:newapp/models/order_model.dart';
import 'package:newapp/models/update_cart_model.dart';
import 'package:newapp/modules/shop_app/categories/categories_screen.dart';
import 'package:newapp/modules/shop_app/favorites/favorites_screen.dart';
import 'package:newapp/modules/shop_app/products/products_screen.dart';
import 'package:newapp/modules/shop_app/settings/settings_screen.dart';
import 'package:newapp/network/remote/dio_helper.dart';
import 'package:newapp/network/remote/end_points.dart';
import 'package:newapp/shared/components/constants.dart';

import '../../../../../models/categorydetail_model.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());
  static ShopCubit get(context) => BlocProvider.of(context);
  int crntIdx = 0;
  List<Widget> bottomScrns = [
    const ProductsScreen(),
    const CategoryScreen(),
    const FavoriteScreen(),
    SettingsScreen(),
  ];
  void changeBottom(int idx) {
    crntIdx = idx;
    emit(ShopChangeBottomNavState());
  }

  Map<int?, bool?> favorities = {};
  Map<int?, bool?> carts = {};
  HomeModel? homeModel;

  void getHomeData() {
    emit(ShopLoadinginHomeState());
    ShDioHelper.getData(
      url: HOME,
      token: token,
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      homeModel!.data!.products!.forEach((element) {
        favorities.addAll({
          element.id: element.inFavs,
        });
      });
      emit(ShopSuccessHomeState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorHomeState());
    });
  }

  CategoriesModel? categoryModel;

  void getCategoriesData() async {
    await ShDioHelper.getData(
      url: GET_CATEGORIES,
      token: token,
    ).then((value) {
      categoryModel = CategoriesModel.fromJson(value.data!);
      //print(value.data);
      emit(ShopSuccessCategoriesState());
    }).catchError((error) {
      //print(error.toString());
      emit(ShopErrorCategoriesState());
    });
  }

  ProductDetailModel? productDetailModel;
  Future<void> getProductDetails({int? id, bool isSearch = true}) async {
    if (isSearch == true) {
      emit(ShopProductDetailLoadingState());
    } else {
      emit(ShopLoadingFromSearchProductDetailsState());
    }
    await ShDioHelper.getData(
      url: 'products/$id',
      token: token,
    ).then((value) {
      productDetailModel = ProductDetailModel.fromJson(value.data!);
      emit(ShopProductDetailSuccessState());
    }).catchError((error) {
      print('Error from product details');
      emit(ShopProductDetailErrorState());
    });
  }

  CategoryDetailModel? categoryDetailModel;
  Future<void> getCategoryDetails(int? id, String? name) async {
    emit(ShopCategoryDetailLoadingState());
    await ShDioHelper.getData(
      url: 'categories/$id',
      token: token,
    ).then((value) {
      categoryDetailModel = CategoryDetailModel.fromJson(value.data!);
      emit(ShopCategoryDetailSuccessState(name ?? "Salla"));
    }).catchError((error) {
      print(error.toString());
      print('Error from category details');
      emit(ShopCategoryDetailErrorState());
    });
  }

  int totalCarts = 0;
  Set cartItms = {};
  var productsQuantity = {};
  Map<int, int> productCartId = {};
  void getCountQuantity() {
    totalCarts = 0;
    if (productsQuantity.isNotEmpty) {
      productsQuantity.forEach((key, value) {
        totalCarts += (value! as int);
      });
    }
  }

  ChangeCartModel? changeCartModel;

  void changeCartItem(int productId) {
    emit(ShopLoadingCartItemState());
    int? productQuantity = productsQuantity[productId];
    bool added = productQuantity == null;
    if (added == true) {
      productsQuantity[productId] = 1;
    } else {
      cartItms.remove(productCartId[productId]);
      productsQuantity.remove(productId);
      productCartId.remove(productId);
    }
    ShDioHelper.postData(
      url: CART,
      data: {
        'product_id': productId,
      },
      token: token,
    ).then((value) {
      changeCartModel = ChangeCartModel.fromJson(value.data);
      emit(ShopChangeSuccessCartItemState(changeCartModel!));
      getcarts();
    }).catchError((error) {
      print('Change Cart Item Error Happend');
      print(error.toString());
      emit(ShopErrorChangeCartItemState());
    });
  }

  CartsModel? cartsModel;
  void getcarts() {
    emit(ShopLoadingCartsState());
    ShDioHelper.getData(
      url: CART,
      token: token,
    ).then((value) {
      cartsModel = CartsModel.fromJson(value.data);
      cartsModel!.data!.crtItms!.forEach((element) {
        productCartId[element.product!.id!] = element.id!;
        productsQuantity[element.product!.id!] = element.quantity;
      });
      cartItms.addAll(productCartId.values);
      emit(ShopChangeSuccessCartsState());
      getCountQuantity();
    }).catchError((error) {
      print('Get Cart Error Happend');
      print(error.toString());
      emit(ShopErrorChangeCartsState());
    });
  }

  UpdateCartModel? ubdateCartModel;
  void changeQuantityItem(int id, {bool icrnmt = true}) {
    emit(ShopLoadingChangeQuantityItemState());
    var cartId = productCartId[id]!;
    int quantity = productsQuantity[id]!;
    if (icrnmt && quantity >= 0) {
      quantity++;
    } else if (!icrnmt && quantity > 1) {
      quantity--;
    } else if (!icrnmt && quantity == 1) {
      quantity--;
      changeCartItem(id);
      return;
    }
    productsQuantity[id] = quantity;
    ShDioHelper.putData(
            url: '$CART/$cartId',
            data: {
              'quantity': quantity,
            },
            token: token)
        .then((value) {
      ubdateCartModel = UpdateCartModel.fromJson(value.data);
      emit(ShopSuccessChangeQuantityItemState(ubdateCartModel!));
      getcarts();
    }).catchError((error) {
      emit(ShopErrorChangeQuantityItemState());
      print(error.toString());
      print('Change Quantity Item Error Happend');
    });
  }

  ChangeFavoriteModel? changeFavoriteModel;

  void changeFavorites(int produtId) {
    favorities[produtId] = !favorities[produtId]!;
    emit(ShopChangeFavoritesState());
    ShDioHelper.postData(
      url: FAVORITES,
      data: {
        'product_id': produtId,
      },
      token: token,
    ).then((value) {
      changeFavoriteModel = ChangeFavoriteModel.fromJson(value.data!);
      if (!changeFavoriteModel!.status!) {
        favorities[produtId] = !favorities[produtId]!;
      } else {
        getFavorites();
      }
      emit(ShopSuccessChangeFavoritesState(changeFavoriteModel!));
    }).catchError((error) {
      favorities[produtId] = !favorities[produtId]!;
      print(error.toString());
      emit(ShopErrorChangeFavoritesState());
    });
  }

  FavoriteModel? favoriteModel;

  void getFavorites() {
    emit(ShopLoadingGetFavoritesState());
    ShDioHelper.getData(
      url: FAVORITES,
      token: token,
    ).then((value) {
      favoriteModel = FavoriteModel.fromJson(value.data!);
      //print(value.data);
      emit(ShopSuccessGetFavoritesState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorGetFavoritesState());
    });
  }

  AddOrderModel? addOrderModel;
  void addOrder() {
    emit(ShopLoadingAddOrderState());
    ShDioHelper.postData(
      url: ORDER,
      token: token,
      data: {
        'address_id': addressId,
        'payment_method': 1,
        'use_points': false,
      },
    ).then((value) {
      addOrderModel = AddOrderModel.fromJson(value.data);
      if (addOrderModel!.status!) {
        getcarts();
        cartItms.clear();
        productsQuantity.clear();
        productCartId.clear();
        getorders();
        emit(ShopSuccessAddOrderState(addOrderModel!));
      } else {
        getcarts();
        getorders();
      }
    }).catchError((error) {
      print('Add New Order Error Happend');
      print(error.toString());
      emit(ShopErrorAddOrderState());
    });
  }

  CancelOrderModel? cancelOrderModel;

  void cancelOrder({required int id}) {
    emit(ShopCancelLoadingOrderState());
    ShDioHelper.getData(
      url: '$ORDER/$id/cancel',
      token: token,
    ).then((value) {
      cancelOrderModel = CancelOrderModel.fromJson(value.data);
      getorders();
      emit(ShopCancelSuccessOrderState(cancelOrderModel!));
    }).catchError((error) {
      print('Cancel Order Error Happend');

      print(error.toString());
      emit(ShopCancelErrorOrderState());
    });
  }

  List<int> ordersId = [];
  OrderDetailsModel? orderItemsDetails;
  List<OrderDetailsModel> orderDetails = [];

  GetOrderModel? orderModel;
  void getorders() {
    emit(ShopLoadingGetOrdersState());
    ShDioHelper.getData(
      url: ORDER,
      token: token,
    ).then((value) {
      orderModel = GetOrderModel.fromJson(value.data);
      orderDetails.clear();
      ordersId.clear();
      orderModel!.data.data.forEach((element) {
        ordersId.add(element.id!);
      });
      emit(ShopSuccessGetOrdersState());
      getOrderDetails();
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorGetOrdersState());
    });
  }

  void getOrderDetails() async {
    emit(ShopLoadingOrderDetailsState());
    if (ordersId.isNotEmpty) {
      for (int i in ordersId) {
        await ShDioHelper.getData(
          url: '$ORDER/$i',
          token: token,
        ).then((orderDetails) {
          orderItemsDetails = OrderDetailsModel.fromJson(orderDetails.data);
          orderDetails.data.add(orderItemsDetails!);
          emit(ShopSuccessOrderDetailsState(orderItemsDetails!));
        }).catchError((error) {
          print(error.toString());
          emit(ShopErrorOrderDetailsState());
        });
      }
    }
  }


  int addressId = 990;
  bool isNewAddress = false;
  bool deleteAddress = false;

  ShopLoginModel? userModel;
  void getUserData() {
    emit(ShopLoadingUserDataState());
    ShDioHelper.getData(
      url: PROFILE,
      token: token,
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data!);
      //print(value.data);
      emit(ShopSuccessUserDataState(userModel!));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorUserDataState());
    });
  }

  void getUpdateUser({
    required String name,
    required String email,
    required String phone,
  }) {
    emit(ShopLoadingUpdateUserState());
    ShDioHelper.putData(
      url: UPDATE_PROFILE,
      token: token,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
      },
    ).then((value) {
      //print(value.data);
      userModel = ShopLoginModel.fromJson(value.data);
      emit(ShopSuccessUpdateUserState(userModel!));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorUpdateUserState());
    });
  }
}
