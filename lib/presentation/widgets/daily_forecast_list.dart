import 'package:flutter/material.dart';
import '../../data/models/weather_model.dart';
import 'weather_icon_helper.dart';

class DailyForecastList extends StatelessWidget {
  final List<DailyWeather> daily;

  const DailyForecastList({
    super.key,
    required this.daily,
  });

  @override
  Widget build(BuildContext context) {
    if (daily.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Прогноз на 7 дней',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: daily.length,
            separatorBuilder: (_, __) => Divider(
              color: Colors.white.withValues(alpha: 0.15),
              height: 14,
            ),
            itemBuilder: (context, index) {
              final item = daily[index];
              final dayText = _getDayName(item.date, index);
              final icon = WeatherIconHelper.getIcon(item.weatherCode, isDay: true);
              final iconColor = WeatherIconHelper.getIconColor(item.weatherCode, isDay: true);
              final description = WeatherIconHelper.getDescription(item.weatherCode);

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(
                        dayText,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: index == 0 ? FontWeight.bold : FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Icon(icon, size: 22, color: iconColor),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    Text(
                      '${item.minTemperature.round()}° / ${item.maxTemperature.round()}°',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _getDayName(DateTime date, int index) {
    if (index == 0) return 'Сегодня';
    if (index == 1) return 'Завтра';

    const days = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    return days[date.weekday - 1];
  }
}
