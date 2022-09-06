import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/modules/science/science_screen.dart';
import 'package:news_app/modules/settings/settings.dart';
import 'package:news_app/modules/sports/sports_screen.dart';
import 'package:news_app/shared/cubit/states.dart';
import 'package:news_app/shared/network/local/cache_helper.dart';

import '../../modules/business/business_screen.dart';
import '../network/remote/dio_helper.dart';

class NewsCubit extends Cubit<NewsStates>{
  NewsCubit() : super(NewsInitialState());

  static NewsCubit get(context) => BlocProvider.of(context);
  List <BottomNavigationBarItem> navBarItems = [
    const BottomNavigationBarItem(icon: Icon(Icons.business),label: "Business"),
    const BottomNavigationBarItem(icon: Icon(Icons.science),label: "Science"),
    const BottomNavigationBarItem(icon: Icon(Icons.sports),label: "Sports"),
  ];

  List <Widget> screens = [
    const BusinessScreen(),
    const ScienceScreen(),
    const SportsScreen(),

  ];
  int curBottomIndex = 0;
  void changeIndex(int index){
    curBottomIndex = index;
    if(index == 1){
      getScience();
    }
    if(index == 2){
      getSports();
    }
    emit(BottomChangeState());
  }

  List<dynamic> business = [];
  void getBusiness(){
    emit(NewsGetBusinessLoadingState());
    DioHelper.getData(
        url: 'v2/top-headlines',
        query: {
          'country': 'eg',
          'category': 'business',
          'apiKey': 'a6ffa996d7ad4ba0ad1dda8ec9417e6c',
        }
    ).then((value) {
      business = value.data['articles'];
      print(business[0]['title']);
      emit(NewsGetBusinessSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(NewsGetBusinessErrorState(error.toString()));
    });
  }
  List<dynamic> sports = [];
  void getSports(){
    emit(NewsGetSportsLoadingState());
    if(sports.isEmpty){
      DioHelper.getData(
          url: 'v2/top-headlines',
          query: {
            'country': 'eg',
            'category': 'sports',
            'apiKey': 'a6ffa996d7ad4ba0ad1dda8ec9417e6c',
          }
      ).then((value) {
        sports = value.data['articles'];
        print(sports[0]['title']);
        emit(NewsGetSportsSuccessState());
      }).catchError((error){
        print(error.toString());
        emit(NewsGetSportsErrorState(error.toString()));
      });
    }
    else{
      emit(NewsGetSportsSuccessState());
    }

  }
  List<dynamic> science = [];
  void getScience(){
    emit(NewsGetScienceLoadingState());
    if(science.isEmpty){
      DioHelper.getData(
          url: 'v2/top-headlines',
          query: {
            'country': 'eg',
            'category': 'science',
            'apiKey': 'a6ffa996d7ad4ba0ad1dda8ec9417e6c',
          }
      ).then((value) {
        science = value.data['articles'];
        print(science[0]['title']);
        emit(NewsGetScienceSuccessState());
      }).catchError((error){
        print(error.toString());
        emit(NewsGetScienceErrorState(error.toString()));
      });
    }
    else{
      emit(NewsGetScienceSuccessState());
    }
  }
  List<dynamic> search = [];
  void getSearch(String value){
    emit(NewsGetSearchLoadingState());
    search = [];
    DioHelper.getData(
        url: 'v2/everything',
        query: {
          'q': value,
          'apiKey': 'a6ffa996d7ad4ba0ad1dda8ec9417e6c',
        }
    ).then((value) {
      search = value.data['articles'];
      print(search[0]['title']);
      emit(NewsGetSearchSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(NewsGetSearchErrorState(error.toString()));
    });
  }




  bool isDark = false;

  void changeAppMode({ bool?  fromShared}){
    if(fromShared != null){
      isDark = fromShared;
      emit(ChangeAppModeState());
    }
    else{
      isDark =!isDark;
      CacheHelper.setBoolean(key: "isDark", value: isDark).then((value) => emit(ChangeAppModeState()));

    }

  }

}