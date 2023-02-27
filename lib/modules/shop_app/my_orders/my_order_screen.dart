import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:newapp/layout/shop_app/cubit/cubit.dart';
import 'package:newapp/layout/shop_app/cubit/states.dart';
import 'package:newapp/models/order_model.dart';
import 'package:newapp/shared/components/components.dart';
import 'package:newapp/shared/styles/colors.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopCancelSuccessOrderState) {
          if (state.cancelOrderModel.status!) {
            AwesomeDialog(
                    context: context,
                    dialogType: DialogType.success,
                    animType: AnimType.scale,
                    title: 'Order has been Cancelled.',
                    btnOkOnPress: () {},
                    desc: 'Order Cancelled Successfully!')
                .show();
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              'Orders',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: defaultColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Text(
                          '${ShopCubit.get(context).orderDetails.length}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Items',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: ConditionalBuilder(
              condition:
                  ShopCubit.get(context).orderModel!.data.data.length > 0,
              builder: (context) => ConditionalBuilder(
                  condition: ShopCubit.get(context).orderDetails.isNotEmpty &&
                      state is! ShopCancelLoadingOrderState,
                  builder: (context) => SingleChildScrollView(
                          child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Expanded(
                            child: ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) => buildOrderItem(
                                    ShopCubit.get(context)
                                        .orderDetails[index]
                                        .data,
                                    context,
                                    state),
                                separatorBuilder: (context, index) =>
                                    myDivder(),
                                itemCount:
                                    ShopCubit.get(context).orderDetails.length),
                          ),
                        ],
                      )),
                  fallback: (context) => const Center(
                        child: CircularProgressIndicator(),
                      )),
              fallback: (context) => buildNoOrders(context)),
        );
      },
    );
  }

  Widget buildOrderItem(OrderDetailsData model, context, state) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Order Id: ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${model.id}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    Text(
                      model.date!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Cost: ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${NumberFormat.currency(decimalDigits: 0, symbol: "").format(model.cost)} \$",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Vat: ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${NumberFormat.currency(decimalDigits: 0, symbol: "").format(model.vat)} \$",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Text(
                      'Total Amount: ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${NumberFormat.currency(decimalDigits: 0, symbol: "").format(model.total)} \$",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      model.status!,
                      style: TextStyle(
                        color:
                            (model.status == 'New') ? defaultColor : Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (model.status == "New")
                      defaultButton(
                        text: "Cancel",
                        function: () {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.question,
                            animType: AnimType.scale,
                            title: 'Are you Sure for Cancel Order ?',
                            btnOkOnPress: () {
                              ShopCubit.get(context).cancelOrder(id: model.id!);
                            },
                            btnCancelOnPress: () {},
                          ).show();
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  Widget buildNoOrders(context) => Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: defaultColor,
              radius: 50,
              child: const Icon(
                Icons.list_alt_outlined,
                size: 60,
                color: Color.fromARGB(255, 133, 128, 128),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'You have no orders in progress!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'All your orders will be here to access their anytime',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: defaultButton(
                  text: "Start Shopping",
                  function: () {
                    ShopCubit.get(context).changeBottom(0);
                    Navigator.pop(context);
                  }),
            ),
          ],
        ),
      );
}
