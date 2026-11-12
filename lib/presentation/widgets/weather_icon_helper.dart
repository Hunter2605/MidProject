import 'package:flutter/cupertino.dart';

class WeatherIconHelper {
  static String getDescription(int code) {
    if (code == 0) return 'Ясно';
    if (code == 1) return 'Преимущественно ясно';
    if (code == 2) return 'Переменная облачность';
    if (code == 3) return 'Пасмурно';
    if (code == 45 || code == 48) return 'Туман';
    if (code >= 51 && code <= 55) return 'Морось';
    if (code == 56 || code == 57) return 'Ледяная морось';
    if (code >= 61 && code <= 65) return 'Дождь';
    if (code == 66 || code == 67) return 'Ледяной дождь';
    if (code >= 71 && code <= 77) return 'Снегопад';
    if (code >= 80 && code <= 82) return 'Ливень';
    if (code == 85 || code == 86) return 'Снег с метелью';
    if (code >= 95) return 'Гроза';
    return 'Облачно';
  }

  static IconData getIcon(int code, {bool isDay = true}) {
    switch (code) {
      case 0:
        return isDay ? CupertinoIcons.sun_max_fill : CupertinoIcons.moon_stars_fill;
      case 1:
      case 2:
        return isDay ? CupertinoIcons.cloud_sun_fill : CupertinoIcons.cloud_moon_fill;
      case 3:
        return CupertinoIcons.cloud_fill;
      case 45:
      case 48:
        return CupertinoIcons.cloud_fog_fill;
      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
        return CupertinoIcons.cloud_drizzle_fill;
      case 61:
      case 63:
      case 65:
      case 66:
      case 67:
        return CupertinoIcons.cloud_rain_fill;
      case 71:
      case 73:
      case 75:
      case 77:
        return CupertinoIcons.snow;
      case 80:
      case 81:
      case 82:
        return CupertinoIcons.cloud_heavyrain_fill;
      case 85:
      case 86:
        return CupertinoIcons.cloud_snow_fill;
      case 95:
      case 96:
      case 99:
        return CupertinoIcons.cloud_bolt_rain_fill;
      default:
        return CupertinoIcons.cloud_fill;
    }
  }

  static Color getIconColor(int code, {bool isDay = true}) {
    if (code <= 2) {
      return isDay ? const Color(0xFFFFD54F) : const Color(0xFFFFF9C4);
    }
    if (code >= 95) {
      return const Color(0xFFFFCA28);
    }
    if ((code >= 51 && code <= 67) || (code >= 80 && code <= 82)) {
      return const Color(0xFF81D4FA);
    }
    if (code >= 71 && code <= 77) {
      return const Color(0xFFE1F5FE);
    }
    return const Color(0xFFECEFF1);
  }

  static LinearGradient getBackgroundGradient(int code, {DateTime? time}) {
    final hour = (time ?? DateTime.now()).hour;
    final isNight = hour < 6 || hour >= 21;

    if (isNight) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
      );
    }

    if (code >= 95) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF2C3E50), Color(0xFF4CA1AF), Color(0xFF2C3E50)],
      );
    }

    if ((code >= 51 && code <= 67) || (code >= 80 && code <= 82)) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF3A6073), Color(0xFF3A7BD5)],
      );
    }

    if (code >= 71 && code <= 86) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF616161), Color(0xFF9BC5C3)],
      );
    }

    if (code == 3 || code == 45 || code == 48) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF4B6CB7), Color(0xFF182848)],
      );
    }

    // Дневной градиент
    return const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF2193B0), Color(0xFF6DD5ED)],
    );
  }
}
