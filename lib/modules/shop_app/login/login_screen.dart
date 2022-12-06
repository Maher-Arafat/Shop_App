// ignore_for_file: avoid_print

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newapp/layout/shop_app/shop_layout.dart';
import 'package:newapp/modules/shop_app/login/cubit/cubit.dart';
import 'package:newapp/modules/shop_app/login/cubit/states.dart';
import 'package:newapp/modules/shop_app/register/shop_register_screen.dart';
import 'package:newapp/network/local/cach_helper.dart';
import 'package:newapp/shared/components/components.dart';
import 'package:newapp/shared/components/constants.dart';

import '../../../../shared/cubit/appcubit/cubit.dart';

// ignore: must_be_immutable
class ShopLoginScreen extends StatelessWidget {
  var formKy = GlobalKey<FormState>();
  var emailCntrlr = TextEditingController();
  var passowrdCntrlr = TextEditingController();

  ShopLoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
        listener: (context, state) {
          if (state is ShopLoginSuccessState) {
            if (state.loginModel.status!) {
              print(state.loginModel.message);
              print(state.loginModel.data?.token);
              CacheHelper.saveDate(
                key: 'token',
                value: state.loginModel.data?.token,
              ).then((value) {
                token = state.loginModel.data?.token;
                AppCubit.get(context).navigateFinish(context, const ShopLayOut());
              });
            } else {
              print(state.loginModel.message);
              ShowToast(
                text: state.loginModel.message!,
                state: ToastStates.ERROR,
              );
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKy,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOGIN',
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              ?.copyWith(color: Colors.teal),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'Login now to Browse our hot offers',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(color: Colors.grey, fontSize: 16),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        defultFormField(
                          controller: emailCntrlr,
                          type: TextInputType.emailAddress,
                          validate: (String? val) {
                            if (val!.isEmpty) {
                              return 'Please Enter your Email Address';
                            }
                            return null;
                          },
                          label: 'Email Address',
                          prefix: Icons.email_outlined,
                        ),
                        const SizedBox(height: 15),
                        defultFormField(
                          controller: passowrdCntrlr,
                          type: TextInputType.visiblePassword,
                          sufix: ShopLoginCubit.get(context).suffix,
                          sufixPressed: () {
                            ShopLoginCubit.get(context)
                                .changePasswordVisibility();
                          },
                          isPassword: ShopLoginCubit.get(context).isPassword,
                          onSubmit: (p0) {
                            if (formKy.currentState!.validate()) {
                              ShopLoginCubit.get(context).userLogin(
                                email: emailCntrlr.text,
                                password: passowrdCntrlr.text,
                              );
                            }
                          },
                          validate: (String? val) {
                            if (val!.isEmpty) {
                              return 'Password is too short';
                            }
                            return null;
                          },
                          label: 'Password',
                          prefix: Icons.lock_outline,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        ConditionalBuilder(
                          condition: state is! ShopLoginLoadingState,
                          builder: (context) => defaultButton(
                              function: () {
                                if (formKy.currentState!.validate()) {
                                  ShopLoginCubit.get(context).userLogin(
                                    email: emailCntrlr.text,
                                    password: passowrdCntrlr.text,
                                  );
                                }
                              },
                              text: 'login',
                              isUpperScase: true),
                          fallback: (context) =>
                              const Center(child: CircularProgressIndicator()),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Don\'t have an account ?'),
                            defaulTextButton(
                              function: () {
                                AppCubit.get(context)
                                    .navigateTo(context, ShopRegisterScreen());
                              },
                              text: 'register',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
