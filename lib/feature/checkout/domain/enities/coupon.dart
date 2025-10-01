import 'package:equatable/equatable.dart';

class Coupon extends Equatable {
  final String code;
  final int discountCents;

  const Coupon({
    required this.code,
    required this.discountCents,
  });

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'discountCents': discountCents,
    };
  }

  @override
  List<Object> get props => [code, discountCents];
}