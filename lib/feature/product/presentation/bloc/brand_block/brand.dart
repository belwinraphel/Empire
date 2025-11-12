 
import 'package:empire/feature/product/domain/enities/listproducts.dart';
import 'package:empire/feature/product/domain/usecase/product/add_product_usecae.dart';
import 'package:empire/feature/product/domain/usecase/productcaliing_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
abstract class BrandEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class BrandFetching extends BrandEvent {
  final String mainCategoryId;
  final String subCategoryId;
  BrandFetching({required this.mainCategoryId, required this.subCategoryId});

  @override
  List<Object> get props => [mainCategoryId, subCategoryId];
}

class BrandAdding extends BrandEvent {
  final String mainCategoryId;
  final String subCategoryId;
  final Brand brand;
  BrandAdding({
    required this.mainCategoryId,
    required this.subCategoryId,
    required this.brand,
  });
  @override
  List<Object> get props => [mainCategoryId, subCategoryId];
}

abstract class BrandState extends Equatable {
  @override
  List<Object> get props => [];
}

class BrandLoading extends BrandState {}

class LoadedBrand extends BrandState {
  final List<Brand> brands;
  LoadedBrand({required this.brands});
  @override
  List<Object> get props => [brands];
}

class Error extends BrandState {
  final String error;
  Error({required this.error});
  @override
  List<Object> get props => [error];
}

class BrandBloc extends Bloc<BrandEvent, BrandState> {
  final ProductcallingUsecase productcaliingUsecase;
  final AddProductUseCase addProduct;
  BrandBloc(this.productcaliingUsecase, this.addProduct)
    : super(BrandLoading()) {
    on<BrandFetching>((event, emit) async {
      final result = await productcaliingUsecase.getProductBrand(
        event.mainCategoryId,
        event.subCategoryId,
      );
      result.fold(
        (failure) => emit(Error(error: failure.message)),
        (result) => emit(LoadedBrand(brands: result)),
      );
    });
    on<BrandAdding>((event, emit) {
      emit(BrandLoading());
      addProduct.addingBrand(
        event.mainCategoryId,
        event.subCategoryId,
        event.brand,
      );
    });
  }
}
