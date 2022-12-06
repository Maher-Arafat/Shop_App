// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newapp/network/local/cach_helper.dart';
import 'package:newapp/shared/cubit/appcubit/states.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppIntialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int crntIdx = 0;
  List<Map> newTsks = [];
  List<Map> doneTsks = [];
  List<Map> archivedTsks = [];

  /*List<Widget> scrns = [
    const NewTasksScreen(),
    const DoneTasksScreen(),
    const ArchivedTasksScreen(),
  ];
 */
  List<String> title = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  bool isDark = false;
  void changeModeState({bool? darkfromShared}) {
    if (darkfromShared != null) {
      isDark = darkfromShared;
      print(isDark.toString());
      emit(AppChangeModeState());
    } else {
      isDark = !isDark;
      print(isDark.toString());
      CacheHelper.putBool(key: 'isDark', value: isDark).then(
        (value) => emit(AppChangeModeState()),
      );
    }
  }

  late Database db;

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changIdx(int idx) {
    crntIdx = idx;
    emit(AppChangeBottomNavBarStates());
  }

  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  void createDb() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: ((db, version) {
        print('DB Created');
        db
            .execute(
                'CREATE TABLE tsks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('Table Created');
        }).catchError((error) {
          print('Error When Creating${error.toString()}');
        });
      }),
      onOpen: (db) {
        getDataFromDb(db);
        print('DB Opened');
      },
    ).then((value) {
      db = value;
      emit(AppcreateDBState());
    });
  }

  insrtDb({
    required String title,
    required String time,
    required String date,
  }) async {
    await db.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tsks(title, date, time, status) VALUES("$title","$date","$time","new")')
          .then((value) {
        print('$value Inserted Successfully');
        emit(AppInsertDBState());

        getDataFromDb(db);
      }).catchError((error) {
        print('Error When Inserting New Record${error.toString()}');
      });
    });
  }

  void getDataFromDb(db) {
    newTsks = [];
    doneTsks = [];
    archivedTsks = [];
    emit(AppGetDBLoadingState());
    db.rawQuery('SELECT * FROM tsks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTsks.add(element);
        } else if (element['status'] == 'done') {
          doneTsks.add(element);
        } else {
          archivedTsks.add(element);
        }
      });
      emit(AppGetDBState());
    });
  }

  void updateDb({
    required String status,
    required int id,
  }) async {
    db.rawUpdate(
      'UPDATE tsks SET status = ? WHERE id = ?',
      [status, id],
    ).then((value) {
      getDataFromDb(db);
      emit(AppUpdateDBState());
    });
  }

  void deleteDb({required int id}) async {
    db.rawDelete('DELETE FROM tsks WHERE id = ?', [id]).then((value) {
      getDataFromDb(db);
      emit(AppDeleteDBState());
    });
  }

void navigateTo(context, widget) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => widget,
        ),
      );

  
void navigateFinish(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (route) => false);


}
