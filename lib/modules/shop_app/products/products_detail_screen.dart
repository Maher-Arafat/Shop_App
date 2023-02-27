import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newapp/layout/shop_app/cubit/cubit.dart';
import 'package:newapp/layout/shop_app/cubit/states.dart';
import 'package:newapp/models/Product_detail_model.dart';
import 'package:newapp/shared/styles/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

int crntIdx = 0;
PageController smothindecadtoCntrlr = PageController();

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ProductDetailModel? model = ShopCubit.get(context).productDetailModel;
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Salla',
              style: TextStyle(fontSize: 20),
            ),
            centerTitle: true,
            actions: [
              if (ShopCubit.get(context).productDetailModel != null)
                IconButton(
                  onPressed: () {
                    ShopCubit.get(context).changeFavorites(model.data!.id!);
                  },
                  icon: CircleAvatar(
                    backgroundColor:
                        ShopCubit.get(context).favorities[model!.data!.id!]!
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
              const SizedBox(width: 7),
            ],
          ),
          body: ConditionalBuilder(
            condition: model != null,
            builder: (context) => buildProductDetail(model!, context),
            fallback: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }

  Widget buildProductDetail(ProductDetailModel model, context) =>
      SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    CarouselSlider(
                      items: model.data!.images!
                          .map((e) => Image(
                              image: NetworkImage(e),
                              fit: BoxFit.contain,
                              width: double.infinity))
                          .toList(),
                      options: CarouselOptions(
                        height: 250,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        viewportFraction: 1.0,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration: const Duration(seconds: 1),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        scrollDirection: Axis.horizontal,
                        onPageChanged: (index, reason) => setState(() {
                          crntIdx = index;
                        }),
                      ),
                    ),
                    if (model.data!.discount != 0)
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
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedSmoothIndicator(
                      activeIndex: crntIdx,
                      count: model.data!.images!.length,
                      effect: WormEffect(
                        radius: 10,
                        spacing: 8,
                        dotHeight: 12,
                        dotWidth: 12,
                        activeDotColor: defaultColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(children: [
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        color: Color.fromARGB(255, 133, 194, 187),
                      ),
                      padding: const EdgeInsets.all(5),
                      width: 70,
                      child: Text(
                        'Name: ',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.copyWith(fontSize: 16),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          '${model.data!.name}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              ?.copyWith(color: defaultColor),
                        ),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          color: Color.fromARGB(255, 133, 194, 187),
                        ),
                        padding: const EdgeInsets.all(5),
                        width: 70,
                        child: Text(
                          'Price: ',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(fontSize: 16),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(5),
                          child: Row(
                            children: [
                              Text(
                                '${model.data!.price}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    ?.copyWith(color: defaultColor),
                              ),
                              if (model.data!.discount != 0)
                                const SizedBox(width: 10),
                              if (model.data!.discount != 0)
                                Text(
                                  '${model.data!.oldPrice}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          color: Color.fromARGB(255, 133, 194, 187),
                        ),
                        padding: const EdgeInsets.all(5),
                        width: 70,
                        child: Text(
                          'Info: ',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(fontSize: 16),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(5),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${model.data!.descrption}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      ?.copyWith(color: defaultColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      );
}
