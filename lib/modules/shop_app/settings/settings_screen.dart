// ignore_for_file: must_be_immutable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newapp/layout/shop_app/cubit/cubit.dart';
import 'package:newapp/layout/shop_app/cubit/states.dart';
import 'package:newapp/shared/components/components.dart';
import 'package:newapp/shared/components/constants.dart';

class SettingsScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var nameCntrlr = TextEditingController();
  var emailCntrlr = TextEditingController();
  var phoneCntrlr = TextEditingController();

  SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var model = ShopCubit.get(context).userModel!;
          nameCntrlr.text = model.data!.name!;
          emailCntrlr.text = model.data!.email!;
          phoneCntrlr.text = model.data!.phone!;
          return ConditionalBuilder(
            condition: ShopCubit.get(context).userModel != null,
            builder: (context) => SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage('assets/images/login.jpg'),
                        radius: 70,
                      ),
                      const SizedBox(height: 15),
                      if (state is ShopLoadingUpdateUserState)
                        const LinearProgressIndicator(),
                      const SizedBox(height: 15),
                      Column(
                        children: [
                          defultFormField(
                            controller: nameCntrlr,
                            type: TextInputType.name,
                            validate: (String? value) {
                              if (value!.isEmpty)
                                return 'Name must not be Empty';
                              return null;
                            },
                            label: 'Name',
                            prefix: Icons.person,
                          ),
                          const SizedBox(height: 15),
                          defultFormField(
                            controller: emailCntrlr,
                            type: TextInputType.emailAddress,
                            validate: (String? value) {
                              if (value!.isEmpty)
                                return 'Email must not be Empty';
                              return null;
                            },
                            label: 'example@gmail.com',
                            prefix: Icons.email,
                          ),
                          const SizedBox(height: 15),
                          defultFormField(
                            controller: phoneCntrlr,
                            type: TextInputType.phone,
                            validate: (String? value) {
                              if (value!.isEmpty)
                                return 'Phone must not be Empty';
                              return null;
                            },
                            label: 'Phone',
                            prefix: Icons.phone,
                          ),
                          const SizedBox(height: 15),
                          defaultButton(
                              function: () {
                                if (formKey.currentState!.validate()) {
                                  ShopCubit.get(context).getUpdateUser(
                                    name: nameCntrlr.text,
                                    email: emailCntrlr.text,
                                    phone: phoneCntrlr.text,
                                  );
                                }
                              },
                              text: 'Update'),
                          const SizedBox(height: 15),
                          defaultButton(
                              function: () {
                                signOut(context);
                              },
                              text: 'Logout'),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            fallback: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
