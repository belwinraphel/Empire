import 'dart:async';

import 'package:empire/feature/order/domain/entity/oder_entity.dart';
import 'package:empire/feature/order/domain/usecase/order_usecase.dart';
import 'package:empire/feature/order/domain/usecase/update_order_status_usecase.dart';
import 'package:empire/feature/order/domain/usecase/wacthorder_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object?> get props => [];
}

class LoadOrders extends OrdersEvent {
  const LoadOrders();

  @override
  List<Object?> get props => [];
}

class UpdateOrderstatus extends OrdersEvent {
  final String orderId;
  final String newStatus;

  const UpdateOrderstatus({required this.orderId, required this.newStatus});

  @override
  List<Object?> get props => [orderId, newStatus];
}

class ToggleOrderExpansion extends OrdersEvent {
  final String orderId;

  const ToggleOrderExpansion(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class WatchOrders extends OrdersEvent {
  const WatchOrders();

  @override
  List<Object?> get props => [];
}

class RefreshOrders extends OrdersEvent {
  const RefreshOrders();

  @override
  List<Object?> get props => [];
}

class OrdersUpdated extends OrdersEvent {
  final List<OrderEntity> orders;

  const OrdersUpdated(this.orders);

  @override
  List<Object?> get props => [orders];
}

abstract class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object?> get props => [];
}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersLoaded extends OrdersState {
  final List<OrderEntity> orders;
  final Map<String, bool> expandedOrders;

  const OrdersLoaded(this.orders, {this.expandedOrders = const {}});

  @override
  List<Object?> get props => [orders, expandedOrders];
}

class OrdersError extends OrdersState {
  final String message;

  const OrdersError(this.message);

  @override
  List<Object?> get props => [message];
}

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final Map<String, bool> _expandedOrders = {};

  final GetOrdersUseCase getOrdersUseCase;
  final WatchOrdersUseCase watchOrdersUseCase;
  StreamSubscription? _ordersSubscription;
  final updateOrderstatus updateOrderstatusUseCase;
  OrdersBloc({
    required this.getOrdersUseCase,
    required this.watchOrdersUseCase,
    required this.updateOrderstatusUseCase,
  }) : super(OrdersInitial()) {
    on<LoadOrders>(_onLoadOrders);
    on<WatchOrders>(_onWatchOrders);
    on<RefreshOrders>(_onRefreshOrders);
    on<OrdersUpdated>(_onOrdersUpdated);
    on<UpdateOrderstatus>(_onUpdateOrderStatus);
    on<ToggleOrderExpansion>(_onToggleOrderExpansion);
  }

  Future<void> _onLoadOrders(
    LoadOrders event,
    Emitter<OrdersState> emit,
  ) async {
    emit(OrdersLoading());

    final result = await getOrdersUseCase();

    result.fold(
      (failure) => emit(OrdersError(failure.message)),
      (orders) => emit(OrdersLoaded(orders)),
    );
  }

  Future<void> _onUpdateOrderStatus(
    UpdateOrderstatus event,
    Emitter<OrdersState> emit,
  ) async {
    final result = await updateOrderstatusUseCase(
      event.orderId,
      event.newStatus,
    );

    result.fold((failure) => emit(OrdersError(failure.message)), (_) {
      add(const RefreshOrders());
    });
  }

  Future<void> _onWatchOrders(
    WatchOrders event,
    Emitter<OrdersState> emit,
  ) async {
    emit(OrdersLoading());

    await _ordersSubscription?.cancel();

    _ordersSubscription = watchOrdersUseCase().listen((result) {
      result.fold(
        (failure) => add(const OrdersUpdated([])),
        (orders) => add(OrdersUpdated(orders)),
      );
    });
  }

  void _onToggleOrderExpansion(
    ToggleOrderExpansion event,
    Emitter<OrdersState> emit,
  ) {
    if (state is OrdersLoaded) {
      final currentState = state as OrdersLoaded;
      final updatedExpanded = Map<String, bool>.from(_expandedOrders);

      // toggle expansion for this order
      updatedExpanded[event.orderId] =
          !(updatedExpanded[event.orderId] ?? false);
      _expandedOrders
        ..clear()
        ..addAll(updatedExpanded);

      emit(OrdersLoaded(currentState.orders, expandedOrders: updatedExpanded));
    }
  }

  Future<void> _onRefreshOrders(
    RefreshOrders event,
    Emitter<OrdersState> emit,
  ) async {
    final result = await getOrdersUseCase();

    result.fold(
      (failure) => emit(OrdersError(failure.message)),
      (orders) => emit(OrdersLoaded(orders)),
    );
  }

  void _onOrdersUpdated(OrdersUpdated event, Emitter<OrdersState> emit) {
    emit(OrdersLoaded(event.orders));
  }

  @override
  Future<void> close() {
    _ordersSubscription?.cancel();
    return super.close();
  }
}
