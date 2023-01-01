// ignore_for_file: must_be_immutable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:newapp/layout/shop_app/cubit/states.dart';
import 'package:newapp/models/categorydetail_model.dart';

import '../../layout/shop_app/cubit/cubit.dart';
import '../../shared/styles/colors.dart';

class CategoryDetailScreen extends StatelessWidget {
  String? name;

  CategoryDetailScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopCategoryDetailSuccessState) name = state.name;
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            titleSpacing: 0.0,
            title: Text(name ?? "Salla"),
          ),
          body: ConditionalBuilder(
            condition: ShopCubit.get(context).categoryDetailModel != null,
            builder: (context) => SingleChildScrollView(
              physics:const BouncingScrollPhysics(),
              child: Container(
                  child: ShopCubit.get(context)
                          .categoryDetailModel!
                          .data!
                          .data!
                          .isNotEmpty
                      ? buildCatDetail(
                          ShopCubit.get(context).categoryDetailModel, context)
                      : buildErrorCatDetail(context)),
            ),
            fallback: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }

  Widget buildErrorCatDetail(context) => Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40.0,
                backgroundColor: defaultColor,
                child:const Icon(
                  Icons.face_unlock_rounded,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                'Unfortunately, ${name!} is empty now !',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(color: defaultColor),
              ),
            ],
          ),
        ),
      );

  Widget buildCatDetail(CategoryDetailModel? catDModel, context) => Container(
        child: GridView.count(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          mainAxisSpacing: 1,
          crossAxisSpacing: 1,
          childAspectRatio: 1 / 1.71,
          crossAxisCount: 2,
          children: List.generate(
            catDModel!.data!.data!.length,
            (index) => buildGridProduct(catDModel.data!.data![index], context),
          ),
        ),
      );

  Widget buildGridProduct(Product? model, context) => InkWell(
        onTap: () {
          ShopCubit.get(context).getProductDetails(id: model.id);
        },
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: AlignmentDirectional.bottomStart,
                  children: [
                    Image(
                      image: NetworkImage(model!.image!),
                      width: double.infinity,
                      height: 200,
                    ),
                    if (model.discount != 0)
                      Container(
                        padding: const EdgeInsets.all(5),
                        color: Colors.red,
                        child: const Text(
                          'DISCOUNT',
                          style: TextStyle(
                            fontSize: 8,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${model.name}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.3,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '${model.price.round()}',
                            maxLines: 2,
                            style: TextStyle(fontSize: 14, color: defaultColor),
                          ),
                          const SizedBox(width: 5.0),
                          if (model.discount != 0)
                            Text(
                              '${model.oldPrice.round()}',
                              maxLines: 2,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              ShopCubit.get(context).changeFavorites(model.id!);
                              ShopCubit.get(context).getFavorites();
                            },
                            icon: CircleAvatar(
                              backgroundColor:
                                  ShopCubit.get(context).favorities[model.id]!
                                      ? defaultColor
                                      : Colors.grey,
                              radius: 15,
                              child: const Icon(
                                Icons.favorite_border,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
}
