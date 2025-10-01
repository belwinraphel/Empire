import 'package:empire/feature/favorite/domain/repository/favotiterepository.dart';
import 'package:empire/feature/product/domain/enities/product_entities.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class FetchingFavoriteEvent extends Equatable {
  const FetchingFavoriteEvent();

  @override
  List<Object?> get props => [];
}

class LoadFetchingFavorites extends FetchingFavoriteEvent {}

abstract class FetchingFavoriteState extends Equatable {
  const FetchingFavoriteState();

  @override
  List<Object?> get props => [];
}

class FetchingFavoriteInitial extends FetchingFavoriteState {}

class FetchingFavoriteLoading extends FetchingFavoriteState {}

class FetchingFavoriteLoaded extends FetchingFavoriteState {
  final List<ProductEntity> products;

  const FetchingFavoriteLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

class FetchingFavoriteError extends FetchingFavoriteState {
  final String message;

  const FetchingFavoriteError(this.message);

  @override
  List<Object?> get props => [message];
}

class FetchingFavoriteBloc
    extends Bloc<FetchingFavoriteEvent, FetchingFavoriteState> {
  final FavoritesRepository repository;

  FetchingFavoriteBloc(this.repository) : super(FetchingFavoriteInitial()) {
    on<LoadFetchingFavorites>(_onLoadFavorites);
  }

  Future<void> _onLoadFavorites(
    LoadFetchingFavorites event,
    Emitter<FetchingFavoriteState> emit,
  ) async {
    emit(FetchingFavoriteLoading());

    final result = await repository.getFavoriteProduct();

    result.fold(
      (failure) => emit(FetchingFavoriteError(failure.message)),
      (products) => emit(FetchingFavoriteLoaded(products)),
    );
  }
}
