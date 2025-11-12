class MainAddress {
  final String id;
  final String label;
  final String fullAddress;
  final double latitude;
  final double longitude;
  final bool isDefault;

  const MainAddress({
    required this.id,
    required this.label,
    required this.fullAddress,
    required this.latitude,
    required this.longitude,
    this.isDefault = false,
  });

  MainAddress copyWith({
    String? id,
    String? label,
    String? fullAddress,
    double? latitude,
    double? longitude,
    bool? isDefault,
  }) {
    return MainAddress(
      id: id ?? this.id,
      label: label ?? this.label,
      fullAddress: fullAddress ?? this.fullAddress,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'fullAddress': fullAddress,
      'latitude': latitude,
      'longitude': longitude,
      'isDefault': isDefault,
    };
  }

  factory MainAddress.fromJson(Map<String, dynamic> json) {
    return MainAddress(
      id: json['id'],
      label: json['label'],
      fullAddress: json['fullAddress'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      isDefault: json['isDefault'] ?? false,
    );
  }
}
