import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/city_model.dart';
import '../../data/repositories/weather_repository.dart';
import 'weather_event.dart';
import 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository _repository;
  CityModel _currentCity;

  CityModel get currentCity => _currentCity;

  WeatherBloc({
    required WeatherRepository repository,
    CityModel? initialCity,
  })  : _repository = repository,
        _currentCity = initialCity ?? CityModel.defaultCity(),
        super(const WeatherInitial()) {
    on<LoadWeatherEvent>(_onLoadWeather);
    on<SearchCityEvent>(_onSearchCity);
    on<RefreshWeatherEvent>(_onRefreshWeather);
  }

  Future<void> _onLoadWeather(
    LoadWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    _currentCity = event.city;
    emit(const WeatherLoading());

    try {
      final forecast = await _repository.getWeather(_currentCity);
      emit(WeatherLoaded(forecast: forecast));
    } catch (e) {
      emit(WeatherError(
        message: _formatError(e),
        lastCity: _currentCity,
      ));
    }
  }

  Future<void> _onSearchCity(
    SearchCityEvent event,
    Emitter<WeatherState> emit,
  ) async {
    final query = event.query.trim();
    if (query.isEmpty) return;

    emit(WeatherLoading(message: 'Поиск "$query"...'));

    try {
      final cities = await _repository.searchCities(query);
      if (cities.isEmpty) {
        emit(WeatherError(
          message: 'Город "$query" не найден',
          lastCity: _currentCity,
        ));
        return;
      }

      final city = cities.first;
      _currentCity = city;
      final forecast = await _repository.getWeather(city);
      emit(WeatherLoaded(forecast: forecast));
    } catch (e) {
      emit(WeatherError(
        message: _formatError(e),
        lastCity: _currentCity,
      ));
    }
  }

  Future<void> _onRefreshWeather(
    RefreshWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    final current = state;
    if (current is WeatherLoaded) {
      emit(current.copyWith(isRefreshing: true));
    } else {
      emit(const WeatherLoading());
    }

    try {
      final forecast = await _repository.getWeather(_currentCity);
      emit(WeatherLoaded(forecast: forecast, isRefreshing: false));
    } catch (e) {
      emit(WeatherError(
        message: _formatError(e),
        lastCity: _currentCity,
      ));
    }
  }

  String _formatError(dynamic error) {
    if (error is Exception) {
      final text = error.toString();
      return text.startsWith('Exception: ') ? text.substring(11) : text;
    }
    return 'Произошла непредвиденная ошибка';
  }
}
