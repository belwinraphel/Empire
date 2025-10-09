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
  final List<String>? category;
  final List<String>? subcategory;

  const LoadProducts(
      {this.searchQuery,
      this.brandFilters,
      this.minPrice,
      this.maxPrice,
      this.category,
      this.subcategory});

  @override
  List<Object?> get props =>
      [searchQuery, brandFilters, minPrice, maxPrice, category, subcategory];
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
  final List<String>? category;
  final List<String>? subcategory;

  const UpdatePriceRange(
      {this.minPrice, this.maxPrice, this.category, this.subcategory});

  @override
  List<Object?> get props => [minPrice, maxPrice, category, subcategory];
}

class UpdateCategoryFilter extends ProductEvent {
  final String categoryId;

  const UpdateCategoryFilter(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

class UpdateSubcategoryFilter extends ProductEvent {
  final String subcategoryId;

  const UpdateSubcategoryFilter(this.subcategoryId);

  @override
  List<Object?> get props => [subcategoryId];
}

class ClearFilters extends ProductEvent {}

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
  final List<String>? category;
  final List<String>? subcategory;
  const ProductLoaded(
      {required this.products,
      this.searchQuery,
      this.brandFilters,
      this.minPrice,
      this.maxPrice,
      this.category,
      this.subcategory});

  @override
  List<Object?> get props =>
      [products, searchQuery, brandFilters, minPrice, maxPrice];
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
    on<UpdateCategoryFilter>(_onUpdateCategoryFilter); 
    on<UpdateSubcategoryFilter>(onUpdateSubcategoryFilter); 
    on<ClearFilters>(_onClearFilters);
  }

  Future<void> _onLoadProducts(
      LoadProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final result = await dataSource.searchAndFilterProducts(
        event.searchQuery,
        event.brandFilters,
        event.minPrice,
        event.maxPrice,
        event.category,
        event.subcategory);

    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) => emit(ProductLoaded(products: products)),
    );
  }

  Future<void> _onUpdateSearchQuery(
      UpdateSearchQuery event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final result = await dataSource.searchAndFilterProducts(
      event.query,
      state is ProductLoaded ? (state as ProductLoaded).brandFilters : null,
      state is ProductLoaded ? (state as ProductLoaded).minPrice : null,
      state is ProductLoaded ? (state as ProductLoaded).maxPrice : null,
      state is ProductLoaded ? (state as ProductLoaded).category : null,
      state is ProductLoaded ? (state as ProductLoaded).subcategory : null,
    );
   
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) => emit(ProductLoaded(
        products: products,
        searchQuery: event.query,
        brandFilters: state is ProductLoaded
            ? (state as ProductLoaded).brandFilters
            : null,
        minPrice:
            state is ProductLoaded ? (state as ProductLoaded).minPrice : null,
        maxPrice:
            state is ProductLoaded ? (state as ProductLoaded).maxPrice : null,
        category:
            state is ProductLoaded ? (state as ProductLoaded).category : null,
        subcategory: state is ProductLoaded
            ? (state as ProductLoaded).subcategory
            : null,
      )),
    );
  }

  Future<void> _onUpdateBrandFilters(
      UpdateBrandFilters event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final result = await dataSource.searchAndFilterProducts(
      state is ProductLoaded ? (state as ProductLoaded).searchQuery : null,
      event.brandFilters,
      state is ProductLoaded ? (state as ProductLoaded).minPrice : null,
      state is ProductLoaded ? (state as ProductLoaded).maxPrice : null,
      state is ProductLoaded ? (state as ProductLoaded).category : null,
      state is ProductLoaded ? (state as ProductLoaded).subcategory : null,
    );
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) => emit(ProductLoaded(
        products: products,
        searchQuery: state is ProductLoaded
            ? (state as ProductLoaded).searchQuery
            : null,
        brandFilters: event.brandFilters,
        minPrice:
            state is ProductLoaded ? (state as ProductLoaded).minPrice : null,
        maxPrice:
            state is ProductLoaded ? (state as ProductLoaded).maxPrice : null,
      )),
    );
  }

  Future<void> _onUpdatePriceRange(
      UpdatePriceRange event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final result = await dataSource.searchAndFilterProducts(
        state is ProductLoaded ? (state as ProductLoaded).searchQuery : null,
        state is ProductLoaded ? (state as ProductLoaded).brandFilters : null,
        event.minPrice,
        event.maxPrice,
        event.category,
        event.subcategory);
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) => emit(ProductLoaded(
        products: products,
        searchQuery: state is ProductLoaded
            ? (state as ProductLoaded).searchQuery
            : null,
        brandFilters: state is ProductLoaded
            ? (state as ProductLoaded).brandFilters
            : null,
        minPrice: event.minPrice,
        maxPrice: event.maxPrice,
        category: state is ProductLoaded
            ? (state as ProductLoaded).category
            : event.category,
        subcategory: state is ProductLoaded
            ? (state as ProductLoaded).subcategory
            : event.subcategory,
      )),
    );
  }

  Future<void> _onUpdateCategoryFilter(
      UpdateCategoryFilter event, Emitter<ProductState> emit) async {
    emit(ProductLoading());

    final currentState = state is ProductLoaded ? state as ProductLoaded : null;

    final result = await dataSource.searchAndFilterProducts(
      currentState?.searchQuery,
      currentState?.brandFilters,
      currentState?.minPrice,
      currentState?.maxPrice,
      [event.categoryId],
      null,
    );

    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) => emit(ProductLoaded(
        products: products,
        searchQuery: currentState?.searchQuery,
        brandFilters: currentState?.brandFilters,
        minPrice: currentState?.minPrice,
        maxPrice: currentState?.maxPrice,
        category: [event.categoryId],
        subcategory: null,
      )),
    );
  }

  Future<void> onUpdateSubcategoryFilter(
      UpdateSubcategoryFilter event, Emitter<ProductState> emit) async {
    emit(ProductLoading());

    final currentState = state is ProductLoaded ? state as ProductLoaded : null;

    final result = await dataSource.searchAndFilterProducts(
      currentState?.searchQuery,
      currentState?.brandFilters,
      currentState?.minPrice,
      currentState?.maxPrice,
      currentState?.category,
      [event.subcategoryId],
    );

    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) => emit(ProductLoaded(
        products: products,
        searchQuery: currentState?.searchQuery,
        brandFilters: currentState?.brandFilters,
        minPrice: currentState?.minPrice,
        maxPrice: currentState?.maxPrice,
        category: currentState?.category,
        subcategory: [event.subcategoryId],
      )),
    );
  }

  Future<void> _onClearFilters(
      ClearFilters event, Emitter<ProductState> emit) async {
    emit(ProductLoading());

    final result = await dataSource.searchAndFilterProducts(
      null,
      null,
      null,
      null,
      null,
      null,
    );

    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) => emit(ProductLoaded(products: products)),
    );
  }
}
