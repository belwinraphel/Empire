import 'package:empire/feature/favorite/domain/repository/favotiterepository.dart';
import 'package:empire/feature/product/domain/enities/product_entities.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object?> get props => [];
}

class LoadFavorites extends FavoriteEvent {}
abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object?> get props => [];
}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<ProductEntity> products;

  const FavoriteLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

class FavoriteError extends FavoriteState {
  final String message;

  const FavoriteError(this.message);

  @override
  List<Object?> get props => [message];
}
class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoritesRepository repository;

  FavoriteBloc(this.repository) : super(FavoriteInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
  }

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoriteState> emit,
  ) async {
    emit(FavoriteLoading());

    final result = await repository.getFavoriteProduct();

    result.fold(
      (failure) => emit(FavoriteError(failure.message)),
      (products) => emit(FavoriteLoaded(products)),
    );
  }
}