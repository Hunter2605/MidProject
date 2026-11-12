import 'package:equatable/equatable.dart';
import 'city_model.dart';

class CurrentWeather extends Equatable {
  final DateTime time;
  final double temperature;
  final double apparentTemperature;
  final int humidity;
  final int weatherCode;
  final double windSpeed;

  const CurrentWeather({
    required this.time,
    required this.temperature,
    required this.apparentTemperature,
    required this.humidity,
    required this.weatherCode,
    required this.windSpeed,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      time: DateTime.tryParse(json['time']?.toString() ?? '') ?? DateTime.now(),
      temperature: (json['temperature_2m'] as num?)?.toDouble() ?? 0.0,
      apparentTemperature: (json['apparent_temperature'] as num?)?.toDouble() ?? 0.0,
      humidity: (json['relative_humidity_2m'] as num?)?.round() ?? 0,
      weatherCode: (json['weather_code'] as num?)?.toInt() ?? 0,
      windSpeed: (json['wind_speed_10m'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  List<Object?> get props => [
        time,
        temperature,
        apparentTemperature,
        humidity,
        weatherCode,
        windSpeed,
      ];
}

class HourlyWeather extends Equatable {
  final DateTime time;
  final double temperature;
  final int weatherCode;

  const HourlyWeather({
    required this.time,
    required this.temperature,
    required this.weatherCode,
  });

  @override
  List<Object?> get props => [time, temperature, weatherCode];
}

class DailyWeather extends Equatable {
  final DateTime date;
  final int weatherCode;
  final double maxTemperature;
  final double minTemperature;

  const DailyWeather({
    required this.date,
    required this.weatherCode,
    required this.maxTemperature,
    required this.minTemperature,
  });

  @override
  List<Object?> get props => [date, weatherCode, maxTemperature, minTemperature];
}

class WeatherForecast extends Equatable {
  final CityModel city;
  final CurrentWeather current;
  final List<HourlyWeather> hourly;
  final List<DailyWeather> daily;

  const WeatherForecast({
    required this.city,
    required this.current,
    required this.hourly,
    required this.daily,
  });

  factory WeatherForecast.fromJson({
    required Map<String, dynamic> json,
    required CityModel city,
  }) {
    final currentMap = json['current'] as Map<String, dynamic>? ?? {};
    final currentWeather = CurrentWeather.fromJson(currentMap);

    final hourlyMap = json['hourly'] as Map<String, dynamic>? ?? {};
    final hourlyTimes = (hourlyMap['time'] as List<dynamic>?) ?? [];
    final hourlyTemps = (hourlyMap['temperature_2m'] as List<dynamic>?) ?? [];
    final hourlyCodes = (hourlyMap['weather_code'] as List<dynamic>?) ?? [];

    final List<HourlyWeather> hourlyList = [];
    final hourlyLength = [
      hourlyTimes.length,
      hourlyTemps.length,
      hourlyCodes.length,
    ].reduce((a, b) => a < b ? a : b);

    for (int i = 0; i < hourlyLength; i++) {
      hourlyList.add(
        HourlyWeather(
          time: DateTime.tryParse(hourlyTimes[i]?.toString() ?? '') ?? DateTime.now(),
          temperature: (hourlyTemps[i] as num?)?.toDouble() ?? 0.0,
          weatherCode: (hourlyCodes[i] as num?)?.toInt() ?? 0,
        ),
      );
    }

    final dailyMap = json['daily'] as Map<String, dynamic>? ?? {};
    final dailyTimes = (dailyMap['time'] as List<dynamic>?) ?? [];
    final dailyCodes = (dailyMap['weather_code'] as List<dynamic>?) ?? [];
    final dailyMaxTemps = (dailyMap['temperature_2m_max'] as List<dynamic>?) ?? [];
    final dailyMinTemps = (dailyMap['temperature_2m_min'] as List<dynamic>?) ?? [];

    final List<DailyWeather> dailyList = [];
    final dailyLength = [
      dailyTimes.length,
      dailyCodes.length,
      dailyMaxTemps.length,
      dailyMinTemps.length,
    ].reduce((a, b) => a < b ? a : b);

    for (int i = 0; i < dailyLength; i++) {
      dailyList.add(
        DailyWeather(
          date: DateTime.tryParse(dailyTimes[i]?.toString() ?? '') ?? DateTime.now(),
          weatherCode: (dailyCodes[i] as num?)?.toInt() ?? 0,
          maxTemperature: (dailyMaxTemps[i] as num?)?.toDouble() ?? 0.0,
          minTemperature: (dailyMinTemps[i] as num?)?.toDouble() ?? 0.0,
        ),
      );
    }

    return WeatherForecast(
      city: city,
      current: currentWeather,
      hourly: hourlyList,
      daily: dailyList,
    );
  }

  @override
  List<Object?> get props => [city, current, hourly, daily];
}
