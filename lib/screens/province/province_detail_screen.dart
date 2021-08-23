import 'package:cambodia_geography/constants/api_constant.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/helpers/app_helper.dart';
import 'package:cambodia_geography/helpers/number_helper.dart';
import 'package:cambodia_geography/mixins/cg_media_query_mixin.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/models/tb_province_model.dart';
import 'package:cambodia_geography/screens/map/map_screen.dart';
import 'package:cambodia_geography/screens/place_detail/local_widgets/place_title.dart';
import 'package:cambodia_geography/widgets/cg_bottom_nav_wrapper.dart';
import 'package:cambodia_geography/widgets/cg_network_image_loader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
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
  late ScrollController scrollController;
  late PageController pageController;
  late WeatherFactory weatherFactory;
  Future<Weather>? weather;
  LatLng? latLng;

  double get expandedHeight => MediaQuery.of(context).size.width;

  @override
  void initState() {
    scrollController = ScrollController();
    pageController = PageController();
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
      bottomNavigationBar: buildBottomNavigationBar(),
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          CgImageAppBar(
            expandedHeight: expandedHeight,
            pageController: pageController,
            title: widget.province.khmer ?? "Province",
            images: [
              'https://upload.wikimedia.org/wikipedia/commons/thumb/4/44/Ankor_Wat_temple.jpg/1200px-Ankor_Wat_temple.jpg',
              'https://www.telegraph.co.uk/content/dam/Travel/2019/February/wat-xlarge.jpg',
            ],
          ),
          buildBody(),
        ],
      ),
    );
  }

  SliverList buildBody() {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          PlaceTitle(
            title: widget.province.khmer.toString(),
            provinceCode: widget.province.code,
            lat: double.tryParse(widget.province.latitude ?? '0'),
            lon: double.tryParse(widget.province.longitudes ?? '0'),
          ),
          buildContainer(
            title: 'អាកាសធាតុ',
            body: buildWeather(),
          ),
          buildContainer(
            margin: EdgeInsets.only(bottom: ConfigConstant.margin2),
            title: 'អំពីខេត្ត',
            body: buildAboutProvince(),
          ),
          buildContainer(
            margin: EdgeInsets.only(bottom: ConfigConstant.margin2),
            title: 'ទិសដៅ',
            body: buildProvinceDirection(),
          ),
        ],
      ),
    );
  }

  Column buildProvinceDirection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeaderTile(
          title: 'ខាងជើង',
          subtitle: widget.province.northKh.toString(),
          leading: Icon(Icons.north),
        ),
        buildHeaderTile(
          title: 'ខាងកើត',
          subtitle: widget.province.eastKh.toString(),
          leading: Icon(Icons.east),
        ),
        buildHeaderTile(
          title: 'ខាងត្បូង',
          subtitle: widget.province.southKh.toString(),
          leading: Icon(Icons.south),
        ),
        buildHeaderTile(
          title: 'ខាងលិច',
          subtitle: widget.province.westKh.toString(),
          leading: Icon(Icons.west),
        ),
      ],
    );
  }

  MarkdownBody buildAboutProvince() {
    return MarkdownBody(
      data:
          'ឬប្រាសាទអង្គរតូចមានទីតាំងស្ថិតនៅភាគខាងជើងនៃក្រុងសៀមរាបនៃខេត្តសៀមរាប។ ប្រាសាទអង្គរវត្តជា ប្រាសាទព្រហ្មញ្ញសាសនាធំបំផុត និងជាវិមានសាសនាដ៏ធំបំផុត នៅក្នុងលោក។ ប្រាសាទនេះត្រូវបានកសាងឡើងដោយ ព្រះបាទសូរ្យវរ្ម័នទី២ ដែលជាស្នាដៃដ៏ធំអស្ចារ្យ និងមានឈ្មោះ ល្បីល្បាញរន្ទឺសុះសាយទៅគ្រប់ទិសទីលើពិភពលោក។ ប្រាសាទនេះសាងសង់ឡើងនៅដើមសតវត្សទី១២ ដែលស្ថិត នៅក្នុងរាជធានយសោធរបុរៈ។ ប្រាសាទអង្គរវត្តជាប្រាសាទ កសាងឡើង ដើម្បីឧទ្ទិសដល់ព្រះវិស្ណុ។ឬប្រាសាទ អង្គរតូចមានទីតាំងស្ថិតនៅភាគខាងជើងនៃក្រុងសៀមរាបនៃខេត្តសៀមរាប។  ប្រាសាទអង្គរវត្តជា ប្រាសាទព្រហ្មញ្ញសាសនាធំបំផុត និងជាវិមានសាសនាដ៏ធំបំផុត នៅក្នុងលោក។ ប្រាសាទអង្គរវត្តជាប្រាសាទ កសាងឡើង ដើម្បីឧទ្ទិសដល់ព្រះវិស្ណុ។',
      selectable: true,
      styleSheet: MarkdownStyleSheet.fromTheme(
        themeData.copyWith(
          textTheme: textTheme.apply(
            bodyColor: textTheme.caption?.color,
          ),
        ),
      ),
      onTapLink: (String text, String? href, String title) {
        // TODO: handle on tap on link
        print(href);
      },
    );
  }

  Widget buildContainer({
    required String title,
    required Widget body,
    EdgeInsetsGeometry? margin,
  }) {
    return Container(
      color: colorScheme.surface,
      margin: margin ?? const EdgeInsets.symmetric(vertical: ConfigConstant.margin2),
      padding: const EdgeInsets.all(ConfigConstant.margin2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.subtitle1?.copyWith(color: textTheme.caption?.color, fontWeight: FontWeight.bold),
          ),
          body,
        ],
      ),
    );
  }

  Widget buildWeather() {
    return FutureBuilder<Weather>(
      future: weather,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Map<String, dynamic>? json = snapshot.data?.toJson();
          Weather? weather = snapshot.data;
          // Temparature
          String celsius = "${NumberHelper.toKhmer(weather?.temperature?.celsius?.toInt())} °C";
          String fahrenheit = "${NumberHelper.toKhmer(weather?.temperature?.fahrenheit?.toInt())} °F";
          // Weather image
          String? weatherImage;
          print('weather Icon ; ${weather?.weatherIcon}');
          String icon = weather?.weatherIcon ?? '';
          if (weather?.weatherIcon != null) {
            weatherImage = "http://openweathermap.org/img/wn/$icon@2x.png";
          }
          // Wind
          String windSpeed = NumberHelper.toKhmer(weather?.windSpeed.toString());
          String windDegree = NumberHelper.toKhmer(weather?.windDegree.toString());
          String windDir = AppHelper.getCompassDirection(weather?.windDegree ?? 0);
          IconData iconDirection = AppHelper.getDirectionIcon(weather?.windDegree ?? 0);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeaderTile(
                title: "សីតុណ្ហភាព",
                subtitle: '$celsius | $fahrenheit',
                weatherImage: weatherImage,
              ),
              buildHeaderTile(
                title: "ខ្យល់",
                subtitle: '$windSpeed m/s | $windDir($windDegree°)',
                leading: Icon(iconDirection),
              ),
            ],
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

  ListTile buildHeaderTile({
    required String title,
    required String subtitle,
    String? weatherImage,
    Widget? leading,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: textTheme.bodyText2?.copyWith(color: colorScheme.primary),
      ),
      subtitle: Text(
        subtitle,
        style: textTheme.caption,
      ),
      tileColor: colorScheme.surface,
      leading: AspectRatio(
        aspectRatio: 1,
        child: Container(
          alignment: Alignment.center,
          child: weatherImage != null ? CgNetworkImageLoader(imageUrl: weatherImage) : leading,
        ),
      ),
    );
  }

  Widget buildBottomNavigationBar() {
    return CgBottomNavWrapper(
      child: Row(
        children: [
          IconButton(
            onPressed: () async {
              // await Navigator.pushNamed(
              //   context,
              //   RouteConfig.COMMENT,
              //   arguments: place,
              // );
            },
            icon: Icon(
              Icons.mode_comment,
              color: colorScheme.primary,
            ),
          ),
          Text(
            NumberHelper.toKhmer((0).toString()),
            style: textTheme.caption,
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.share,
              color: colorScheme.primary,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.bookmark,
              color: colorScheme.primary,
            ),
          )
        ],
      ),
    );
  }
}
