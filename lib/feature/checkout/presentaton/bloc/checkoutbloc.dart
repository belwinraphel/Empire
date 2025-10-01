import 'dart:async';

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
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

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
  }) : super(CheckoutInitial());

  @override
  Stream<CheckoutState> mapEventToState(CheckoutEvent event) async* {
    if (event is InitializeCheckout) {
      yield CheckoutLoading();
      final addresses = await getAddressesUseCase();
      final shippingMethods = await getShippingMethodsUseCase(event.items);
      final paymentMethods = await getPaymentMethodsUseCase();

      final data = CheckoutData(
          items: event.items,
          breakdown: event.initialBreakdown,
          walletBalanceCents: 0);
      yield addresses.fold(
        (failure) => CheckoutFailure(failure.message),
        (addrList) => shippingMethods.fold(
          (failure) => CheckoutFailure(failure.message),
          (shipList) => paymentMethods.fold(
            (failure) => CheckoutFailure(failure.message),
            (payList) => CheckoutLoaded(
              data: data,
              addresses: addrList,
              shippingMethods: shipList,
              paymentMethods: payList,
            ),
          ),
        ),
      );
    } else if (event is SelectAddress) {
      if (state is CheckoutLoaded) {
        final current = state as CheckoutLoaded;
        final newData = current.data.copyWith(address: event.address);
        final newBreakdown = _calculateBreakdown(newData);
        yield current.copyWith(data: newData.copyWith(breakdown: newBreakdown));
      }
    } else if (event is SelectShippingMethod) {
      if (state is CheckoutLoaded) {
        final current = state as CheckoutLoaded;
        final newData =
            current.data.copyWith(shippingMethod: event.shippingMethod);
        final newBreakdown = _calculateBreakdown(newData);
        yield current.copyWith(data: newData.copyWith(breakdown: newBreakdown));
      }
    } else if (event is SelectPaymentMethod) {
      if (state is CheckoutLoaded) {
        final current = state as CheckoutLoaded;
        final newData =
            current.data.copyWith(paymentMethod: event.paymentMethod);
        yield current.copyWith(data: newData);
      }
    } else if (event is ApplyCoupon) {
      if (state is CheckoutLoaded) {
        yield CheckoutLoading();
        final result = await applyCouponUseCase(
            event.code, (state as CheckoutLoaded).data.items);
        yield result.fold(
          (failure) => CheckoutFailure(failure.message),
          (coupon) {
            final current = state as CheckoutLoaded;
            final newData = current.data.copyWith(coupon: coupon);
            final newBreakdown = _calculateBreakdown(newData);
            return current.copyWith(
                data: newData.copyWith(breakdown: newBreakdown));
          },
        );
      }
    } else if (event is UpdateTip) {
      if (state is CheckoutLoaded) {
        final current = state as CheckoutLoaded;
        final newData = current.data.copyWith(tipCents: event.tipCents);
        final newBreakdown = _calculateBreakdown(newData);
        yield current.copyWith(data: newData.copyWith(breakdown: newBreakdown));
      }
    } else if (event is SubmitCheckout) {
      if (state is CheckoutLoaded) {
        final current = state as CheckoutLoaded;
        if (current.data.address == null ||
            current.data.shippingMethod == null ||
            current.data.paymentMethod == null) {
          yield CheckoutFailure('Missing fields');
          return;
        }
        yield CheckoutLoading();
        final key = const Uuid().v4();
        final result = await submitCheckoutUseCase(
          items: current.data.items,
          address: current.data.address!,
          shippingMethod: current.data.shippingMethod!,
          paymentMethod: current.data.paymentMethod!,
          coupon: current.data.coupon,
          tipCents: current.data.tipCents,
          walletAppliedCents: current.data.breakdown.walletAppliedCents,
          idempotencyKey: key,
        );
        yield result.fold(
          (failure) => CheckoutFailure(failure.message),
          (orderId) => CheckoutSuccess(orderId),
        );
      }
    }
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
