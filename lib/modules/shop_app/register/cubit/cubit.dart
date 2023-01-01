// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:newapp/modules/shop_app/register/cubit/states.dart';
import 'package:newapp/network/remote/dio_helper.dart';
import 'package:newapp/network/remote/end_points.dart';

import '../../../../models/login_model.dart';

class ShopRegisterCubit extends Cubit<ShopRegisterStates> {
  ShopRegisterCubit() : super(ShopRegisterIntialState());

  static ShopRegisterCubit get(context) => BlocProvider.of(context);

  ShopLoginModel? loginModel;

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;
  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ShopChangeRegPasswordState());
  }

  void userRegister({
    required String email,
    required String name,
    required String phone,
    required String password,
  }) {
    emit(ShopRegisterLoadingState());
    ShDioHelper.postData(
      url: REGISTER,
      data: {
        'email': email,
        'name': name,
        'phone': phone,
        'password': password,
      },
    ).then((value) {
      loginModel = ShopLoginModel.fromJson(value.data);
      print(value.data);
      emit(ShopRegisterSuccessState(loginModel!));
    }).catchError((error) {
      print(error.toString());
      emit(ShopRegisterErrorState(error.toString()));
    });
  }
}
