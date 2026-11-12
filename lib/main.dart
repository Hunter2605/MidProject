import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'data/models/city_model.dart';
import 'data/repositories/weather_repository.dart';
import 'data/services/weather_api_client.dart';
import 'logic/bloc/weather_bloc.dart';
import 'logic/bloc/weather_event.dart';
import 'presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ru', null);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  final repository = WeatherRepositoryImpl(apiClient: WeatherApiClient());

  runApp(WeatherApp(weatherRepository: repository));
}

class WeatherApp extends StatelessWidget {
  final WeatherRepository weatherRepository;

  const WeatherApp({
    super.key,
    required this.weatherRepository,
  });

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<WeatherRepository>.value(
      value: weatherRepository,
      child: BlocProvider(
        create: (context) => WeatherBloc(
          repository: weatherRepository,
        )..add(LoadWeatherEvent(CityModel.defaultCity())),
        child: MaterialApp(
          title: 'Weather App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.dark,
            ),
          ),
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
