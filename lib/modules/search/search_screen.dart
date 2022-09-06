import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/shared/components/components.dart';
import 'package:news_app/shared/cubit/cubit.dart';
import 'package:news_app/shared/cubit/states.dart';

class SearchScreen extends StatelessWidget {
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit,NewsStates>(
      builder:(context, state) {
        var list = NewsCubit.get(context).search;
        return Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: searchController,
                  keyboardType: TextInputType.text,
                  onChanged: ( value) {
                    NewsCubit.get(context).getSearch(value);
                  },
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "Search must not be empty";
                    }
                    return null;
                  },
                  decoration:  InputDecoration(

                    fillColor: Colors.grey[200],
                    prefixIcon: Icon(Icons.search),
                    labelText: "Search",
                  ),
                ),
              ),
              Expanded(
                child:
                articleBuilder(list, context,isSearch: true),
              ),
            ],
          ),
        );
      },

      listener:(context, state) {} ,
    );
  }
}
