# Weather App (Open-Meteo)

Мобильное приложение для просмотра погоды, написанное на Flutter. Использует публичное API Open-Meteo, BLoC для управления состоянием и Dio для сетевых запросов.

## Функционал

- Текущая погода в выбранном городе (температура, ощущаемая температура, влажность, скорость ветра)
- Поиск любого города через Open-Meteo Geocoding API
- Почасовой прогноз на ближайшие 24 часа
- Прогноз погоды на 7 дней вперед
- Автоматический выбор города по умолчанию (Бишкек)
- Свайп для обновления данных (Pull-to-refresh)
- Адаптивный градиентный фон в зависимости от времени суток и погоды
- Обработка ошибок (отсутствие интернета, неверный город) с возможностью повтора

## Стек технологий

- **Flutter / Dart**
- **flutter_bloc** (^8.1.6) — state management
- **dio** (^5.7.0) — HTTP-клиент
- **equatable** (^2.0.5) — сравнение объектов состояний и моделей
- **intl** (^0.19.0) — форматирование даты и времени
- **cupertino_icons** — иконки

## Структура проекта

```text
lib/
├── data/
│   ├── models/
│   │   ├── city_model.dart
│   │   └── weather_model.dart
│   ├── services/
│   │   └── weather_api_client.dart
│   └── repositories/
│       └── weather_repository.dart
├── logic/
│   └── bloc/
│       ├── weather_bloc.dart
│       ├── weather_event.dart
│       └── weather_state.dart
├── presentation/
│   ├── screens/
│   │   └── home_screen.dart
│   └── widgets/
│       ├── current_weather_card.dart
│       ├── daily_forecast_list.dart
│       ├── hourly_forecast_list.dart
│       └── weather_icon_helper.dart
└── main.dart
```

## API

Проект работает с [Open-Meteo](https://open-meteo.com/):
- **Поиск городов:** `https://geocoding-api.open-meteo.com/v1/search`
- **Прогноз:** `https://api.open-meteo.com/v1/forecast`

## Запуск проекта

1. Убедитесь, что установлен Flutter SDK (`flutter --version`).
2. Склонируйте репозиторий и перейдите в папку проекта:
   ```bash
   git clone <url-репозитория>
   cd MidProject
   ```
3. Установите зависимости:
   ```bash
   flutter pub get
   ```
4. Запустите приложение:
   ```bash
   flutter run
   ```
