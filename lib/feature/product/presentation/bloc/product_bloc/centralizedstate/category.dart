import 'package:empire/feature/product/domain/enities/category_entities.dart';
import 'package:empire/feature/product/domain/usecase/get_category_usecase.dart';
import 'package:empire/feature/product/domain/usecase/getting_subcategory_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CategorysEvent {}

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

abstract class CategorysState {}

class CategorysInitial extends CategorysState {}

class CategorysLoadingState extends CategorysState {}

class CategorysErrorState extends CategorysState {
  final String error;
  CategorysErrorState(this.error);
}

class CategorysLoadedState extends CategorysState {
  final List<CategoryEntities> categories;

  final Map<String, SubCategoryData> subCategoryMap;

  CategorysLoadedState({
    required this.categories,
    this.subCategoryMap = const {},
  });

  CategorysLoadedState copyWith({
    List<CategoryEntities>? categories,
    Map<String, SubCategoryData>? subCategoryMap,
  }) {
    return CategorysLoadedState(
      categories: categories ?? this.categories,
      subCategoryMap: subCategoryMap ?? this.subCategoryMap,
    );
  }
}

class CategorsyBloc extends Bloc<CategorysEvent, CategorysState> {
  final CategoryUsecase categoryUsecase;
  final GettingSubcategoryUsecase gettingSubcategoryUsecase;

  CategorsyBloc({
    required this.categoryUsecase,
    required this.gettingSubcategoryUsecase,
  }) : super(CategorysInitial()) {
    on<FetchAllCategoryData>((event, emit) async {
      emit(CategorysLoadingState());
      try {
        final categoriesResult = await categoryUsecase();

        await categoriesResult.fold(
          (mainCategories) async {
            if (mainCategories.isEmpty) {
              emit(CategorysLoadedState(categories: []));
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
                },
              );
            }
           
            emit(CategorysLoadedState(
              categories: mainCategories,
              subCategoryMap: subCategoryMap,
            ));
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
