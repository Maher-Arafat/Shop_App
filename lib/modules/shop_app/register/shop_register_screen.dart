// ignore_for_file: must_be_immutable, avoid_print

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newapp/layout/shop_app/cubit/states.dart';

import 'package:newapp/modules/shop_app/register/cubit/cubit.dart';
import 'package:newapp/modules/shop_app/register/cubit/states.dart';

import '../../../../layout/shop_app/shop_layout.dart';
import '../../../../network/local/cach_helper.dart';
import '../../../../shared/components/components.dart';
import '../../../../shared/components/constants.dart';
import '../../../../shared/cubit/appcubit/cubit.dart';

class ShopRegisterScreen extends StatelessWidget {
  var formKy = GlobalKey<FormState>();
  var emailCntrlr = TextEditingController();
  var phoneCntrlr = TextEditingController();
  var nameCntrlr = TextEditingController();
  var passowrdCntrlr = TextEditingController();

  ShopRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShopRegisterCubit(),
      child: BlocConsumer<ShopRegisterCubit, ShopRegisterStates>(
        listener: (context, state) {
          if (state is ShopRegisterSuccessState) {
            if (state.loginModel.status!) {
              print(state.loginModel.message);
              print(state.loginModel.data?.token);
              CacheHelper.saveDate(
                key: 'token',
                value: state.loginModel.data?.token,
              ).then((value) {
                token = state.loginModel.data?.token;
                AppCubit.get(context)
                    .navigateFinish(context, const ShopLayOut());
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
                        if (state is! ShopLoadingUpdateUserState)
                          const LinearProgressIndicator(),
                        const SizedBox(height: 15),
                        /*Text(
                          'REGISTER',
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              ?.copyWith(color: Colors.teal),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'Register now to Browse our hot offers',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(color: Colors.grey, fontSize: 16),
                        ),*/
                        const SizedBox(height: 30),
                        defultFormField(
                          controller: nameCntrlr,
                          type: TextInputType.name,
                          validate: (String? val) {
                            if (val!.isEmpty) {
                              return 'Please Enter your Name';
                            }
                            return null;
                          },
                          label: 'Name',
                          prefix: Icons.person,
                        ),
                        const SizedBox(height: 30),
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
                          sufix: ShopRegisterCubit.get(context).suffix,
                          sufixPressed: () {
                            ShopRegisterCubit.get(context)
                                .changePasswordVisibility();
                          },
                          isPassword: ShopRegisterCubit.get(context).isPassword,

                          /*onSubmit: (p0) {
                            if (formKy.currentState!.validate()) {
                              ShopRegisterCubit.get(context).userRegister(
                                email: emailCntrlr.text,
                                name: nameCntrlr.text,
                                phone: phoneCntrlr.text,
                                password: passowrdCntrlr.text,
                              );
                            }
                          },
                          */
                          validate: (String? val) {
                            if (val!.isEmpty) {
                              return 'Password is too short';
                            }
                            return null;
                          },
                          label: 'Password',
                          prefix: Icons.lock_outline,
                        ),
                        const SizedBox(height: 30),
                        defultFormField(
                          controller: phoneCntrlr,
                          type: TextInputType.phone,
                          validate: (String? val) {
                            if (val!.isEmpty) {
                              return 'Please Enter your Email Address';
                            }
                            return null;
                          },
                          label: 'Phone Number',
                          prefix: Icons.phone,
                        ),
                        const SizedBox(height: 15),
                        ConditionalBuilder(
                          condition: state is! ShopRegisterLoadingState,
                          builder: (context) => defaultButton(
                              function: () {
                                if (formKy.currentState!.validate()) {
                                  ShopRegisterCubit.get(context).userRegister(
                                    email: emailCntrlr.text,
                                    name: nameCntrlr.text,
                                    phone: phoneCntrlr.text,
                                    password: passowrdCntrlr.text,
                                  );
                                }
                              },
                              text: 'login',
                              isUpperScase: true),
                          fallback: (context) =>
                              const Center(child: CircularProgressIndicator()),
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
