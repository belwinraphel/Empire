import 'package:empire/feature/cart/domain/entities/cart_entities.dart';
import 'package:empire/feature/payment/domain/entity/Payment_entity.dart';
import 'package:empire/feature/payment/domain/usecase/Payment_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object> get props => [];
}

class ValidateCartEvent extends CheckoutEvent {
  final List<CartItem> cartItems;

  const ValidateCartEvent(this.cartItems);

  @override
  List<Object> get props => [cartItems];
}

class CreateOrderEvent extends CheckoutEvent {
  final OrderEntity order;

  const CreateOrderEvent(this.order);

  @override
  List<Object> get props => [order];
}

class CreatePaymentIntentEvent extends CheckoutEvent {
  final OrderEntity order;
  const CreatePaymentIntentEvent({required this.order});
  @override
  List<Object> get props => [order];
}

class ConfirmPaymentEvent extends CheckoutEvent {
  final OrderEntity order;
  final PaymentIntentEntity paymentIntent;
  const ConfirmPaymentEvent({required this.order, required this.paymentIntent});
  @override
  List<Object> get props => [order, paymentIntent];
}

class ProcessPaymentEvent extends CheckoutEvent {
  final OrderEntity order;

  const ProcessPaymentEvent({required this.order});

  @override
  List<Object> get props => [order];
}

class RetryPaymentEvent extends CheckoutEvent {
  final OrderEntity order;

  const RetryPaymentEvent(this.order);

  @override
  List<Object> get props => [order];
}

class ResetCheckoutEvent extends CheckoutEvent {}

abstract class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object> get props => [];
}

class CheckoutInitial extends CheckoutState {}

class CheckoutLoading extends CheckoutState {
  final String message;

  const CheckoutLoading({required this.message});

  @override
  List<Object> get props => [message];
}

class CartValidated extends CheckoutState {
  final List<CartItem> validatedItems;

  const CartValidated(this.validatedItems);

  @override
  List<Object> get props => [validatedItems];
}

class PaymentReady extends CheckoutState {
  final OrderEntity order;
  final PaymentIntentEntity paymentIntent;

  const PaymentReady({
    required this.order,
    required this.paymentIntent,
  });

  @override
  List<Object> get props => [order, paymentIntent];
}

class PaymentSuccess extends CheckoutState {
  final OrderEntity order;

  const PaymentSuccess(this.order);

  @override
  List<Object> get props => [order];
}

class PaymentFailed extends CheckoutState {
  final OrderEntity order;
  final PaymentIntentEntity paymentIntent;
  final String errorMessage;

  const PaymentFailed({
    required this.order,
    required this.paymentIntent,
    required this.errorMessage,
  });

  @override
  List<Object> get props => [order, paymentIntent, errorMessage];
}

class CheckoutError extends CheckoutState {
  final String message;

  const CheckoutError(this.message);

  @override
  List<Object> get props => [message];
}

class CheckoutPayBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final ValidateCartItems validateCartItems;
  final CreateOrder createOrder;
  final CreatePaymentIntent createPaymentIntent;
  final ProcessPayment processPayment;
  final HandleSuccessfulPayment handleSuccessfulPayment;
  final HandleFailedPayment handleFailedPayment;
  final CanRetryPayment canRetryPayment;
  final GetOrder getOrder;

  CheckoutPayBloc({
    required this.validateCartItems,
    required this.createOrder,
    required this.createPaymentIntent,
    required this.processPayment,
    required this.handleSuccessfulPayment,
    required this.handleFailedPayment,
    required this.canRetryPayment,
    required this.getOrder,
  }) : super(CheckoutInitial()) {
    on<ValidateCartEvent>(_onValidateCart);
    on<CreateOrderEvent>(_onCreateOrder);
    // Updated event handlers
    on<CreatePaymentIntentEvent>(_onCreatePaymentIntent);
    on<ConfirmPaymentEvent>(_onConfirmPayment);
    on<RetryPaymentEvent>(_onRetryPayment);
    on<ResetCheckoutEvent>(_onResetCheckout);
  }

  Future<void> _onValidateCart(
    ValidateCartEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(const CheckoutLoading(message: 'Validating cart items...'));
    final result = await validateCartItems(event.cartItems);
    result.fold(
      (failure) => emit(CheckoutError(failure.message)),
      (validatedItems) => emit(CartValidated(validatedItems)),
    );
  }

  Future<void> _onCreateOrder(
    CreateOrderEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(const CheckoutLoading(message: 'Creating order...'));
    final result = await createOrder(event.order);
    result.fold(
      (failure) => emit(CheckoutError(failure.message)),
   
      (order) => add(CreatePaymentIntentEvent(order: order)),
    );
  }

 
  Future<void> _onCreatePaymentIntent(
    CreatePaymentIntentEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(const CheckoutLoading(message: 'Preparing payment...'));

    final paymentIntentResult = await createPaymentIntent(
      event.order.totalAmount,
      event.order.currency,
    );

    paymentIntentResult.fold(
      (failure) async {
       
        await handleFailedPayment(event.order.orderId);
        emit(CheckoutError(failure.message));
      },
      (paymentIntent) {
 
        emit(PaymentReady(
          order: event.order,
          paymentIntent: paymentIntent,
        ));
      },
    );
  }

 
  Future<void> _onConfirmPayment(
    ConfirmPaymentEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(const CheckoutLoading(message: 'Processing payment...'));

    try {
 
      final resultPayment = await processPayment(
        event.paymentIntent.paymentIntentId,
        event.paymentIntent,
      );

      await resultPayment.fold(
        (paymentFailure) async {
    
          await handleFailedPayment(event.order.orderId);
          emit(PaymentFailed(
            order: event.order,
            paymentIntent: event.paymentIntent,  
            errorMessage: paymentFailure.message,
          ));
        },
        (_) async {
 
          emit(const CheckoutLoading(message: 'Finalizing order...'));

        
          final result = await handleSuccessfulPayment(
            event.order.orderId,
            event.paymentIntent.paymentIntentId,
          );

          result.fold(
            (finalizingFailure) {
      
              emit(CheckoutError(finalizingFailure.message));
            },
            (__) => emit(PaymentSuccess(event.order)),  
          );
        },
      );
    } catch (e) {
      await handleFailedPayment(event.order.orderId);
      emit(PaymentFailed(
        order: event.order,
        paymentIntent: event.paymentIntent,
        errorMessage: 'Payment processing failed: $e',
      ));
    }
  }

 
  Future<void> _onRetryPayment(
    RetryPaymentEvent event,
    Emitter<CheckoutState> emit,
  ) async {
   
    if (state is! PaymentFailed) {
      emit(const CheckoutError('No payment to retry.'));
      return;
    }

    final currentState = state as PaymentFailed;
    emit(const CheckoutLoading(message: 'Checking retry eligibility...'));

    final canRetryResult = await canRetryPayment(currentState.order.orderId);

    await canRetryResult.fold(
      (failure) async => emit(CheckoutError(failure.message)),
      (canRetry) async {
        if (!canRetry) {
          emit(const CheckoutError(
              'Maximum payment retries exceeded. Please create a new order.'));
          return;
        }
 
        add(ConfirmPaymentEvent(
          order: currentState.order,
          paymentIntent: currentState.paymentIntent,
        ));
      },
    );
  }

  void _onResetCheckout(
    ResetCheckoutEvent event,
    Emitter<CheckoutState> emit,
  ) {
    emit(CheckoutInitial());
  }
}
