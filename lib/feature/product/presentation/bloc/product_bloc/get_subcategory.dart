import 'package:empire/feature/product/domain/enities/category_entities.dart';
import 'package:empire/feature/product/domain/usecase/getting_subcategory_usecase.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SubCategoryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetSubCategoryEvent extends SubCategoryEvent {
  final String id;
  GetSubCategoryEvent(this.id);
}

class SelectedSubCategoryEvent extends SubCategoryEvent {
  final String selectedId;
  SelectedSubCategoryEvent(this.selectedId);
  @override
  List<Object> get props => [selectedId];
}

class CategoryErrorEvent extends SubCategoryEvent {
  final String error;
  CategoryErrorEvent(this.error);
  @override
  List<Object> get props => [error];
}

abstract class SubCategoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubCategoryLoadingState extends SubCategoryState {}

class SubCategoryLoadedState extends SubCategoryState {
  final List<CategoryEntities> categories;

  SubCategoryLoadedState({required this.categories});

  SubCategoryLoadedState copyWith({
    List<CategoryEntities>? categories,
    String? selectedCategoryId,
  }) {
    return SubCategoryLoadedState(categories: categories ?? this.categories);
  }

  @override
  List<Object?> get props => [categories];
}

class SubCategoryErrorState extends SubCategoryState {
  final String error;
  SubCategoryErrorState(this.error);
}

class SubCategoryBloc extends Bloc<SubCategoryEvent, SubCategoryState> {
  final GettingSubcategoryUsecase gettingSubcategoryUsecase;

  SubCategoryBloc(this.gettingSubcategoryUsecase)
    : super(SubCategoryLoadingState()) {
    on<GetSubCategoryEvent>((event, emit) async {
      emit(SubCategoryLoadingState());
      try {
        final category = await gettingSubcategoryUsecase(event.id);
        category.fold(
          (error) {
            SubCategoryErrorState(error.message);
          },
          (category) {
            emit(SubCategoryLoadedState(categories: category));
          },
        );
      } catch (e) {
        emit(SubCategoryErrorState(e.toString()));
      }
    });

    on<SelectedSubCategoryEvent>((event, emit) {
      if (state is SubCategoryLoadedState) {
        final currentState = state as SubCategoryLoadedState;
        emit(currentState.copyWith(selectedCategoryId: event.selectedId));
      }
    });
  }
}
