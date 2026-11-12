import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../data/models/city_model.dart';
import '../../data/repositories/weather_repository.dart';
import '../../logic/bloc/weather_bloc.dart';
import '../../logic/bloc/weather_event.dart';
import '../../logic/bloc/weather_state.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/daily_forecast_list.dart';
import '../widgets/hourly_forecast_list.dart';
import '../widgets/weather_icon_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _submitSearch(String query) {
    final text = query.trim();
    if (text.isNotEmpty) {
      context.read<WeatherBloc>().add(SearchCityEvent(text));
      _searchController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  void _showCitySearchDialog() {
    final repository = context.read<WeatherRepository>();
    final bloc = context.read<WeatherBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _SearchBottomSheet(
        repository: repository,
        onSelect: (city) {
          bloc.add(LoadWeatherEvent(city));
          Navigator.of(ctx).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WeatherBloc, WeatherState>(
      listener: (context, state) {
        if (state is WeatherError && state.lastCity != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(
                label: 'Повторить',
                textColor: Colors.white,
                onPressed: () {
                  context.read<WeatherBloc>().add(LoadWeatherEvent(state.lastCity!));
                },
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final gradient = state is WeatherLoaded
            ? WeatherIconHelper.getBackgroundGradient(
                state.forecast.current.weatherCode,
                time: state.forecast.current.time,
              )
            : WeatherIconHelper.getBackgroundGradient(0);

        return Scaffold(
          body: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(gradient: gradient),
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(child: _buildContent(state)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0x26FFFFFF),
                borderRadius: BorderRadius.circular(23),
                border: Border.all(color: const Color(0x40FFFFFF)),
              ),
              child: TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                cursorColor: Colors.white,
                onSubmitted: _submitSearch,
                decoration: InputDecoration(
                  hintText: 'Поиск города...',
                  hintStyle: const TextStyle(color: Color(0x99FFFFFF)),
                  prefixIcon: const Icon(CupertinoIcons.search, color: Colors.white70, size: 18),
                  suffixIcon: IconButton(
                    icon: const Icon(CupertinoIcons.arrow_right, color: Colors.white70, size: 18),
                    onPressed: () => _submitSearch(_searchController.text),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filledTonal(
            onPressed: _showCitySearchDialog,
            icon: const Icon(Icons.location_city, size: 20),
            style: IconButton.styleFrom(
              backgroundColor: const Color(0x26FFFFFF),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(WeatherState state) {
    if (state is WeatherLoading && !(state is WeatherLoaded && (state as WeatherLoaded).isRefreshing)) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Colors.white),
            const SizedBox(height: 16),
            Text(
              state.message ?? 'Загрузка...',
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ],
        ),
      );
    }

    if (state is WeatherError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(CupertinoIcons.exclamationmark_circle, color: Colors.white70, size: 48),
              const SizedBox(height: 12),
              Text(
                state.message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () {
                  final city = state.lastCity ?? CityModel.defaultCity();
                  context.read<WeatherBloc>().add(LoadWeatherEvent(city));
                },
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Повторить'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (state is WeatherLoaded) {
      final forecast = state.forecast;
      final city = forecast.city;
      final dateStr = DateFormat('d MMMM, EEEE', 'ru').format(DateTime.now());

      return RefreshIndicator(
        color: Colors.blueAccent,
        backgroundColor: Colors.white,
        onRefresh: () async {
          context.read<WeatherBloc>().add(const RefreshWeatherEvent());
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on, color: Colors.white, size: 22),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      city.name,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                '${city.country} • $dateStr',
                style: const TextStyle(fontSize: 13, color: Colors.white70),
              ),
              const SizedBox(height: 16),
              CurrentWeatherCard(current: forecast.current),
              const SizedBox(height: 20),
              HourlyForecastList(hourly: forecast.hourly),
              const SizedBox(height: 20),
              DailyForecastList(daily: forecast.daily),
              const SizedBox(height: 24),
            ],
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

class _SearchBottomSheet extends StatefulWidget {
  final WeatherRepository repository;
  final ValueChanged<CityModel> onSelect;

  const _SearchBottomSheet({
    required this.repository,
    required this.onSelect,
  });

  @override
  State<_SearchBottomSheet> createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends State<_SearchBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  List<CityModel> _results = [];
  bool _loading = false;
  String? _error;

  static const _quickCities = ['Бишкек', 'Алматы', 'Ташкент', 'Астана', 'Москва', 'Ош'];

  Future<void> _search(String query) async {
    final q = query.trim();
    if (q.isEmpty) {
      setState(() {
        _results = [];
        _error = null;
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final cities = await widget.repository.searchCities(q);
      setState(() {
        _results = cities;
        _loading = false;
        if (cities.isEmpty) _error = 'Ничего не найдено';
      });
    } catch (_) {
      setState(() {
        _loading = false;
        _error = 'Ошибка при поиске';
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF1E293B),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            cursorColor: Colors.blueAccent,
            onChanged: _search,
            decoration: InputDecoration(
              hintText: 'Поиск по городам...',
              hintStyle: const TextStyle(color: Colors.white54),
              prefixIcon: const Icon(CupertinoIcons.search, color: Colors.white54),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.white54),
                      onPressed: () {
                        _controller.clear();
                        _search('');
                      },
                    )
                  : null,
              filled: true,
              fillColor: const Color(0xFF334155),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(height: 12),
          if (_results.isEmpty && !_loading && _error == null) ...[
            const Text(
              'Быстрый выбор',
              style: TextStyle(color: Colors.white60, fontSize: 13),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _quickCities.map((name) {
                return ActionChip(
                  label: Text(name),
                  labelStyle: const TextStyle(color: Colors.white, fontSize: 13),
                  backgroundColor: const Color(0xFF334155),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  onPressed: () {
                    _controller.text = name;
                    _search(name);
                  },
                );
              }).toList(),
            ),
          ],
          if (_loading)
            const Expanded(
              child: Center(child: CircularProgressIndicator(color: Colors.blueAccent)),
            )
          else if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Center(
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.white54),
                ),
              ),
            )
          else if (_results.isNotEmpty)
            Expanded(
              child: ListView.separated(
                itemCount: _results.length,
                separatorBuilder: (_, __) => const Divider(color: Colors.white10, height: 1),
                itemBuilder: (context, index) {
                  final city = _results[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.location_on_outlined, color: Colors.white70),
                    title: Text(city.name, style: const TextStyle(color: Colors.white)),
                    subtitle: Text(city.displayName, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                    onTap: () => widget.onSelect(city),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
