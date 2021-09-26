import 'package:cambodia_geography/app.dart';
import 'package:cambodia_geography/cambodia_geography.dart';
import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/widgets_exports.dart';
import 'package:cambodia_geography/models/tb_province_model.dart';
import 'package:cambodia_geography/providers/bookmark_editing_provider.dart';
import 'package:cambodia_geography/screens/admin/local_widgets/place_list.dart';
import 'package:cambodia_geography/services/apis/base_api.dart';
import 'package:cambodia_geography/services/apis/bookmarks/bookmark_api.dart';
import 'package:cambodia_geography/services/apis/bookmarks/bookmark_remove_multiple_places_api.dart';
import 'package:cambodia_geography/services/apis/bookmarks/bookmark_remove_place_api.dart';
import 'package:easy_localization/easy_localization.dart';
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
  late Key placeKey;
  late Key restaurantKey;

  @override
  void initState() {
    controller = TabController(length: 2, vsync: this);
    provinces = CambodiaGeography.instance.tbProvinces;
    _currentProvinceCode = provinces.first.code!;
    placeKey = UniqueKey();
    restaurantKey = UniqueKey();
    super.initState();
  }

  void setUniqueKey(BaseApi api) {
    if (api.success()) {
      if (controller.index == 0) {
        setState(() {
          placeKey = UniqueKey();
        });
      } else {
        setState(() {
          restaurantKey = UniqueKey();
        });
      }
    }
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
    return Scaffold(
      appBar: buildAppbar(),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return TabBarView(
      controller: controller,
      children: [
        PlaceList(
          key: placeKey,
          type: PlaceType.place,
          basePlacesApi: BookmarkApi(),
          onTap: (place) {
            Navigator.of(context).pushNamed(
              RouteConfig.PLACEDETAIL,
              arguments: place,
            );
          },
        ),
        PlaceList(
          key: restaurantKey,
          type: PlaceType.restaurant,
          basePlacesApi: BookmarkApi(),
          onTap: (place) {
            Navigator.of(context).pushNamed(
              RouteConfig.PLACEDETAIL,
              arguments: place,
            );
          },
        ),
      ],
    );
  }

  MorphingAppBar buildAppbar() {
    BookmarkEditingProvider provider = Provider.of<BookmarkEditingProvider>(context, listen: false);
    return MorphingAppBar(
      actions: [
        IconButton(
          onPressed: () {
            provider.editing = !provider.editing;
            print(provider.checkPlaceIds);
          },
          icon: Icon(Icons.settings),
        ),
        Container(
          alignment: Alignment.center,
          child: Consumer<BookmarkEditingProvider>(
            child: Container(
              width: kToolbarHeight,
              height: kToolbarHeight,
              child: IconButton(
                onPressed: () async {
                  if (provider.checkPlaceIds.length == 1) {
                    BookmarkRemovePlaceApi bookmarkRemovePlaceApi = BookmarkRemovePlaceApi();
                    App.of(context)?.showLoading();
                    await bookmarkRemovePlaceApi.removePlace(id: provider.checkPlaceIds[0]);
                    provider.editing = false;
                    App.of(context)?.hideLoading();
                    setUniqueKey(bookmarkRemovePlaceApi);
                  } else if (provider.checkPlaceIds.length >= 2) {
                    BookmarkRemoveMultiplePlacesApi bookmarkRemoveMultiplePlacesApi = BookmarkRemoveMultiplePlacesApi();
                    App.of(context)?.showLoading();
                    await bookmarkRemoveMultiplePlacesApi.removeMultiplePlaces(placeIds: provider.checkPlaceIds);
                    provider.editing = false;
                    App.of(context)?.hideLoading();
                    setUniqueKey(bookmarkRemoveMultiplePlacesApi);
                  }
                },
                icon: Icon(Icons.delete),
              ),
            ),
            builder: (context, provider, child) {
              return AnimatedCrossFade(
                sizeCurve: Curves.ease,
                firstChild: child ?? SizedBox(),
                secondChild: SizedBox(
                  height: kToolbarHeight,
                ),
                crossFadeState:
                    provider.checkPlaceIds.length >= 1 ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                duration: ConfigConstant.fadeDuration,
              );
            },
          ),
        ),
      ],
      title: CgAppBarTitle(title: tr('title.bookmark')),
      bottom: TabBar(
        controller: controller,
        tabs: [
          Tab(
            child: Text(
              tr('place_type.place'),
              style: TextStyle(
                fontFamilyFallback: Theme.of(context).textTheme.bodyText1?.fontFamilyFallback,
              ),
            ),
          ),
          Tab(
            child: Text(
              tr('place_type.restaurant'),
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
