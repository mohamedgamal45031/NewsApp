

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/shared/cubit/cubit.dart';

import '../../modules/search/search_screen.dart';
import '../../shared/components/components.dart';
import '../../shared/cubit/states.dart';
import '../../shared/network/remote/dio_helper.dart';

class NewsLayout extends StatelessWidget {
  const NewsLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = NewsCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 95),
                child: const Text(
                  "News App",
                ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  navigateTo(context,SearchScreen());
                },
                icon: const Icon(
                  Icons.search,
                  size: 30.0,
                ),
              ),
              IconButton(
                onPressed: () {
                  NewsCubit.get(context).changeAppMode();
                },
                icon: const Icon(
                  Icons.dark_mode,
                  size: 30.0,
                ),
              ),
            ],
          ),
          body: cubit.screens[cubit.curBottomIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.curBottomIndex,
            onTap: (index) => cubit.changeIndex(index),
            items: cubit.navBarItems,
          ),
        );
      },
    );
  }
}
