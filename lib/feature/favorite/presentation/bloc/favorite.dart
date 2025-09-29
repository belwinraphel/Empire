import 'dart:async';
import 'package:empire/feature/favorite/domain/usecase/add_favorites_usecase.dart';
import 'package:empire/feature/favorite/domain/usecase/get_favourite_usecase.dart';
import 'package:empire/feature/favorite/domain/usecase/remove_favorites_usecase.dart';
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

class FavoritesUpdated extends FavoritesEvent {
  final Set<String> favoriteProductIds;
  const FavoritesUpdated({required this.favoriteProductIds});
  @override
  List<Object> get props => [favoriteProductIds];
}

abstract class FavoritesState extends Equatable {
  const FavoritesState();
  @override
  List<Object> get props => [];
}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final Set<String> favoriteProductIds;
  const FavoritesLoaded({this.favoriteProductIds = const {}});
  @override
  List<Object> get props => [favoriteProductIds];
}

class FavoritesError extends FavoritesState {}

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetFavoritesStreamUseCase _getFavoritesStreamUseCase;
  final AddFavoriteUseCase _addFavoriteUseCase;
  final RemoveFavoriteUseCase _removeFavoriteUseCase;
  StreamSubscription? _favoritesSubscription;

  FavoritesBloc({
    required GetFavoritesStreamUseCase getFavoritesStreamUseCase,
    required AddFavoriteUseCase addFavoriteUseCase,
    required RemoveFavoriteUseCase removeFavoriteUseCase,
  })  : _getFavoritesStreamUseCase = getFavoritesStreamUseCase,
        _addFavoriteUseCase = addFavoriteUseCase,
        _removeFavoriteUseCase = removeFavoriteUseCase,
        super(FavoritesLoading()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<FavoritesUpdated>(_onFavoritesUpdated);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  void _onLoadFavorites(LoadFavorites event, Emitter<FavoritesState> emit) {
    _favoritesSubscription?.cancel();
    _favoritesSubscription = _getFavoritesStreamUseCase().listen((ids) {
      add(FavoritesUpdated(favoriteProductIds: ids));
    });
  }

  void _onFavoritesUpdated(
      FavoritesUpdated event, Emitter<FavoritesState> emit) {
    emit(FavoritesLoaded(favoriteProductIds: event.favoriteProductIds));
  }

  void _onToggleFavorite(
      ToggleFavorite event, Emitter<FavoritesState> emit) async {
    final currentState = state;
    if (currentState is FavoritesLoaded) {
      if (currentState.favoriteProductIds.contains(event.productId)) {
        await _removeFavoriteUseCase(event.productId);
      } else {
        await _addFavoriteUseCase(event.productId);
      }
    }
  }

  @override
  Future<void> close() {
    _favoritesSubscription?.cancel();
    return super.close();
  }
}
