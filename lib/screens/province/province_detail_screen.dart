import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/constants/api_constant.dart';
import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/mixins/cg_media_query_mixin.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/models/tb_province_model.dart';
import 'package:cambodia_geography/screens/map/map_screen.dart';
import 'package:cambodia_geography/widgets/cg_network_image_loader.dart';
import 'package:flutter/foundation.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'package:weather/weather.dart';

class ProvinceDetailScreen extends StatefulWidget {
  const ProvinceDetailScreen({
    Key? key,
    required this.province,
  }) : super(key: key);

  final TbProvinceModel province;

  @override
  _ProvinceDetailScreenState createState() => _ProvinceDetailScreenState();
}

class _ProvinceDetailScreenState extends State<ProvinceDetailScreen> with CgThemeMixin, CgMediaQueryMixin {
  late WeatherFactory weatherFactory;
  Future<Weather>? weather;
  LatLng? latLng;

  @override
  void initState() {
    weatherFactory = WeatherFactory(ApiConstant.openWeatherMapApiKey);
    super.initState();

    double? latitude = double.tryParse(widget.province.latitude ?? "");
    double? longitudes = double.tryParse(widget.province.longitudes ?? "");

    if (latitude != null && longitudes != null) {
      latLng = LatLng(latitude, longitudes);
      weather = _setWeather(latitude, longitudes);
    }
  }

  Future<Weather> _setWeather(double latitude, double longitudes) async {
    return await weatherFactory.currentWeatherByLocation(latitude, longitudes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        title: Text(widget.province.khmer ?? "Province"),
      ),
      body: buildWeather(),
    );
  }

  Widget buildWeather() {
    return FutureBuilder<Weather>(
      future: weather,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Map<String, dynamic>? json = snapshot.data?.toJson();
          return ListView(
            children: buildList(
              weather: snapshot.data,
              json: json,
            ),
          );
        } else if (snapshot.hasError) {
          return const Text('Something went wrong...');
        }

        return const Center(
          child: const CircularProgressIndicator(),
        );
      },
    );
  }

  List<Widget> buildList({
    required Map<String, dynamic>? json,
    required Weather? weather,
  }) {
    List<Widget> children = List.generate(
      json?.length ?? 0,
      (index) {
        final e = json?.entries.toList()[index];
        return ListTile(
          title: Text(e?.key ?? ""),
          subtitle: Text(e?.value.toString() ?? ""),
        );
      },
    );

    String celsius = "${weather?.temperature?.celsius?.toInt()} °C";
    String? weatherImage;
    if (weather?.weatherIcon != null) {
      weatherImage = "https://openweathermap.org/img/w/" + weather!.weatherIcon! + ".png";
    }

    children.insert(
      0,
      buildHeaderTile(celsius, weatherImage),
    );

    return children;
  }

  ListTile buildHeaderTile(String celsius, String? weatherImage) {
    return ListTile(
      title: const Text("Weather"),
      subtitle: Text(celsius),
      tileColor: colorScheme.surface,
      leading: weatherImage != null
          ? AspectRatio(
              aspectRatio: 1,
              child: CgNetworkImageLoader(imageUrl: weatherImage),
            )
          : null,
      trailing: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text("Map"),
          Icon(Icons.keyboard_arrow_right),
        ],
      ),
      onTap: () {
        if (latLng != null) {
          Navigator.of(context).pushNamed(
            RouteConfig.MAP,
            arguments: MapScreenSetting(
              flowType: MapFlowType.view,
              initialLatLng: latLng,
            ),
          );
        }
      },
    );
  }
}
