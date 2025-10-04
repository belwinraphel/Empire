import 'dart:async';
import 'package:uuid/uuid.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:empire/feature/cart/domain/entities/cart_entities.dart';
import 'package:empire/feature/cart/domain/entities/order_breakdown.dart';
import 'package:empire/feature/cart/domain/usecase/breakdown_usecase.dart';
import 'package:empire/feature/checkout/domain/enities/addres.dart';
import 'package:empire/feature/checkout/domain/enities/checkout.dart';
import 'package:empire/feature/checkout/domain/enities/payment.dart';
import 'package:empire/feature/checkout/domain/enities/shippingmethod.dart';
import 'package:empire/feature/checkout/domain/usecase/applycoupon_usecase.dart';
import 'package:empire/feature/checkout/domain/usecase/get_address_usecase.dart';
import 'package:empire/feature/checkout/domain/usecase/getpaymentmethod_usecase.dart';
import 'package:empire/feature/checkout/domain/usecase/getshippingmethod_usecase.dart';
import 'package:empire/feature/checkout/domain/usecase/submit_checkout_usecase.dart';
import 'package:empire/feature/checkout/domain/enities/coupon.dart';

abstract class CheckoutState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CheckoutInitial extends CheckoutState {}

class CheckoutLoading extends CheckoutState {}

class CheckoutLoaded extends CheckoutState {
  final CheckoutData data;
  final List<Address> addresses;
  final List<ShippingMethod> shippingMethods;
  final List<PaymentMethod> paymentMethods;

  CheckoutLoaded({
    required this.data,
    required this.addresses,
    required this.shippingMethods,
    required this.paymentMethods,
  });

  CheckoutLoaded copyWith({
    CheckoutData? data,
  }) {
    return CheckoutLoaded(
      data: data ?? this.data,
      addresses: addresses,
      shippingMethods: shippingMethods,
      paymentMethods: paymentMethods,
    );
  }

  @override
  List<Object?> get props => [data, addresses, shippingMethods, paymentMethods];
}

class CheckoutSuccess extends CheckoutState {
  final String orderId;

