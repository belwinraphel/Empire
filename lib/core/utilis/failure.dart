import 'package:equatable/equatable.dart';

class Failures extends Equatable {
  final String message;
  final String type;

  const Failures._(this.message, this.type);
  const Failures.messange(String message) : this._(message, 'erro');

  const Failures.network(String message) : this._(message, 'networ');
  const Failures.emailexisted(String message)
      : this._(message, 'email already registed');
  const Failures.validation(String message) : this._(message, 'validation');
  const Failures.server(String message) : this._(message, 'server');
  const Failures.outofstock(String message) : this._(message, 'Outofstock');
  const Failures.paymentFailure(String message)
      : this._(message, 'PaymentFailure');
  const Failures.cancelled(String message)
      : this._(message, 'PaymentCancelled');
  const Failures.timeout(String message) : this._(message, 'timeout');
  const Failures.unexpected(String message) : this._(message, 'unexpected');

  /////////google signing errors
  const Failures.authFailure(String message) : this._(message, 'authFailure ');
  /////////firestoreFailure
  const Failures.firestoreFailure(String message)
      : this._(message, 'firestoreFailure ');
  /////////unexpectedFailure
  const Failures.platformFailure(String message)
      : this._(message, 'platformFailure ');
  /////////unexpectedFailure
  const Failures.unexpectedFailure(String message)
      : this._(message, 'unexpectedFailure ');

  @override
  List<Object?> get props => [message, type];
}
