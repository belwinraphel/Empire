 // Events
import 'dart:async';

import 'package:empire/feature/favorite/domain/repository/favotiterepository.dart';
import 'package:empire/feature/favorite/domain/usecase/add_favorites_usecase.dart';
import 'package:empire/feature/favorite/domain/usecase/get_favourite_usecase.dart';
import 'package:empire/feature/favorite/domain/usecase/remove_favorites_usecase.dart';
import 'package:empire/feature/product/domain/enities/product_entities.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();
  @override
  List<Object> get props => [];
}

class LoadFavorites extends FavoritesEvent {}

class ToggleFavorite extends FavoritesEvent {
  final String productId;
  const ToggleFavorite({required this.productId});
  @override
  List<Object> get props => [productId];
}

class FavoritesIdsUpdated extends FavoritesEvent {
  final Set<String> favoriteProductIds;
  const FavoritesIdsUpdated({required this.favoriteProductIds});
  @override
  List<Object> get props => [favoriteProductIds];
}

class RefreshFavoriteProducts extends FavoritesEvent {}

// States
abstract class FavoritesState extends Equatable {
  const FavoritesState();
  @override
  List<Object> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<ProductEntity> products;
  final Set<String> favoriteProductIds;
  
  const FavoritesLoaded({
    required this.products,
    this.favoriteProductIds = const {},
  });

  @override
  List<Object> get props => [products, favoriteProductIds];

  FavoritesLoaded copyWith({
    List<ProductEntity>? products,
    Set<String>? favoriteProductIds,
  }) {
    return FavoritesLoaded(
      products: products ?? this.products,
      favoriteProductIds: favoriteProductIds ?? this.favoriteProductIds,
    );
  }
}

class FavoritesError extends FavoritesState {
  final String message;
  const FavoritesError(this.message);
  @override
  List<Object> get props => [message];
}

// BLoC
class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetFavoritesStreamUseCase _getFavoritesStreamUseCase;
  final AddFavoriteUseCase _addFavoriteUseCase;
  final RemoveFavoriteUseCase _removeFavoriteUseCase;
  final FavoritesRepository _repository;
  
  StreamSubscription? _favoritesSubscription;

  FavoritesBloc({
    required GetFavoritesStreamUseCase getFavoritesStreamUseCase,
    required AddFavoriteUseCase addFavoriteUseCase,
    required RemoveFavoriteUseCase removeFavoriteUseCase,
    required FavoritesRepository repository,
  })  : _getFavoritesStreamUseCase = getFavoritesStreamUseCase,
        _addFavoriteUseCase = addFavoriteUseCase,
        _removeFavoriteUseCase = removeFavoriteUseCase,
        _repository = repository,
        super(FavoritesInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<FavoritesIdsUpdated>(_onFavoritesIdsUpdated);
    on<ToggleFavorite>(_onToggleFavorite);
    on<RefreshFavoriteProducts>(_onRefreshFavoriteProducts);
  }

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(FavoritesLoading());

    // Fetch product details
    final result = await _repository.getFavoriteProduct();
    
    await result.fold(
      (failure) async => emit(FavoritesError(failure.message)),
      (products) async {
        // Listen to favorite IDs stream
        _favoritesSubscription?.cancel();
        _favoritesSubscription = _getFavoritesStreamUseCase().listen((ids) {
          add(FavoritesIdsUpdated(favoriteProductIds: ids));
        });

        emit(FavoritesLoaded(products: products));
      },
    );
  }

  void _onFavoritesIdsUpdated(
    FavoritesIdsUpdated event,
    Emitter<FavoritesState> emit,
  ) {
    final currentState = state;
    if (currentState is FavoritesLoaded) {
     
      final updatedProducts = currentState.products
          .where((product) => event.favoriteProductIds.contains(product.productDocId))
          .toList();
      
      emit(currentState.copyWith(
        products: updatedProducts,
        favoriteProductIds: event.favoriteProductIds,
      ));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<FavoritesState> emit,
  ) async {
    final currentState = state;
    if (currentState is FavoritesLoaded) {
      if (currentState.favoriteProductIds.contains(event.productId)) {
        await _removeFavoriteUseCase(event.productId);
      } else {
        await _addFavoriteUseCase(event.productId);
      }
 
    }
  }

  Future<void> _onRefreshFavoriteProducts(
    RefreshFavoriteProducts event,
    Emitter<FavoritesState> emit,
  ) async {
    final currentState = state;
    if (currentState is FavoritesLoaded) {
      final result = await _repository.getFavoriteProduct();
      result.fold(
        (failure) => emit(FavoritesError(failure.message)),
        (products) => emit(currentState.copyWith(products: products)),
      );
    }
  }

  @override
  Future<void> close() {
    _favoritesSubscription?.cancel();
    return super.close();
  }
}