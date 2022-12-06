import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newapp/modules/shop_app/search/cubit/cubit.dart';
import 'package:newapp/modules/shop_app/search/cubit/state.dart';
import 'package:newapp/shared/components/components.dart';

class ShopSearchScreen extends StatelessWidget {
  const ShopSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var searchCntrlr = TextEditingController();
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Search'), centerTitle: true),
            body: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    defultFormField(
                      controller: searchCntrlr,
                      type: TextInputType.text,
                      validate: (String? value) {
                        if (value!.isEmpty) {
                          return 'Enter text to Search';
                        }
                        return null;
                      },
                      label: 'Search',
                      prefix: Icons.search,
                      onSubmit: (String? text) {
                        SearchCubit.get(context).Search(text!);
                      },
                    ),
                    const SizedBox(height: 15),
                    if (state is SearchLoadingState)
                      const LinearProgressIndicator(),
                    const SizedBox(height: 15),
                    if (state is SearchSuccessState)
                      Expanded(
                        child: ListView.separated(
                          itemBuilder: (context, index) => buildListProduct(
                            SearchCubit.get(context).model!.data!.data![index],
                            context,
                            isOldPrice: false,
                          ),
                          separatorBuilder: (context, index) => myDivder(),
                          itemCount: SearchCubit.get(context)
                              .model!
                              .data!
                              .data!
                              .length,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
