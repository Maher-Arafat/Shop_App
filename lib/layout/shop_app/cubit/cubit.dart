// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newapp/layout/shop_app/cubit/states.dart';
import 'package:newapp/models/Product_detail_model.dart';
import 'package:newapp/models/categories_model.dart';
import 'package:newapp/models/change_favorites_model.dart';
import 'package:newapp/models/favorites_model.dart';
import 'package:newapp/models/home_model.dart';
import 'package:newapp/models/login_model.dart';
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

  void getCategoriesData() {
    ShDioHelper.getData(
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
  void getProductDetails({int? id, bool isSearch = true}) {
    if (isSearch == true) {
      emit(ShopProductDetailLoadingState());
    } else {
      emit(ShopLoadingFromSearchProductDetailsState());
    }
    ShDioHelper.getData(
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
  getCategoryDetails(int? id, String? name) {
    emit(ShopCategoryDetailLoadingState());
    ShDioHelper.getData(
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
