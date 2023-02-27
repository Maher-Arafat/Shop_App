import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newapp/modules/shop_app/category_details/category_details.dart';
import 'package:newapp/shared/components/components.dart';
import 'package:newapp/shared/cubit/appcubit/cubit.dart';

import '../../../../layout/shop_app/cubit/states.dart';
import '../../../models/categories_model.dart';
import '../../../layout/shop_app/cubit/cubit.dart';
import '../products/products_detail_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state)  {
        if(state is ShopCategoryDetailLoadingState)
        {AppCubit.get(context).navigateTo(context, CategoryDetailScreen());}
        if (state is ShopProductDetailLoadingState) {
          AppCubit.get(context).navigateTo(context,const ProductDetailScreen());
        }
      },
      builder: (context, state) {
        return ListView.separated(
          itemBuilder: (context, index) => builCategoryItem(
            ShopCubit.get(context).categoryModel!.data.data[index],context,
          ),
          separatorBuilder: (context, idx) => myDivder(),
          itemCount: ShopCubit.get(context).categoryModel!.data.data.length,
        );
      },
    );
  }

  Widget builCategoryItem(DataModel model,context) => InkWell(
    onTap: () => ShopCubit.get(context).getCategoryDetails(model.id, model.name),
    child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Image(
                image: NetworkImage(model.image),
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 20),
              Text(
                model.name,
                style:const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios)
            ],
          ),
        ),
  );
}
