import 'package:equatable/equatable.dart';

class Address extends Equatable {
  final String id;
  final String street;
  final String city;
  final String state;
  final String country;
  final String zipCode;

  const Address({
    required this.id,
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.zipCode,
  });

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      id: map['id'] ?? '',
      street: map['street'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      country: map['country'] ?? '',
      zipCode: map['zipCode'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'street': street,
      'city': city,
      'state': state,
      'country': country,
      'zipCode': zipCode,
    };
  }

  @override
  List<Object> get props => [id, street, city, state, country, zipCode];
}