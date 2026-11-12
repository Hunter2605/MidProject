import 'package:equatable/equatable.dart';

class CityModel extends Equatable {
  final int? id;
  final String name;
  final double latitude;
  final double longitude;
  final String country;
  final String? countryCode;
  final String? admin1;

  const CityModel({
    this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.country,
    this.countryCode,
    this.admin1,
  });

  factory CityModel.defaultCity() {
    return const CityModel(
      id: 1518049,
      name: 'Бишкек',
      latitude: 42.8746,
      longitude: 74.5698,
      country: 'Кыргызстан',
      countryCode: 'KG',
      admin1: 'Бишкек',
    );
  }

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'] as int?,
      name: (json['name'] ?? '') as String,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      country: (json['country'] ?? '') as String,
      countryCode: json['country_code'] as String?,
      admin1: json['admin1'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'country': country,
      'country_code': countryCode,
      'admin1': admin1,
    };
  }

  String get displayName {
    if (admin1 != null && admin1!.isNotEmpty && admin1 != name) {
      return '$name, $admin1, $country';
    }
    return country.isNotEmpty ? '$name, $country' : name;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        latitude,
        longitude,
        country,
        countryCode,
        admin1,
      ];
}
