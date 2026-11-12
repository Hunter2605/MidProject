import 'package:equatable/equatable.dart';
import '../../data/models/city_model.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object?> get props => [];
}

class LoadWeatherEvent extends WeatherEvent {
  final CityModel city;

  const LoadWeatherEvent(this.city);

  @override
  List<Object?> get props => [city];
}

class SearchCityEvent extends WeatherEvent {
  final String query;

  const SearchCityEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class RefreshWeatherEvent extends WeatherEvent {
  const RefreshWeatherEvent();
}
