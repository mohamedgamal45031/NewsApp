import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:news_app/shared/bloc_observer.dart';
import 'package:news_app/shared/cubit/cubit.dart';
import 'package:news_app/shared/cubit/states.dart';
import 'package:news_app/shared/network/local/cache_helper.dart';
import 'package:news_app/shared/network/remote/dio_helper.dart';

import 'layout/news_layout/news_layout.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  BlocOverrides.runZoned(
        () async{
          DioHelper.init();
          await CacheHelper.init();
          bool? isDark = CacheHelper.getBoolean(key: "isDark");
          runApp(MyApp(isDark: isDark,));
    },

    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  bool? isDark ;
  MyApp( {this.isDark});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NewsCubit()..getBusiness(),),
        BlocProvider(create: (context) => NewsCubit()..changeAppMode(fromShared: isDark),),
      ],

      child: BlocConsumer<NewsCubit,NewsStates>(
        builder: (context,state){
          var cubit = NewsCubit.get(context);
          return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            textTheme: const TextTheme(
              bodyText1: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            appBarTheme: AppBarTheme(
              titleTextStyle: GoogleFonts.montserratAlternates(
                textStyle: const TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.white,
                statusBarIconBrightness: Brightness.dark
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              actionsIconTheme: const IconThemeData(
                  color: Colors.black,
                  size: 25
              ),
            ),
            primarySwatch: Colors.deepOrange,
            scaffoldBackgroundColor: Colors.white,
            bottomNavigationBarTheme:  BottomNavigationBarThemeData(
                type: BottomNavigationBarType.fixed,
                selectedLabelStyle: GoogleFonts.montserratAlternates(
                  textStyle: const TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                selectedItemColor: Colors.deepOrange,
                unselectedIconTheme: const IconThemeData(
                  color: Colors.black,
                )
            ),
          ),
          darkTheme: ThemeData(

            scaffoldBackgroundColor: HexColor('333739'),
            appBarTheme: AppBarTheme(
              titleTextStyle: GoogleFonts.montserratAlternates(
                textStyle: const TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              
              systemOverlayStyle:  SystemUiOverlayStyle(
                statusBarColor: HexColor('333739'),
              ),
              backgroundColor: HexColor('333739'),
              elevation: 0,
              actionsIconTheme: const IconThemeData(
                  color: Colors.white,
                  size: 25
              ),
            ),
            textTheme: const TextTheme(
              bodyText1: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            primarySwatch: Colors.deepOrange,
            bottomNavigationBarTheme:  BottomNavigationBarThemeData(
              type: BottomNavigationBarType.fixed,
              selectedLabelStyle: GoogleFonts.montserratAlternates(
                textStyle: const TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              unselectedItemColor: Colors.white,
              selectedItemColor: Colors.deepOrange,
              unselectedIconTheme: const IconThemeData(
                color: Colors.white,
              ),
              backgroundColor: HexColor('333739'),
            ),

          ),
          themeMode:NewsCubit.get(context).isDark ? ThemeMode.dark:ThemeMode.light,
          home: NewsLayout(),
        );
        },
        listener:(context,state){} ,

      ),

    );
  }
}
