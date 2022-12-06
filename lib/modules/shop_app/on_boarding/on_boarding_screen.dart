import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:newapp/modules/shop_app/login/login_screen.dart';
import 'package:newapp/network/local/cach_helper.dart';
import 'package:newapp/shared/components/components.dart';

import '../../../../shared/cubit/appcubit/cubit.dart';

var boardCntrlr = PageController();
bool isLast = false;

class BoardingModel {
  final String image;
  final String title;
  final String body;

  BoardingModel({
    required this.image,
    required this.title,
    required this.body,
  });
}

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  List<BoardingModel> boarding = [
    BoardingModel(
        image: 'assets/images/onboard_1.png',
        title: 'OnBoard 1 Title',
        body: 'OnBoard 1 Body'),
    BoardingModel(
        image: 'assets/images/onboard_1.png',
        title: 'OnBoard 2 Title',
        body: 'OnBoard 2 Body'),
    BoardingModel(
        image: 'assets/images/onboard_1.png',
        title: 'OnBoard 3 Title',
        body: 'OnBoard 3 Body'),
  ];
  void submit() {
    CacheHelper.saveDate(key: 'OnBoarding', value: true).then((value) {
      if (value!) {
        AppCubit.get(context).navigateFinish(context, ShopLoginScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [defaulTextButton(function: submit, text: 'skip')],
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: boardCntrlr,
                  onPageChanged: (idx) {
                    if (idx == boarding.length - 1) {
                      setState(() {
                        isLast = true;
                      });
                    } else {
                      setState(() {
                        isLast = false;
                      });
                    }
                  },
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) =>
                      buildBoardingItem(boarding[index]),
                  itemCount: boarding.length,
                ),
              ),
              const SizedBox(height: 35),
              Row(
                children: [
                  SmoothPageIndicator(
                    controller: boardCntrlr,
                    count: boarding.length,
                    effect: const ExpandingDotsEffect(
                      activeDotColor: Colors.teal,
                      dotColor: Colors.grey,
                      dotHeight: 10,
                      expansionFactor: 3,
                      dotWidth: 10,
                      spacing: 5,
                    ),
                  ),
                  const Spacer(),
                  FloatingActionButton(
                    onPressed: () {
                      if (isLast) {
                        submit();
                      } else {
                        boardCntrlr.nextPage(
                          duration: const Duration(milliseconds: 750),
                          curve: Curves.fastLinearToSlowEaseIn,
                        );
                      }
                    },
                    child: const Icon(Icons.arrow_forward_ios),
                  )
                ],
              )
            ],
          ),
        ));
  }

  Widget buildBoardingItem(BoardingModel model) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image(
              image: AssetImage(model.image),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            model.title,
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            model.body,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
        ],
      );
}
