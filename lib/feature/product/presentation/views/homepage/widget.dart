import 'package:empire/feature/product/presentation/bloc/product_bloc/get_category_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

Widget buildShimmerLoading(BuildContext context) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.07,
    child: ListView.builder(
        shrinkWrap: true,
        itemCount: 4,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, int index) {
          return Row( 
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              )
            ],
          );
        }),
  );
}
Widget homeShimmerLoading(BuildContext context) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.07,
    child: ListView.builder(
        shrinkWrap: true,
        itemCount: 4,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, int index) {
          return Row( 
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              )
            ],
          );
        }),
  );
}

Widget buildErrorState(BuildContext context, String error) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(error),
      const SizedBox(height: 8),
      TextButton(
        onPressed: () {
          context.read<CategoryBloc>().add(GetCategoryEvent());
        },
        child: const Text('Retry'),
      ),
    ],
  );
}
