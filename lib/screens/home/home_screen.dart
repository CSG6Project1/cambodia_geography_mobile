import 'package:cambodia_geography/cambodia_geography.dart';
import 'package:cambodia_geography/screens/district/district_screen.dart';
import 'package:flutter/material.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
    required this.geo,
  }) : super(key: key);

  final CambodiaGeography geo;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  String? currentProvinceCode;
  late TabController controller;

  @override
  void initState() {
    super.initState();
    currentProvinceCode = widget.geo.tbProvinces[0].code;
    controller = TabController(length: widget.geo.tbProvinces.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            buildAppbar(),
            buildBody(),
          ],
        ),
      ),
    );
  }

  SliverList buildBody() {
    return SliverList(
      delegate: SliverChildListDelegate(
        List.generate(
          controller.length,
          (index) {
            final province = widget.geo.tbProvinces[index];
            final districts = widget.geo.districtsSearch(provinceCode: province.code ?? "");
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  tileColor: Colors.white,
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
                      tileColor: Theme.of(context).backgroundColor,
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
    return MorphingSliverAppBar(
      floating: true,
      pinned: true,
      title: Row(
        key: Key("HomeTitle"),
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.map),
          const SizedBox(width: 4.0),
          Text(
            "ប្រទេសកម្ពុធា",
            style: Theme.of(context).textTheme.headline6?.copyWith(color: Colors.white),
          ),
        ],
      ),
      bottom: TabBar(
        key: Key("HomeTabBar"),
        controller: controller,
        isScrollable: true,
        tabs: List.generate(
          widget.geo.tbProvinces.length,
          (index) => Tab(
            key: Key("HomeTabItem$index"),
            child: Text(
              widget.geo.tbProvinces[index].khmer.toString(),
            ),
          ),
        ),
      ),
    );
  }
}
