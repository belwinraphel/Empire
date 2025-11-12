import 'package:equatable/equatable.dart';

class Brand extends Equatable {
  final String imageUrl;
  final String label;
  final bool isActive;

  const Brand({
    required this.imageUrl,
    required this.label,
    this.isActive = false,
  });

  Map<String, dynamic> toJson() => {
    'imageUrl': imageUrl,
    'label': label,
    'isActive': isActive,
  };

  @override
  List<Object?> get props => [imageUrl, label, isActive];
}
