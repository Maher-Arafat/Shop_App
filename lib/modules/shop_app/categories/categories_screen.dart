import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newapp/layout/shop_app/cubit/cubit.dart';
import 'package:newapp/shared/components/components.dart';

import '../../../../layout/shop_app/cubit/states.dart';
import '../../../../models/shop_app/categories_model.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) => {},
      builder: (context, state) {
        return ListView.separated(
          itemBuilder: (context, index) => builCategoryItem(
            ShopCubit.get(context).categoryModel!.data!.data![index],
          ),
          separatorBuilder: (context, idx) => myDivder(),
          itemCount: ShopCubit.get(context).categoryModel!.data!.data!.length,
        );
      },
    );
  }

  Widget builCategoryItem(DataModel model) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Image(
              image: NetworkImage(model.image!),
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 20),
            Text(
              model.name!,
              style:const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios)
          ],
        ),
      );
}
