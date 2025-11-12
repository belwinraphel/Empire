import 'package:empire/core/di/service_locator.dart';
import 'package:empire/core/utilis/noresult%20.dart';
import 'package:empire/feature/product/domain/usecase/getting_subcategory_usecase.dart';
import 'package:empire/feature/product/domain/usecase/productcaliing_usecase.dart';
import 'package:empire/feature/product/presentation/bloc/product_bloc/get_subcategory.dart';
import 'package:empire/feature/product/presentation/bloc/product_bloc/product_bloc.dart';
import 'package:empire/feature/product/presentation/views/homepage/widget.dart';
import 'package:empire/feature/product/presentation/views/sucategoryPage/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubCategoryPage extends StatelessWidget {
  String? mainCtageoruId;
  String? subcategoyId;
  String subcategName;
  SubCategoryPage(
      {super.key,
      this.subcategoyId,
      this.mainCtageoruId,
      required this.subcategName});
  String? isSlected;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => SubCategoryBloc(sl<GettingSubcategoryUsecase>())
              ..add(GetSubCategoryEvent(mainCtageoruId!))),
        BlocProvider(
            create: (_) => ProductcalingBloc(sl<ProductcallingUsecase>())
              ..add(ProductCallingEvent(
                  mainCategoryId: mainCtageoruId!,
                  subCategoryId: subcategoyId!,
                  subcategoryname: subcategName)))
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: appbar(context, subcategName),
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<SubCategoryBloc>().add(
                  GetSubCategoryEvent(
                      isSlected == null ? mainCtageoruId! : isSlected!),
                );
            await Future.delayed(const Duration(milliseconds: 600));
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<SubCategoryBloc, SubCategoryState>(
                builder: (context, state) {
                  if (state is SubCategoryLoadingState) {
                    return subcategoryShimmerLoading(context);
                  } else if (state is SubCategoryErrorState) {
                    return buildErrorState(context, state.error);
                  } else if (state is SubCategoryLoadedState) {
                    if (state.categories.isEmpty) {
                      return const Center(
                        child: Text("No categories available."),
                      );
                    }

                    return subcategory(state, isSlected, mainCtageoruId!);
                  }
                  return subcategoryShimmerLoading(context);
                },
              ),
              BlocBuilder<ProductcalingBloc, Productstate>(
                builder: (context, state) {
                  if (state is ProductError) {
                    return Center(child: Text(state.messange));
                  } else if (state is Productfetched) {
                    if (state.products.isEmpty) {
                      return const NoResultsScreen();
                    } else {
                      return products(
                          context, state, mainCtageoruId!, subcategoyId!);
                    }
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
