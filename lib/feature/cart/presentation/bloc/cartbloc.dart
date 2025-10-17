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
  List<Object?> get props => [];
}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;
  final OrderBreakdown breakdown;
  final String? errorMessage;

  CartLoaded({required this.items, required this.breakdown, this.errorMessage});
  CartLoaded copyWith({
    List<CartItem>? items,
    OrderBreakdown? breakdown,
    String? errorMessage,
  }) {
    return CartLoaded(
      items: items ?? this.items,
      breakdown: breakdown ?? this.breakdown,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [items, breakdown, errorMessage];
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

class LoadCart extends CartEvent {}

class AddToCart extends CartEvent {
  final String productId;
  final String variantName;
  final String productname;
  final int quantity;
  final VariantSnapshot? snapshot;

  AddToCart(this.productId, this.variantName, this.quantity,this.productname, {this.snapshot});

  @override
  List<Object?> get props => [productId, variantName, quantity, snapshot,productname];
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

class CartItemUpdating extends CartEvent {
  final List<CartItem> items;

  CartItemUpdating(this.items);

  @override
  List<Object> get props => [items];
}

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
  final GetCart getCart;
  final CalculateBreakdownUseCase calculateBreakdownUseCase;

  CartBloc({
    required this.addToCartUseCase,
    required this.updateQuantityUseCase,
    required this.removeFromCartUseCase,
    required this.clearCartUseCase,
    required this.getCart,
    required this.calculateBreakdownUseCase,
  }) : super(CartLoading()) {
    on<LoadCart>((event, emit) async {
      emit(CartLoading());
      try {
        final cart = await getCart();

        emit(CartLoaded(
          items: cart,
          breakdown: calculateBreakdownUseCase(items: cart),
        ));
      } catch (e) {
        emit(CartError(e.toString()));
      }
    });
    on<AddToCart>((event, emit) async {
      final currentState = state;
      if (currentState is CartLoaded) {
        emit(CartLoading());
      }

      final result = await addToCartUseCase(
          event.productId, event.variantName, event.quantity);

      result.fold(
        (failure) {
          if (currentState is CartLoaded) {
            emit(currentState.copyWith(errorMessage: failure.message));
          } else {
            emit(CartError(failure.message));
          }
        },
        (cart) => emit(CartLoaded(
            items: cart, breakdown: calculateBreakdownUseCase(items: cart))),
      );
    });

    on<UpdateQuantity>((event, emit) async {
      final currentState = state;
      if (currentState is CartLoaded) {
        emit(CartLoaded(
            items: currentState.items,
            breakdown: calculateBreakdownUseCase(items: currentState.items)));
      }
      final result = await updateQuantityUseCase(
          event.productId, event.variantName, event.newQuantity);
      result.fold(
        (failure) {
          if (currentState is CartLoaded) {
            emit(currentState.copyWith(errorMessage: failure.message));
          }
        },
        (cart) {
          emit(CartLoaded(
              items: cart, breakdown: calculateBreakdownUseCase(items: cart)));
        },
      );
    });

    on<RemoveFromCart>((event, emit) async {
      if (state is CartLoaded) {
        final current = state as CartLoaded;
        final newItems = current.items
            .where((item) => !(item.productId == event.productId &&
                item.varientName == event.variantName))
            .toList();

        emit(CartLoaded(
            items: newItems,
            breakdown: calculateBreakdownUseCase(items: newItems)));
      }

      final result =
          await removeFromCartUseCase(event.productId, event.variantName);
      result.fold((failure) => add(_CartError(failure.message)), (_) {
        add(LoadCart());
      });
    });

    on<ClearCart>((event, emit) async {
      emit(CartLoaded(
          items: const [], breakdown: calculateBreakdownUseCase(items: [])));
      final result = await clearCartUseCase();
      result.fold((failure) => add(_CartError(failure.message)), (_) => null);
    });

    on<_CartError>((event, emit) {
      emit(CartError(event.message));
    });
  }
}
