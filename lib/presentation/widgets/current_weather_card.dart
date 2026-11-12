import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data/models/weather_model.dart';
import 'weather_icon_helper.dart';

class CurrentWeatherCard extends StatelessWidget {
  final CurrentWeather current;

  const CurrentWeatherCard({
    super.key,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    final hour = current.time.hour;
    final isDay = hour >= 6 && hour < 21;
    final icon = WeatherIconHelper.getIcon(current.weatherCode, isDay: isDay);
    final iconColor = WeatherIconHelper.getIconColor(current.weatherCode, isDay: isDay);
    final description = WeatherIconHelper.getDescription(current.weatherCode);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 72,
            color: iconColor,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${current.temperature.round()}',
                style: const TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.w200,
                  color: Colors.white,
                  height: 1.0,
                ),
              ),
              const Text(
                '°C',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w300,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(
            color: Colors.white.withValues(alpha: 0.2),
            height: 1,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _ParamItem(
                icon: CupertinoIcons.thermometer,
                title: 'Ощущается',
                value: '${current.apparentTemperature.round()}°C',
              ),
              _ParamItem(
                icon: CupertinoIcons.drop,
                title: 'Влажность',
                value: '${current.humidity}%',
              ),
              _ParamItem(
                icon: CupertinoIcons.wind,
                title: 'Ветер',
                value: '${current.windSpeed.toStringAsFixed(1)} км/ч',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ParamItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ParamItem({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 22),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white60,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
