import 'package:empire/feature/product/presentation/bloc/product_bloc/get_subcategory.dart';
import 'package:empire/feature/product/presentation/bloc/product_bloc/product_bloc.dart';

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
    context.read<SubCategoryBloc>().add(GetSubCategoryEvent(mainCtageoruId!));
    context.read<ProductcalingBloc>().add(ProductCallingEvent(
        mainCategoryId: mainCtageoruId!,
        subCategoryId: subcategoyId!,
        subcategoryname: subcategName));
    return Scaffold(
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
            SubCategory(
              mainCtageoruId: mainCtageoruId!,
              isSlected: isSlected,
            ),
            ProductSection(
                mainCtageoruId: mainCtageoruId!, subcategoyId: subcategoyId!)
          ],
        ),
      ),
    );
  }
}
