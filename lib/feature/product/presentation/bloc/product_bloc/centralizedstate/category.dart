import 'package:empire/feature/product/domain/enities/category_entities.dart';
import 'package:empire/feature/product/domain/enities/product_entities.dart';
import 'package:empire/feature/product/domain/usecase/get_category_usecase.dart';
import 'package:empire/feature/product/domain/usecase/getting_subcategory_usecase.dart';
import 'package:empire/feature/product/domain/usecase/product/sucategory_product_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CategorysEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchAllCategoryData extends CategorysEvent {}

class SubCategoryData {
  final bool isLoading;
  final List<CategoryEntities> subCategories;
  final String? error;

  SubCategoryData({
    this.isLoading = false,
    this.subCategories = const [],
    this.error,
  });
}

class ProductCallingEvent extends CategorysEvent {
  final List<String>? subcategory;
  final List<CategoryEntities>? categories;
  final Map<String, SubCategoryData>? subCategoryMap;

  ProductCallingEvent({this.subcategory, this.categories, this.subCategoryMap});
  @override
  List<Object?> get props => [subcategory, categories, subCategoryMap];
}

abstract class CategorysState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CategorysInitial extends CategorysState {}

class CategorysLoadingState extends CategorysState {}

class CategorysErrorState extends CategorysState {
  final String error;
  CategorysErrorState(this.error);
}

class ProductErrorState extends CategorysState {
  final String error;
  ProductErrorState(this.error);
}

class CategorysLoadedState extends CategorysState {
  final List<CategoryEntities> categories;
  final Map<String, List<ProductEntity>>? allproduct;
  final Map<String, SubCategoryData> subCategoryMap;
  final List<String>? listOfsubcategory;

  CategorysLoadedState({
    this.allproduct,
    required this.categories,
    this.listOfsubcategory,
    this.subCategoryMap = const {},
  });

  CategorysLoadedState copyWith({
    List<CategoryEntities>? categories,
    final Map<String, List<ProductEntity>>? allproduct,
    Map<String, SubCategoryData>? subCategoryMap,
  }) {
    return CategorysLoadedState(
      allproduct: allproduct ?? this.allproduct,
      categories: categories ?? this.categories,
      subCategoryMap: subCategoryMap ?? this.subCategoryMap,
    );
  }
}

class AllProduct extends CategorysState {
  final List<CategoryEntities> categories;
  final Map<String, SubCategoryData> subCategoryMap;
  final List<ProductEntity>? allproduct;
  AllProduct(
      {this.allproduct,
      required this.categories,
      required this.subCategoryMap});
  @override
  List<Object?> get props => [allproduct, categories, subCategoryMap];
}

class CategorsyBloc extends Bloc<CategorysEvent, CategorysState> {
  final CategoryUsecase categoryUsecase;
  final GettingSubcategoryUsecase gettingSubcategoryUsecase;
  final GettingSubcateoryProductUsecase gettingSubcateoryProductUsecase;

  CategorsyBloc({
    required this.gettingSubcateoryProductUsecase,
    required this.categoryUsecase,
    required this.gettingSubcategoryUsecase,
  }) : super(CategorysInitial()) {
    on<FetchAllCategoryData>((event, emit) async {
      emit(CategorysLoadingState());
      try {
        List<ProductEntity> allProducts;
        final categoriesResult = await categoryUsecase();
        final List<String> allSubCategory = [];
        final Map<String, String> subCategoryToMainCategoryMap = {};
        final Map<String, List<ProductEntity>> subCategoryBaesProduct = {};
        await categoriesResult.fold(
          (mainCategories) async {
            if (mainCategories.isEmpty) {
              emit(CategorysLoadedState(categories: const []));
              return;
            }

            final subCategoryFutures = mainCategories.map((category) {
              return gettingSubcategoryUsecase(category.uid);
            }).toList();

            final subCategoryResults = await Future.wait(subCategoryFutures);

            final Map<String, SubCategoryData> subCategoryMap = {};

            for (int i = 0; i < mainCategories.length; i++) {
              final categoryId = mainCategories[i].uid;

              final result = subCategoryResults[i];

              result.fold(
                (error) {
                  subCategoryMap[categoryId] =
                      SubCategoryData(error: error.message);
                },
                (subCategories) {
                  subCategoryMap[categoryId] =
                      SubCategoryData(subCategories: subCategories);
                  for (var sub in subCategories) {
                    allSubCategory.add(sub.category);
                    subCategoryToMainCategoryMap[sub.category] = categoryId;
                  }
                },
              );
            }

            final productResult =
                await gettingSubcateoryProductUsecase(allSubCategory);

            productResult.fold(
              (error) {
                allProducts = const [];
                emit(CategorysLoadedState(
                  categories: mainCategories,
                  subCategoryMap: subCategoryMap,
                ));
              },
              (products) {
                for (final product in products) {
                  final subCategoryName = product.subcategoryName;

                  subCategoryBaesProduct
                      .putIfAbsent(subCategoryName, () => [])
                      .add(product);
                }

                emit(CategorysLoadedState(
                  categories: mainCategories,
                  subCategoryMap: subCategoryMap,
                  allproduct: subCategoryBaesProduct,
                ));
              },
            );
          },
          (error) {
            emit(CategorysErrorState(error.message));
          },
        );
      } catch (e) {
        emit(CategorysErrorState(e.toString()));
      }
    });
  }
}
