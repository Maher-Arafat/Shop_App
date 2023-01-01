// ignore_for_file: public_member_api_docs, sort_constructors_first


import '../../../../models/login_model.dart';

abstract class ShopRegisterStates {}

class ShopRegisterIntialState extends ShopRegisterStates {}

class ShopRegisterLoadingState extends ShopRegisterStates {}

class ShopRegisterSuccessState extends ShopRegisterStates {
  final ShopLoginModel loginModel;
  ShopRegisterSuccessState(this.loginModel);
}

class ShopRegisterErrorState extends ShopRegisterStates {
  final String error;
  ShopRegisterErrorState(this.error);
}

class ShopChangeRegPasswordState extends ShopRegisterStates {}
