 

 
 
import 'package:empire/feature/product/data/datasource/product_datasource.dart';
import 'package:empire/feature/product/domain/enities/listproducts.dart';
import 'package:empire/feature/product/domain/enities/product_entities.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductEvent {
  final String? searchQuery;
  final List<String>? brandFilters;
  final double? minPrice;
  final double? maxPrice;

  const LoadProducts({
    this.searchQuery,
    this.brandFilters,
    this.minPrice,
    this.maxPrice,
  });

  @override
  List<Object?> get props => [searchQuery, brandFilters, minPrice, maxPrice];
}

class UpdateSearchQuery extends ProductEvent {
  final String query;

  const UpdateSearchQuery(this.query);

  @override
  List<Object?> get props => [query];
}

class UpdateBrandFilters extends ProductEvent {
  final List<String> brandFilters;

  const UpdateBrandFilters(this.brandFilters);

  @override
  List<Object?> get props => [brandFilters];
}

class UpdatePriceRange extends ProductEvent {
  final double? minPrice;
  final double? maxPrice;

  const UpdatePriceRange({this.minPrice, this.maxPrice});

  @override
  List<Object?> get props => [minPrice, maxPrice];
}

class LoadBrands extends ProductEvent {}

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<ProductEntity> products;
  final String? searchQuery;
  final List<String>? brandFilters;
  final double? minPrice;
  final double? maxPrice;

  const ProductLoaded({
    required this.products,
    this.searchQuery,
    this.brandFilters,
    this.minPrice,
    this.maxPrice,
  });

  @override
  List<Object?> get props => [products, searchQuery, brandFilters, minPrice, maxPrice];
}

class ProductBrandsLoaded extends ProductState {
  final List<Brand> brands;

  const ProductBrandsLoaded({required this.brands});

  @override
  List<Object?> get props => [brands];
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductsDataSource dataSource;

  ProductBloc({required this.dataSource}) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<UpdateSearchQuery>(_onUpdateSearchQuery);
    on<UpdateBrandFilters>(_onUpdateBrandFilters);
    on<UpdatePriceRange>(_onUpdatePriceRange);
 
  }

  Future<void> _onLoadProducts(LoadProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final result = await dataSource.searchAndFilterProducts(
      event.searchQuery,
        event.brandFilters,
       event.minPrice,
     event.maxPrice,
    );
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) => emit(ProductLoaded(products: products)),
    );
  }

  Future<void> _onUpdateSearchQuery(UpdateSearchQuery event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final result = await dataSource.searchAndFilterProducts(
  event.query,
 state is ProductLoaded ? (state as ProductLoaded).brandFilters : null,
  state is ProductLoaded ? (state as ProductLoaded).minPrice : null,
   state is ProductLoaded ? (state as ProductLoaded).maxPrice : null,
    );
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) => emit(ProductLoaded(
        products: products,
        searchQuery: event.query,
        brandFilters: state is ProductLoaded ? (state as ProductLoaded).brandFilters : null,
        minPrice: state is ProductLoaded ? (state as ProductLoaded).minPrice : null,
        maxPrice: state is ProductLoaded ? (state as ProductLoaded).maxPrice : null,
      )),
    );
  }

  Future<void> _onUpdateBrandFilters(UpdateBrandFilters event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final result = await dataSource.searchAndFilterProducts(
     state is ProductLoaded ? (state as ProductLoaded).searchQuery : null,
      event.brandFilters,
    state is ProductLoaded ? (state as ProductLoaded).minPrice : null,
     state is ProductLoaded ? (state as ProductLoaded).maxPrice : null,
    );
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) => emit(ProductLoaded(
        products: products,
        searchQuery: state is ProductLoaded ? (state as ProductLoaded).searchQuery : null,
        brandFilters: event.brandFilters,
        minPrice: state is ProductLoaded ? (state as ProductLoaded).minPrice : null,
        maxPrice: state is ProductLoaded ? (state as ProductLoaded).maxPrice : null,
      )),
    );
  }

  Future<void> _onUpdatePriceRange(UpdatePriceRange event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final result = await dataSource.searchAndFilterProducts(
      state is ProductLoaded ? (state as ProductLoaded).searchQuery : null,
      state is ProductLoaded ? (state as ProductLoaded).brandFilters : null,
 event.minPrice,
      event.maxPrice,
    );
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) => emit(ProductLoaded(
        products: products,
        searchQuery: state is ProductLoaded ? (state as ProductLoaded).searchQuery : null,
        brandFilters: state is ProductLoaded ? (state as ProductLoaded).brandFilters : null,
        minPrice: event.minPrice,
        maxPrice: event.maxPrice,
      )),
    );
  }

 
}