import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/weather_model.dart';
import 'weather_icon_helper.dart';

class HourlyForecastList extends StatelessWidget {
  final List<HourlyWeather> hourly;

  const HourlyForecastList({
    super.key,
    required this.hourly,
  });

  @override
  Widget build(BuildContext context) {
    if (hourly.isEmpty) return const SizedBox.shrink();

    final now = DateTime.now();
    final items = hourly
        .where((item) => item.time.isAfter(now.subtract(const Duration(minutes: 50))))
        .take(24)
        .toList();

    final displayList = items.isNotEmpty ? items : hourly.take(24).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'Прогноз на 24 часа',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: displayList.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final item = displayList[index];
              final isCurrent = index == 0;
              final timeLabel = isCurrent ? 'Сейчас' : DateFormat('HH:mm').format(item.time);
              final isDay = item.time.hour >= 6 && item.time.hour < 21;
              final icon = WeatherIconHelper.getIcon(item.weatherCode, isDay: isDay);
              final iconColor = WeatherIconHelper.getIconColor(item.weatherCode, isDay: isDay);

              return Container(
                width: 72,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                decoration: BoxDecoration(
                  color: isCurrent ? const Color(0x40FFFFFF) : const Color(0x1FFFFFFF),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isCurrent ? const Color(0x80FFFFFF) : const Color(0x26FFFFFF),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      timeLabel,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                    Icon(icon, size: 26, color: iconColor),
                    Text(
                      '${item.temperature.round()}°',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
