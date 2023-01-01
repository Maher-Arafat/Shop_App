import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../layout/shop_app/cubit/states.dart';
import '../../../../shared/components/components.dart';
import '../../../layout/shop_app/cubit/cubit.dart';
import '../../../models/favorites_model.dart';
import '../../../shared/styles/colors.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        //ShopCubit.get(context).favoriteModel?.data?.total!=0?
        return ConditionalBuilder(
          condition: (state is! ShopLoadingGetFavoritesState),
          builder: (context) => ListView.separated(
            itemBuilder: (context, index) => buildFavItem(
              ShopCubit.get(context).favoriteModel!.data!.data![index],
              context,
            ),
            separatorBuilder: (context, index) => myDivder(),
            itemCount: ShopCubit.get(context).favoriteModel!.data!.data!.length,
          ),
          fallback: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

Widget buildFavItem(
  FavoritesData model,
  context, {
  bool isOldPrice = true,
}) =>
    Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        height: 120,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Image(
                  //1
                  image: NetworkImage('${model.product!.image!}'),
                  width: 120,
                  height: 120,
                ),
                if (model.product!.discount! != 0 && isOldPrice)
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
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    //2
                    '${model.product!.name!}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.3,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        //3
                        '${model.product!.price!.round()}',
                        maxLines: 2,
                        style: TextStyle(fontSize: 14, color: defaultColor),
                      ),
                      const SizedBox(width: 5.0),
                      if (model.product!.discount! != 0)
                        Text(
                          //4
                          '${model.product!.oldPrice!.round()}',
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
                          ShopCubit.get(context).changeFavorites(model.product!.id!);
                        },
                        icon: CircleAvatar(
                          backgroundColor:
                              ShopCubit.get(context).favorities[model.product!.id]!
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
    );
