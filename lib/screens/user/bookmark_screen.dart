import 'package:cambodia_geography/app.dart';
import 'package:cambodia_geography/cambodia_geography.dart';
import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/widgets_exports.dart';
import 'package:cambodia_geography/models/tb_province_model.dart';
import 'package:cambodia_geography/providers/bookmark_editing_provider.dart';
import 'package:cambodia_geography/screens/admin/local_widgets/place_list.dart';
import 'package:cambodia_geography/services/apis/places/places_api.dart';
import 'package:cambodia_geography/widgets/cg_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({Key? key}) : super(key: key);

  @override
  _BookmarkScreenState createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> with SingleTickerProviderStateMixin, RouteAware {
  late TabController controller;
  late List<TbProvinceModel> provinces;

  @override
  void initState() {
    controller = TabController(length: 2, vsync: this);
    provinces = CambodiaGeography.instance.tbProvinces;
    _currentProvinceCode = provinces.first.code!;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    App.routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPush() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Provider.of<BookmarkEditingProvider>(context, listen: false).editing = false;
    });
  }

  @override
  void didPopNext() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Provider.of<BookmarkEditingProvider>(context, listen: false).editing = false;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    App.routeObserver.unsubscribe(this);
    super.dispose();
  }

  late String _currentProvinceCode;
  String get currentProvinceCode => this._currentProvinceCode;
  set currentProvinceCode(String value) {
    if (this._currentProvinceCode == value) return;
    setState(() {
      this._currentProvinceCode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CgScaffold(
      appBar: buildAppbar(),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Stack(
      children: List.generate(
        provinces.length,
        (index) {
          return Visibility(
            visible: currentProvinceCode == provinces[index].code,
            child: TabBarView(
              controller: controller,
              children: [
                PlaceList(
                  type: PlaceType.place,
                  provinceCode: provinces[index].code,
                  basePlacesApi: PlacesApi(),
                  onTap: (place) {
                    Navigator.of(context).pushNamed(
                      RouteConfig.PLACEDETAIL,
                      arguments: place,
                    );
                  },
                ),
                PlaceList(
                  type: PlaceType.restaurant,
                  provinceCode: provinces[index].code,
                  basePlacesApi: PlacesApi(),
                  onTap: (place) {
                    Navigator.of(context).pushNamed(
                      RouteConfig.PLACEDETAIL,
                      arguments: place,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  MorphingAppBar buildAppbar() {
    return MorphingAppBar(
      actions: [
        IconButton(
          onPressed: () {
            BookmarkEditingProvider provider = Provider.of<BookmarkEditingProvider>(context, listen: false);
            provider.editing = !provider.editing;
          },
          icon: Icon(Icons.settings),
        ),
      ],
      titleSpacing: 0,
      title: Row(
        children: [
          const SizedBox(width: ConfigConstant.margin1),
          const CgAppBarTitle(title: "កំណត់ចំណាំ"),
          const SizedBox(width: ConfigConstant.margin2 + 8),
          Expanded(
            child: CgDropDownField(
              isExpanded: true,
              outlineBorder: true,
              items: provinces.map((e) => "${e.khmer}").toList(),
              onChanged: (String? value) {
                currentProvinceCode = provinces.where((element) => value == element.khmer).first.code!;
              },
            ),
          ),
        ],
      ),
      bottom: TabBar(
        controller: controller,
        tabs: [
          Tab(
            child: Text(
              "តំបន់ទេសចរណ៍",
              style: TextStyle(
                fontFamilyFallback: Theme.of(context).textTheme.bodyText1?.fontFamilyFallback,
              ),
            ),
          ),
          Tab(
            child: Text(
              "ភោជនីយដ្ឋាន",
              style: TextStyle(
                fontFamilyFallback: Theme.of(context).textTheme.bodyText1?.fontFamilyFallback,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
