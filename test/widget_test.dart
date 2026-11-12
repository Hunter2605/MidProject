import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/data/models/city_model.dart';
import 'package:weather_app/data/models/weather_model.dart';
import 'package:weather_app/presentation/widgets/weather_icon_helper.dart';

void main() {
  test('default city is Bishkek', () {
    final city = CityModel.defaultCity();
    expect(city.name, 'Бишкек');
    expect(city.country, 'Кыргызстан');
    expect(city.countryCode, 'KG');
  });

  test('parses CityModel from json', () {
    final json = {
      'id': 1518049,
      'name': 'Бишкек',
      'latitude': 42.87,
      'longitude': 74.59,
      'country': 'Кыргызстан',
      'country_code': 'KG',
      'admin1': 'Бишкек',
    };

    final city = CityModel.fromJson(json);
    expect(city.id, 1518049);
    expect(city.name, 'Бишкек');
    expect(city.country, 'Кыргызстан');
  });

  test('parses WeatherForecast correctly', () {
    final mockJson = {
      'current': {
        'time': '2026-11-12T12:00',
        'temperature_2m': 14.5,
        'apparent_temperature': 13.0,
        'relative_humidity_2m': 55,
        'weather_code': 1,
        'wind_speed_10m': 7.2,
      },
      'hourly': {
        'time': ['2026-11-12T12:00', '2026-11-12T13:00'],
        'temperature_2m': [14.5, 15.0],
        'weather_code': [1, 2],
      },
      'daily': {
        'time': ['2026-11-12', '2026-11-13'],
        'weather_code': [1, 3],
        'temperature_2m_max': [16.0, 14.0],
        'temperature_2m_min': [4.0, 5.0],
      },
    };

    final city = CityModel.defaultCity();
    final forecast = WeatherForecast.fromJson(json: mockJson, city: city);

    expect(forecast.city.name, 'Бишкек');
    expect(forecast.current.temperature, 14.5);
    expect(forecast.hourly.length, 2);
    expect(forecast.daily.length, 2);
  });

  test('WeatherIconHelper returns descriptions', () {
    expect(WeatherIconHelper.getDescription(0), 'Ясно');
    expect(WeatherIconHelper.getDescription(3), 'Пасмурно');
    expect(WeatherIconHelper.getDescription(61), 'Дождь');
  });
}
