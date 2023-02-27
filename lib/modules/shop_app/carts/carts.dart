import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:newapp/layout/shop_app/cubit/cubit.dart';
import 'package:newapp/layout/shop_app/cubit/states.dart';
import 'package:newapp/models/carts_model.dart';
import 'package:newapp/modules/shop_app/products/products_detail_screen.dart';
import 'package:newapp/shared/components/components.dart';
import 'package:newapp/shared/cubit/appcubit/cubit.dart';

import '../../../shared/styles/colors.dart';
import '../my_orders/my_order_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopChangeSuccessCartItemState) {
          ShowToast(text: state.model.message!, state: ToastStates.SUCCESS);
        }
        if (state is ShopSuccessChangeQuantityItemState) {
          ShowToast(text: state.model.message!, state: ToastStates.SUCCESS);
        }
        if (state is ShopSuccessAddOrderState) {
          if (state.model.status!) {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.success,
              animType: AnimType.scale,
              btnCancelText: "Home",
              btnOkText: "Orders",
              title: 'Your Order in progress',
              desc:
                  "Your order was placed successfully.\n For more details check Delivery Status in settings.",
              btnOkOnPress: () {
                Navigator.pop(context);
                ShopCubit.get(context).changeBottom(3);
                AppCubit.get(context)
                    .navigateTo(context, const MyOrdersScreen());
              },
              btnCancelOnPress: () {
                Navigator.pop(context);
              },
              btnCancelColor: defaultColor,
              btnOkIcon: Icons.list_alt_outlined,
              btnCancelIcon: Icons.home,
              width: 400,
            ).show();
          }
        }
        if (state is ShopErrorAddOrderState) {
          ShowToast(text: 'Error happend', state: ToastStates.ERROR);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text('Cart'),
            centerTitle: true,
          ),
          body: ConditionalBuilder(
            condition: ShopCubit.get(context).totalCarts > 0,
            builder: (context) => Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => buildCartItem(
                              ShopCubit.get(context)
                                  .cartsModel!
                                  .data!
                                  .crtItms![index],
                              ShopCubit.get(context).cartsModel!.data!.total,
                              context),
                          itemCount: ShopCubit.get(context)
                              .cartsModel!
                              .data!
                              .crtItms!
                              .length,
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
                if (ShopCubit.get(context).totalCarts > 0)
                  Align(
                    alignment: const Alignment(0, 1),
                    child: Container(
                      width: double.infinity,
                      height: 70,
                      decoration: BoxDecoration(
                        border: Border.all(color: defaultColor),
                      ),
                      child: ConditionalBuilder(
                        condition: ShopCubit.get(context).addressId != 0,
                        builder: (context) => Container(
                          padding: const EdgeInsets.all(10),
                          child: state is! ShopLoadingAddOrderState
                              ? defaultButton(
                                  function: () {
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.success,
                                      animType: AnimType.scale,
                                      title: 'Are you sure for this Order ?',
                                      btnOkOnPress: () =>
                                          ShopCubit.get(context).addOrder(),
                                      btnCancelText: 'Cancel',
                                    ).show();
                                  },
                                  text:
                                      'Check out( ${NumberFormat.currency(decimalDigits: 0, symbol: "").format(ShopCubit.get(context).cartsModel!.data!.total)} \$ )')
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                        ),
                        fallback: (context) => Container(
                          padding: const EdgeInsets.all(10),
                          child: defaultButton(
                            function: () {},
                            text: 'Add Your Address Please',
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            fallback: (context) => buildEmptyCart(context),
          ),
        );
      },
    );
  }
}

Widget buildCartItem(CartItem? model, total, context) {
  var cubit = ShopCubit.get(context);
  return InkWell(
    onTap: () {
      cubit.getProductDetails(id: model.id);
    },
    child: Card(
      color: defaultColor.withOpacity(0.1),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Container(
                    width: 150,
                    height: 140,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Image(
                      image: NetworkImage(model!.product!.image!),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.product!.name!,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Row(
                            textBaseline: TextBaseline.alphabetic,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                NumberFormat.currency(
                                        decimalDigits: 0, symbol: "")
                                    .format(model.product!.price! *
                                        (ShopCubit.get(context)
                                                .productsQuantity[
                                            model.product!.id!])),
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const Text(
                                " \$",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          if (model.product!.discount! > 0)
                            Text(
                              '${NumberFormat.currency(decimalDigits: 0, symbol: "").format(model.product!.oldPrice)} \$',
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            //myDivder(),
            Row(
              children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                    InkWell(
                      onTap: () => ShopCubit.get(context)
                          .changeQuantityItem(model.product!.id!),
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            color: defaultColor,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: defaultColor,
                                blurRadius: 1,
                                offset: const Offset(1, 1),
                              ),
                            ]),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      '${ShopCubit.get(context).productsQuantity[model.product!.id!] != null ? ShopCubit.get(context).productsQuantity[model.product!.id!] : model.quantity}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 20),
                    InkWell(
                      onTap: () {
                        if (ShopCubit.get(context)
                                .productsQuantity[model.product!.id!]! >
                            1) {
                          ShopCubit.get(context).changeQuantityItem(
                            model.product!.id!,
                            icrnmt: false,
                          );
                        }
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            color: ShopCubit.get(context).productsQuantity[
                                            model.product!.id] ==
                                        1 ||
                                    ShopCubit.get(context).productsQuantity[
                                            model.product!.id] ==
                                        null
                                ? Colors.red.withOpacity(0.4)
                                : defaultColor,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: defaultColor,
                                blurRadius: 2,
                                offset: const Offset(1, 1),
                              ),
                            ]),
                        child: const Icon(
                          Icons.remove,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
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
                IconButton(
                  onPressed: () {
                    ShopCubit.get(context).changeCartItem(model.product!.id!);
                  },
                  icon: const CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 15,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 5)
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildEmptyCart(context) {
  return Container(
    color: Colors.white,
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Text(
            'Shopping Cart is empty !',
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: defaultColor, fontSize: 14),
          ),
        ],
      ),
    ),
  );
}
