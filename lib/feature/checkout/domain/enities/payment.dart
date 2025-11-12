import 'package:equatable/equatable.dart';

class PaymentMethod extends Equatable {
  final String id;
  final String type;
  final String last4;

  const PaymentMethod({
    required this.id,
    required this.type,
    required this.last4,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'last4': last4,
    };
  }

  @override
  List<Object> get props => [id, type, last4];
}