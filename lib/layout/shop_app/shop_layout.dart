import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newapp/layout/shop_app/cubit/states.dart';
import 'package:newapp/modules/shop_app/search/search_screen.dart';

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
              IconButton(
                onPressed: () {
                  AppCubit.get(context).navigateTo(context, const ShopSearchScreen());
                },
                icon: const Icon(Icons.search),
              ),
            ],
          ),
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