  CheckoutSuccess(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class CheckoutFailure extends CheckoutState {
  final String message;

  CheckoutFailure(this.message);

  @override
  List<Object?> get props => [message];
}

abstract class CheckoutEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitializeCheckout extends CheckoutEvent {
  final List<CartItem> items;
  final OrderBreakdown initialBreakdown;

  InitializeCheckout(this.items, this.initialBreakdown);

  @override
  List<Object?> get props => [items, initialBreakdown];
}

class SelectAddress extends CheckoutEvent {
  final Address address;

  SelectAddress(this.address);

  @override
  List<Object?> get props => [address];
}

class SelectShippingMethod extends CheckoutEvent {
  final ShippingMethod shippingMethod;

  SelectShippingMethod(this.shippingMethod);

  @override
  List<Object?> get props => [shippingMethod];
}

class SelectPaymentMethod extends CheckoutEvent {
  final PaymentMethod paymentMethod;

  SelectPaymentMethod(this.paymentMethod);

  @override
  List<Object?> get props => [paymentMethod];
}

class ApplyCoupon extends CheckoutEvent {
  final String code;

  ApplyCoupon(this.code);

  @override
  List<Object?> get props => [code];
}

class UpdateTip extends CheckoutEvent {
  final int tipCents;

  UpdateTip(this.tipCents);

  @override
  List<Object?> get props => [tipCents];
}

class SubmitCheckout extends CheckoutEvent {}

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final GetAddressesUseCase getAddressesUseCase;
  final GetShippingMethodsUseCase getShippingMethodsUseCase;
  final GetPaymentMethodsUseCase getPaymentMethodsUseCase;
  final ApplyCouponUseCase applyCouponUseCase;
  final SubmitCheckoutUseCase submitCheckoutUseCase;
  final CalculateBreakdownUseCase calculateBreakdownUseCase;

  CheckoutBloc({
    required this.getAddressesUseCase,
    required this.getShippingMethodsUseCase,
    required this.getPaymentMethodsUseCase,
    required this.applyCouponUseCase,
    required this.submitCheckoutUseCase,
    required this.calculateBreakdownUseCase,
  }) : super(CheckoutInitial()) {
    on<InitializeCheckout>(_onInitialize);
    on<SelectAddress>(_onSelectAddress);
    on<SelectShippingMethod>(_onSelectShipping);
    on<SelectPaymentMethod>(_onSelectPayment);
    on<ApplyCoupon>(_onApplyCoupon);
    on<UpdateTip>(_onUpdateTip);
    on<SubmitCheckout>(_onSubmit);
  }

  Future<void> _onInitialize(
    InitializeCheckout event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(CheckoutLoading());

    try {
      final addresses = await getAddressesUseCase();
      final shippingMethods = await getShippingMethodsUseCase(event.items);
      final paymentMethods = await getPaymentMethodsUseCase();

      final addrList = addresses.fold(
        (failure) {
          emit(CheckoutFailure(failure.message));
          return null;
        },
        (list) => list,
      );
      if (addrList == null) return;

      final shipList = shippingMethods.fold(
        (failure) {
          emit(CheckoutFailure(failure.message));
          return null;
        },
        (list) => list,
      );
      if (shipList == null) return;

      final payList = paymentMethods.fold(
        (failure) {
          emit(CheckoutFailure(failure.message));
          return null;
        },
        (list) => list,
      );
      if (payList == null) return;

      final data = CheckoutData(
        items: event.items,
        breakdown: event.initialBreakdown,
        walletBalanceCents: 0,
      );

      emit(CheckoutLoaded(
        data: data,
        addresses: addrList,
        shippingMethods: shipList,
        paymentMethods: payList,
      ));
    } catch (e) {
      emit(CheckoutFailure('Failed to initialize checkout: ${e.toString()}'));
    }
  }

  void _onSelectAddress(SelectAddress event, Emitter<CheckoutState> emit) {
    final current = state;
    if (current is! CheckoutLoaded) return;

    final newData = current.data.copyWith(address: event.address);
    final newBreakdown = _calculateBreakdown(newData);

    emit(current.copyWith(
      data: newData.copyWith(breakdown: newBreakdown),
    ));
  }

  void _onSelectShipping(
    SelectShippingMethod event,
    Emitter<CheckoutState> emit,
  ) {
    final current = state;
    if (current is! CheckoutLoaded) return;

    final newData = current.data.copyWith(shippingMethod: event.shippingMethod);
    final newBreakdown = _calculateBreakdown(newData);

    emit(current.copyWith(
      data: newData.copyWith(breakdown: newBreakdown),
    ));
  }

  void _onSelectPayment(
    SelectPaymentMethod event,
    Emitter<CheckoutState> emit,
  ) {
    final current = state;
    if (current is! CheckoutLoaded) return;

    emit(current.copyWith(
      data: current.data.copyWith(paymentMethod: event.paymentMethod),
    ));
  }

  Future<void> _onApplyCoupon(
    ApplyCoupon event,
    Emitter<CheckoutState> emit,
  ) async {
    final current = state;
    if (current is! CheckoutLoaded) return;

    emit(CheckoutLoading());

    final result = await applyCouponUseCase(event.code, current.data.items);

    result.fold(
      (failure) => emit(CheckoutFailure(failure.message)),
      (coupon) {
        final newData = current.data.copyWith(coupon: coupon);
        final newBreakdown = _calculateBreakdown(newData);
        emit(current.copyWith(
          data: newData.copyWith(breakdown: newBreakdown),
        ));
      },
    );
  }

  void _onUpdateTip(UpdateTip event, Emitter<CheckoutState> emit) {
    final current = state;
    if (current is! CheckoutLoaded) return;

    final newData = current.data.copyWith(tipCents: event.tipCents);
    final newBreakdown = _calculateBreakdown(newData);

    emit(current.copyWith(
      data: newData.copyWith(breakdown: newBreakdown),
    ));
  }

  Future<void> _onSubmit(
    SubmitCheckout event,
    Emitter<CheckoutState> emit,
  ) async {
    final current = state;
    if (current is! CheckoutLoaded) return;

    if (current.data.address == null ||
        current.data.shippingMethod == null ||
        current.data.paymentMethod == null) {
      emit(CheckoutFailure('Missing fields'));
      return;
    }

    emit(CheckoutLoading());

    final key = const Uuid().v4();
    final result = await submitCheckoutUseCase(
      items: current.data.items,
      address: current.data.address!,
      shippingMethod: current.data.shippingMethod!,
      paymentMethod: current.data.paymentMethod!,
      coupon: current.data.coupon,
      tipCents: current.data.tipCents,
      walletAppliedCents: current.data.breakdown.subtotal,
      idempotencyKey: key,
    );

    result.fold(
      (failure) => emit(CheckoutFailure(failure.message)),
      (orderId) => emit(CheckoutSuccess(orderId)),
    );
  }

  OrderBreakdown _calculateBreakdown(CheckoutData data) {
    return calculateBreakdownUseCase(
      items: data.items,
      orderDiscountCents: data.coupon?.discountCents ?? 0,
      shippingFlatCents: data.shippingMethod?.costCents ?? 0,
      shippingPerKgCents: data.shippingMethod?.perKgCents ?? 0,
      tipCents: data.tipCents,
      walletBalanceCents: data.walletBalanceCents,
    );
  }
}
