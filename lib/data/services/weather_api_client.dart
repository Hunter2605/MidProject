import 'package:dio/dio.dart';
import '../models/city_model.dart';
import '../models/weather_model.dart';

class WeatherApiClient {
  final Dio _dio;

  static const String _geocodingUrl = 'https://geocoding-api.open-meteo.com/v1/search';
  static const String _forecastUrl = 'https://api.open-meteo.com/v1/forecast';

  WeatherApiClient({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
              ),
            );

  Future<List<CityModel>> searchCities(String cityName) async {
    final query = cityName.trim();
    if (query.isEmpty) return [];

    try {
      final response = await _dio.get(
        _geocodingUrl,
        queryParameters: {
          'name': query,
          'count': 5,
          'language': 'ru',
          'format': 'json',
        },
      );

      final data = response.data;
      if (data is Map<String, dynamic> && data['results'] != null) {
        final results = data['results'] as List<dynamic>;
        return results
            .map((item) => CityModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<WeatherForecast> fetchWeatherForecast({required CityModel city}) async {
    try {
      final response = await _dio.get(
        _forecastUrl,
        queryParameters: {
          'latitude': city.latitude,
          'longitude': city.longitude,
          'current': 'temperature_2m,relative_humidity_2m,apparent_temperature,weather_code,wind_speed_10m',
          'hourly': 'temperature_2m,weather_code',
          'daily': 'weather_code,temperature_2m_max,temperature_2m_min',
          'timezone': 'auto',
        },
      );

      return WeatherForecast.fromJson(
        json: response.data as Map<String, dynamic>,
        city: city,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return Exception('Таймаут соединения. Проверьте интернет.');
      case DioExceptionType.connectionError:
        return Exception('Нет подключения к интернету.');
      case DioExceptionType.badResponse:
        return Exception('Ошибка сервера: ${error.response?.statusCode}');
      default:
        return Exception('Не удалось загрузить данные погоды.');
    }
  }
}
