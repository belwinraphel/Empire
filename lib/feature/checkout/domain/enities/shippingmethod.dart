import 'package:equatable/equatable.dart';

class ShippingMethod extends Equatable {
  final String id;
  final String name;
  final int costCents;
  final bool isDynamic;
  final int perKgCents; // If dynamic

  const ShippingMethod({
    required this.id,
    required this.name,
    required this.costCents,
    this.isDynamic = false,
    this.perKgCents = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'costCents': costCents,
      'isDynamic': isDynamic,
      'perKgCents': perKgCents,
    };
  }

  @override
  List<Object> get props => [id, name, costCents, isDynamic, perKgCents];
}