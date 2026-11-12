import '../models/city_model.dart';
import '../models/weather_model.dart';
import '../services/weather_api_client.dart';

abstract class WeatherRepository {
  Future<WeatherForecast> getWeather(CityModel city);
  Future<List<CityModel>> searchCities(String query);
}

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherApiClient _apiClient;

  WeatherRepositoryImpl({WeatherApiClient? apiClient})
      : _apiClient = apiClient ?? WeatherApiClient();

  @override
  Future<WeatherForecast> getWeather(CityModel city) =>
      _apiClient.fetchWeatherForecast(city: city);

  @override
  Future<List<CityModel>> searchCities(String query) =>
      _apiClient.searchCities(query);
}
