import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newapp/layout/shop_app/cubit/states.dart';
import 'package:newapp/modules/shop_app/carts/carts.dart';
import 'package:newapp/modules/shop_app/search/search_screen.dart';
import 'package:newapp/shared/styles/colors.dart';

import 'cubit/cubit.dart';
import '../../shared/cubit/appcubit/cubit.dart';

class ShopLayOut extends StatelessWidget {
  const ShopLayOut({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ShopCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Salla'),
            actions: [
              if (cubit.crntIdx != 3)
                IconButton(
                  onPressed: () {
                    AppCubit.get(context)
                        .navigateTo(context, const ShopSearchScreen());
                  },
                  icon: const Icon(Icons.search),
                ),
            ],
          ),
          floatingActionButton: cubit.cartsModel != null &&
                  cubit.cartsModel!.data!.crtItms!.length >=0 &&
                  cubit.crntIdx != 3
              ? FloatingActionButton(
                  backgroundColor: defaultColor,
                  foregroundColor: Colors.white,
                  onPressed: () {
                    AppCubit.get(context)
                        .navigateTo(context, const CartScreen());
                  },
                  child: const Icon(Icons.shopping_cart_outlined),
                )
              : null,
          body: cubit.bottomScrns[cubit.crntIdx],
          bottomNavigationBar: BottomNavigationBar(
              onTap: (idx) => cubit.changeBottom(idx),
              currentIndex: cubit.crntIdx,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.apps), label: 'Categories'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.favorite), label: 'Favorities'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings), label: 'Settings'),
              ]),
        );
      },
    );
  }
}
