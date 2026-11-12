import 'package:equatable/equatable.dart';
import '../../data/models/city_model.dart';
import '../../data/models/weather_model.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object?> get props => [];
}

class WeatherInitial extends WeatherState {
  const WeatherInitial();
}

class WeatherLoading extends WeatherState {
  final String? message;

  const WeatherLoading({this.message});

  @override
  List<Object?> get props => [message];
}

class WeatherLoaded extends WeatherState {
  final WeatherForecast forecast;
  final bool isRefreshing;

  const WeatherLoaded({
    required this.forecast,
    this.isRefreshing = false,
  });

  WeatherLoaded copyWith({
    WeatherForecast? forecast,
    bool? isRefreshing,
  }) {
    return WeatherLoaded(
      forecast: forecast ?? this.forecast,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [forecast, isRefreshing];
}

class WeatherError extends WeatherState {
  final String message;
  final CityModel? lastCity;

  const WeatherError({
    required this.message,
    this.lastCity,
  });

  @override
  List<Object?> get props => [message, lastCity];
}
