// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newapp/layout/shop_app/cubit/cubit.dart';
import 'package:newapp/layout/shop_app/shop_layout.dart';
import 'package:newapp/modules/shop_app/login/login_screen.dart';

import 'package:newapp/modules/shop_app/on_boarding/on_boarding_screen.dart';
import 'package:newapp/network/local/cach_helper.dart';
import 'package:newapp/network/remote/dio_helper.dart';
import 'package:newapp/shared/components/constants.dart';
import 'package:newapp/shared/cubit/appcubit/cubit.dart';
import 'package:newapp/shared/cubit/appcubit/states.dart';
import 'package:newapp/shared/bloc_oserver.dart';
import 'package:newapp/shared/styles/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();
  ShDioHelper.init();
  await CacheHelper.init();

  bool? isDark = CacheHelper.getBool(key: 'isDark');

  bool? Onboarding = CacheHelper.getData(key: 'OnBoarding');
  token = CacheHelper.getData(key: 'token');
  print(token);
  Widget widget;

  if (Onboarding != null) {
    if (token != null) {
      widget = const ShopLayOut();
    } else {
      widget = ShopLoginScreen();
    }
  } else {
    widget = const OnBoardingScreen();
  }

  runApp(MyApp(
    isDark: isDark,
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final bool? isDark;
  final Widget? startWidget;

  const MyApp({super.key, required this.isDark, required this.startWidget});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              AppCubit(),//..changeModeState(darkfromShared: isDark),
        ),
        BlocProvider(
          create: (context) => ShopCubit()
            ..getHomeData()
            ..getCategoriesData()
            ..getFavorites()
            ..getUserData(),
        ),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode:
                AppCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
            home: Directionality(
              textDirection: TextDirection.ltr,
              child: startWidget!,
            ),
          );
        },
      ),
    );
  }
}
