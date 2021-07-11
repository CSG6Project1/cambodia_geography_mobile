import 'package:cambodia_geography/app.dart';
import 'package:cambodia_geography/cambodia_geography.dart';
import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/screens/drawer/app_drawer.dart';
import 'package:cambodia_geography/widgets/cg_app_bar_title.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  String? currentProvinceCode;
  late TabController controller;
  late CambodiaGeography geo;

  @override
  void initState() {
    geo = CambodiaGeography.instance;
    currentProvinceCode = geo.tbProvinces[0].code;
    controller = TabController(length: geo.tbProvinces.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      body: CustomScrollView(
        slivers: [
          buildAppbar(),
          buildBody(),
        ],
      ),
    );
  }

  SliverList buildBody() {
    return SliverList(
      delegate: SliverChildListDelegate(
        List.generate(
          controller.length,
          (index) {
            final province = geo.tbProvinces[index];
            final districts = geo.districtsSearch(provinceCode: province.code ?? "");
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  tileColor: Theme.of(context).colorScheme.background,
                  title: Text(province.khmer.toString()),
                  subtitle: Text(province.code.toString()),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: districts.map((district) {
                    return ListTile(
                      onTap: () {
                        Navigator.of(context).pushNamed(RouteConfig.DISTRICT, arguments: district);
                      },
                      tileColor: Theme.of(context).colorScheme.background,
                      title: Text(district.khmer.toString()),
                      subtitle: Text(district.code.toString()),
                    );
                  }).toList(),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  MorphingSliverAppBar buildAppbar() {
    final scheme = Theme.of(context).colorScheme;
    return MorphingSliverAppBar(
      floating: true,
      pinned: true,
      forceElevated: true,
      actions: [
        IconButton(
          onPressed: () => App.of(context)?.toggleDarkMode(),
          icon: Icon(
            Icons.nights_stay,
            color: scheme.onPrimary,
          ),
        )
      ],
      leading: Builder(builder: (context) {
        return IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        );
      }),
      title: Container(
        child: Wrap(
          key: const Key("HomeTitle"),
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(Icons.map, color: scheme.onPrimary),
            const SizedBox(width: 4.0),
            CGAppBarTitle(title: AppLocalizations.of(context)!.helloWorld)
          ],
        ),
      ),
      bottom: TabBar(
        key: const Key("HomeTabBar"),
        controller: controller,
        isScrollable: true,
        tabs: List.generate(
          geo.tbProvinces.length,
          (index) => Tab(
            key: Key("HomeTabItem$index"),
            child: Text(
              geo.tbProvinces[index].khmer.toString(),
            ),
          ),
        ),
      ),
    );
  }
}
