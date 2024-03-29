// ignore_for_file: avoid_print

import 'package:newapp/layout/shop_app/cubit/cubit.dart';
import 'package:newapp/network/local/cach_helper.dart';

import '../../modules/shop_app/login/login_screen.dart';
import '../cubit/appcubit/cubit.dart';

void signOut(context) {
  CacheHelper.removeData(
    key: 'token',
  ).then((value) {
    if (value) {
      AppCubit.get(context).navigateFinish(context, ShopLoginScreen());
      ShopCubit.get(context).productsQuantity.clear();
      ShopCubit.get(context).totalCarts = 0;
      ShopCubit.get(context).crntIdx = 0;
    }
  });
}

void printFullText(String text) {
  final pattern = RegExp('.{1.000}');
  pattern.allMatches(text).forEach((element) {
    print(element.group(0));
  });
}
String? token = '';
