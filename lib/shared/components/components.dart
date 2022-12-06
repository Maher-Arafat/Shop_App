// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../layout/shop_app/cubit/cubit.dart';

import '../styles/colors.dart';

Widget myDivder() => Container(
      width: double.infinity,
      height: 1.0,
      color: Colors.grey[300],
    );

Widget defultFormField({
  bool isPassword = false,
  required TextEditingController controller,
  required TextInputType type,
  Function(String)? onSubmit,
  Function(String)? onChange,
  Function()? onTap,
  required FormFieldValidator<String> validate,
  required String label,
  required IconData prefix,
  IconData? sufix,
  Function()? sufixPressed,
  bool isClickable = true,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: onTap,
      validator: validate,
      enabled: isClickable,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefix),
        suffixIcon: sufix != null
            ? IconButton(onPressed: sufixPressed, icon: Icon(sufix))
            : null,
        border:  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.teal,
  required Function() function,
  required String text,
  bool isUpperScase = true,
}) =>
    Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: background),
      width: width,
      child: MaterialButton(
        onPressed: () {
          function();
        },
        child: Text(
          isUpperScase ? text.toUpperCase() : text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );

Widget defaulTextButton({
  required Function() function,
  required String text,
}) =>
    TextButton(
      onPressed: function,
      child: Text(text.toUpperCase()),
    );

void ShowToast({required String text, required ToastStates state}) =>
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0,
    );

// ignore: constant_identifier_names
enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastStates state) {
  Color clr;
  switch (state) {
    case ToastStates.SUCCESS:
      clr = Colors.green;
      break;
    case ToastStates.ERROR:
      clr = Colors.red;
      break;
    case ToastStates.WARNING:
      clr = Colors.amber;
      break;
  }
  return clr;
}

Widget buildListProduct(
  model,
  context, {
  bool isOldPrice = true,
}) =>
    Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        height: 120,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Image(
                  //1
                  image: NetworkImage('${model.image!}'),
                  width: 120,
                  height: 120,
                ),
                if (model.discount != 0 && isOldPrice)
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
                    '${model.name}',
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
                        '${model.price.round()}',
                        maxLines: 2,
                        style: TextStyle(fontSize: 14, color: defaultColor),
                      ),
                      const SizedBox(width: 5.0),
                      if (model.discount != 0 && isOldPrice)
                        Text(
                          //4
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
    );
