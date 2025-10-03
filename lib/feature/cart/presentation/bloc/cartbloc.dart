import 'dart:async';

import 'package:empire/feature/cart/domain/entities/cart_entities.dart';
import 'package:empire/feature/cart/domain/entities/order_breakdown.dart';
import 'package:empire/feature/cart/domain/entities/variant_snapshot.dart';
import 'package:empire/feature/cart/domain/usecase/add_cart_usecase.dart';
import 'package:empire/feature/cart/domain/usecase/breakdown_usecase.dart';
import 'package:empire/feature/cart/domain/usecase/clearcartusecase.dart';
import 'package:empire/feature/cart/domain/usecase/get_cart_use_case.dart';
import 'package:empire/feature/cart/domain/usecase/remove_from_cart_usecase.dart';
import 'package:empire/feature/cart/domain/usecase/updatequantityusecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CartState extends Equatable {
  @override
  List<Object> get props => [];
}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;
  final OrderBreakdown breakdown;

  CartLoaded({required this.items, required this.breakdown});

  @override
  List<Object> get props => [items, breakdown];
}

class CartError extends CartState {
  final String message;

  CartError(this.message);

  @override
  List<Object> get props => [message];
}

abstract class CartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddToCart extends CartEvent {
  final String productId;
  final String variantName;
  final int quantity;
  final VariantSnapshot? snapshot;

  AddToCart(this.productId, this.variantName, this.quantity, {this.snapshot});

  @override
  List<Object?> get props => [productId, variantName, quantity, snapshot];
}

class UpdateQuantity extends CartEvent {
  final String productId;
  final String variantName;
  final int newQuantity;

  UpdateQuantity(this.productId, this.variantName, this.newQuantity);

  @override
  List<Object> get props => [productId, variantName, newQuantity];
}

class RemoveFromCart extends CartEvent {
  final String productId;
  final String variantName;

  RemoveFromCart(this.productId, this.variantName);

  @override
  List<Object> get props => [productId, variantName];
}

class ClearCart extends CartEvent {}

class CartUpdated extends CartEvent {
  final List<CartItem> items;

  CartUpdated(this.items);

  @override
  List<Object> get props => [items];
}

class _CartError extends CartEvent {
  final String message;

  _CartError(this.message);

  @override
  List<Object> get props => [message];
}

class CartBloc extends Bloc<CartEvent, CartState> {
  final AddToCartUseCase addToCartUseCase;
  final UpdateQuantityUseCase updateQuantityUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  final ClearCartUseCase clearCartUseCase;
  final GetCartStreamUseCase getCartStreamUseCase;
  final CalculateBreakdownUseCase calculateBreakdownUseCase;

  late StreamSubscription<List<CartItem>> _cartSubscription;

  CartBloc({
    required this.addToCartUseCase,
    required this.updateQuantityUseCase,
    required this.removeFromCartUseCase,
    required this.clearCartUseCase,
    required this.getCartStreamUseCase,
    required this.calculateBreakdownUseCase,
  }) : super(CartLoading()) {
    _cartSubscription = getCartStreamUseCase().listen((items) {
      add(CartUpdated(items));
    });

    on<AddToCart>((event, emit) async {
      if (state is CartLoaded) {
        final current = state as CartLoaded;
        final index = current.items.indexWhere((item) =>
            item.productId == event.productId &&
            item.variantName == event.variantName);
        List<CartItem> newItems = List.from(current.items);
        if (index != -1) {
          newItems[index] = newItems[index]
              .copyWith(quantity: newItems[index].quantity + event.quantity);
        } else {
          newItems.add(CartItem(
            productId: event.productId,
            variantName: event.variantName,
            quantity: event.quantity,
            snapshot: event.snapshot,
          ));
        }
        // emit(CartLoaded(
        //     items: newItems,
        //     breakdown: calculateBreakdownUseCase(items: newItems)));
      }
      final result = await addToCartUseCase(
          event.productId, event.variantName, event.quantity);
      result.fold((failure) => add(_CartError(failure.message)), (_) => null);
    });

    on<UpdateQuantity>((event, emit) async {
      if (state is CartLoaded) {
        final current = state as CartLoaded;
        final index = current.items.indexWhere((item) =>
            item.productId == event.productId &&
            item.variantName == event.variantName);
        if (index != -1) {
          List<CartItem> newItems = List.from(current.items);
          newItems[index] =
              newItems[index].copyWith(quantity: event.newQuantity);
          emit(CartLoaded(
              items: newItems,
              breakdown: calculateBreakdownUseCase(items: newItems)));
        }
      }
      final result = await updateQuantityUseCase(
          event.productId, event.variantName, event.newQuantity);
      result.fold((failure) => add(_CartError(failure.message)), (_) => null);
    });

    on<RemoveFromCart>((event, emit) async {
      if (state is CartLoaded) {
        final current = state as CartLoaded;
        final newItems = current.items
            .where((item) => !(item.productId == event.productId &&
                item.variantName == event.variantName))
            .toList();
        emit(CartLoaded(
            items: newItems,
            breakdown: calculateBreakdownUseCase(items: newItems)));
      }
      final result =
          await removeFromCartUseCase(event.productId, event.variantName);
      result.fold((failure) => add(_CartError(failure.message)), (_) => null);
    });

    on<ClearCart>((event, emit) async {
      emit(CartLoaded(
          items: [], breakdown: calculateBreakdownUseCase(items: [])));
      final result = await clearCartUseCase();
      result.fold((failure) => add(_CartError(failure.message)), (_) => null);
    });

    on<CartUpdated>((event, emit) {
      emit(CartLoaded(
          items: event.items,
          breakdown: calculateBreakdownUseCase(items: event.items)));
    });

    on<_CartError>((event, emit) {
      emit(CartError(event.message));
    });
  }

  @override
  Future<void> close() {
    _cartSubscription.cancel();
    return super.close();
  }
}
