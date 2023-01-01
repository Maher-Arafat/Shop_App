// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newapp/modules/shop_app/search/cubit/state.dart';
import 'package:newapp/network/remote/dio_helper.dart';
import 'package:newapp/network/remote/end_points.dart';

import '../../../../../shared/components/constants.dart';
import '../../../../models/search_model.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchIntialState());

  static SearchCubit get(context) => BlocProvider.of(context);

  SearchModel? model;

  void Search(String text) {
    emit(SearchLoadingState());
    ShDioHelper.postData(
      url: SEARCH,
      data: {'text': text},
      token: token,
    ).then((value) {
      model = SearchModel.fromJson(value.data);
      print(value.data);
      emit(SearchSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SearchErrorState());
    });
  }
}
