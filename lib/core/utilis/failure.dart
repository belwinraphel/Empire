import 'package:equatable/equatable.dart';

class Failures extends Equatable {
  final String message;
  final String type;

  const Failures._(this.message, this.type);

  const Failures.network(String message) : this._(message, 'networ');
  const Failures.validation(String message) : this._(message, 'validation');
  const Failures.server(String message) : this._(message, 'server');
   const Failures.outofstock(String message) : this._(message, 'Outofstock');


  @override
  List<Object?> get props => [message, type];
}
