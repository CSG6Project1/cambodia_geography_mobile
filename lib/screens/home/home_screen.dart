import 'package:cambodia_geography/app.dart';
import 'package:cambodia_geography/cambodia_geography.dart';
import 'package:cambodia_geography/screens/district/district_screen.dart';
import 'package:cambodia_geography/screens/drawer/app_drawer.dart';
import 'package:flutter/material.dart';
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
    super.initState();
    geo = CambodiaGeography.instance;

    currentProvinceCode = geo.tbProvinces[0].code;
    controller = TabController(length: geo.tbProvinces.length, vsync: this);
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
                        Navigator.of(context).push(SwipeablePageRoute(
                          builder: (BuildContext context) => DistrictScreen(district: district),
                        ));
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
      leading: Builder(builder: (context) {
        return IconButton(
          icon: Icon(Icons.menu, color: scheme.onPrimary),
          onPressed: () => Scaffold.of(context).openDrawer(),
        );
      }),
      actions: [
        IconButton(
          onPressed: () => App.of(context)?.toggleDarkMode(),
          icon: Icon(
            Icons.nights_stay,
            color: scheme.onPrimary,
          ),
        )
      ],
      title: Row(
        key: const Key("HomeTitle"),
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.map, color: scheme.onPrimary),
          const SizedBox(width: 4.0),
          Text(
            "ប្រទេសកម្ពុធា",
            style: Theme.of(context).textTheme.headline6?.copyWith(color: Colors.white),
          ),
        ],
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
