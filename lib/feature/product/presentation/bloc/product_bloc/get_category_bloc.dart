import 'package:empire/feature/product/domain/enities/category_entities.dart';
import 'package:empire/feature/product/domain/usecase/get_category_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CategoryEvent {}

class GetCategoryEvent extends CategoryEvent {}

class SelectedCategoryEvent extends CategoryEvent {
  final String selectedId;
  SelectedCategoryEvent(this.selectedId);
}

class CategoryErrorEvent extends CategoryEvent {
  final String error;
  CategoryErrorEvent(this.error);
}

abstract class CategoryState {}

class CategoryLoadingState extends CategoryState {}

class CategoryLoadedState extends CategoryState {
  final List<CategoryEntities> categories;
  final String? selectedCategoryId;

  CategoryLoadedState({required this.categories, this.selectedCategoryId});

  CategoryLoadedState copyWith({
    List<CategoryEntities>? categories,
    String? selectedCategoryId,
  }) {
    return CategoryLoadedState(
      categories: categories ?? this.categories,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
    );
  }
}

class CategoryErrorState extends CategoryState {
  final String error;
  CategoryErrorState(this.error);
}

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryUsecase categoryUsecase;

  CategoryBloc(this.categoryUsecase) : super(CategoryLoadingState()) {
    on<GetCategoryEvent>((event, emit) async {
      emit(CategoryLoadingState());
      try {
        final category = await categoryUsecase();
        category.fold(
          (category) {
            emit(CategoryLoadedState(categories: category));
          },
          (error) {
            CategoryErrorState(error.message);
          },
        );
      } catch (e) {
        emit(CategoryErrorState(e.toString()));
      }
    });

    on<SelectedCategoryEvent>((event, emit) {
      if (state is CategoryLoadedState) {
        final currentState = state as CategoryLoadedState;
        emit(currentState.copyWith(selectedCategoryId: event.selectedId));
      }
    });
  }
}
