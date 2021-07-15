import 'package:cambodia_geography/cambodia_geography.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/mixins/cg_media_query_mixin.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/models/tb_district_model.dart';
import 'package:cambodia_geography/models/tb_province_model.dart';
import 'package:cambodia_geography/screens/drawer/app_drawer.dart';
import 'package:cambodia_geography/screens/search/cg_search_delegate.dart';
import 'package:cambodia_geography/widgets/cg_app_bar_title.dart';
import 'package:cambodia_geography/widgets/cg_menu_leading_button.dart';
import 'package:rect_getter/rect_getter.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'local_widgets/province_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin, CgThemeMixin, CgMediaQueryMixin {
  String? currentProvinceCode;
  late TabController tabController;
  late AutoScrollController scrollController;
  late AnimationController animationController;
  late CambodiaGeography geo;

  final listViewKey = RectGetter.createGlobalKey();
  Map<int, dynamic> itemKeys = {};

  bool pauseRectGetterIndex = false;

  @override
  void initState() {
    geo = CambodiaGeography.instance;
    currentProvinceCode = geo.tbProvinces[0].code;
    tabController = TabController(length: geo.tbProvinces.length, vsync: this);
    scrollController = AutoScrollController();
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    scrollController.dispose();
    animationController.dispose();
    super.dispose();
  }

  List<int> getVisibleItemsIndex() {
    Rect? rect = RectGetter.getRectFromKey(listViewKey);
    List<int> items = [];
    if (rect == null) return items;
    itemKeys.forEach((index, key) {
      Rect? itemRect = RectGetter.getRectFromKey(key);
      if (itemRect == null) return;
      if (itemRect.top > rect.bottom) return;
      if (itemRect.bottom < rect.top) return;
      items.add(index);
    });
    return items;
  }

  bool onScrollNotification(ScrollNotification notification) {
    if (pauseRectGetterIndex) return true;
    int lastTabIndex = tabController.length - 1;
    List<int> visibleItems = getVisibleItemsIndex();

    bool reachLastTabIndex = visibleItems.length <= 2 && visibleItems.last == lastTabIndex;
    if (reachLastTabIndex) {
      tabController.animateTo(lastTabIndex);
    } else {
      int sumIndex = visibleItems.reduce((value, element) => value + element);
      int middleIndex = sumIndex ~/ visibleItems.length;
      if (tabController.index != middleIndex) tabController.animateTo(middleIndex);
    }
    return false;
  }

  void animateAndScrollTo(int index) {
    pauseRectGetterIndex = true;
    tabController.animateTo(index);
    scrollController
        .scrollToIndex(index, preferPosition: AutoScrollPosition.begin)
        .then((value) => pauseRectGetterIndex = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: RectGetter(
        key: listViewKey,
        child: NotificationListener<ScrollNotification>(
          child: buildCustomScrollView(),
          onNotification: onScrollNotification,
        ),
      ),
    );
  }

  Widget buildCustomScrollView() {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        buildAppbar(),
        buildBody(),
      ],
    );
  }

  Widget buildAppbar() {
    return MorphingSliverAppBar(
      floating: true,
      pinned: true,
      forceElevated: true,
      leading: CgMenuLeadingButton(animationController: animationController),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () async {
            animationController.forward();
            await showSearch(
              context: context,
              delegate: CgSearchDelegate(
                animationController: animationController,
                context: context,
              ),
            );
            animationController.reverse();
          },
        )
      ],
      title: Wrap(
        key: const Key("HomeTitle"),
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Icon(Icons.map, color: themeData.colorScheme.onPrimary),
          const SizedBox(width: 4.0),
          const CgAppBarTitle(title: 'ប្រទេសកម្ពុជា')
        ],
      ),
      bottom: TabBar(
        key: const Key("HomeTabBar"),
        controller: tabController,
        isScrollable: true,
        onTap: (int index) {
          animateAndScrollTo(index);
        },
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

  Widget buildBody() {
    return SliverList(
      delegate: SliverChildListDelegate(
        List.generate(
          tabController.length,
          (index) {
            itemKeys[index] = RectGetter.createGlobalKey();
            final province = geo.tbProvinces[index];
            final districts = geo.districtsSearch(provinceCode: province.code ?? '');
            return buildProvinceCardItem(index, province, districts);
          },
        ),
      ),
    );
  }

  Widget buildProvinceCardItem(int index, TbProvinceModel province, List<TbDistrictModel> districts) {
    return RectGetter(
      key: itemKeys[index],
      child: AutoScrollTag(
        key: ValueKey(index),
        controller: scrollController,
        index: index,
        child: ProvinceCard(
          province: province,
          district: districts,
          margin: EdgeInsets.only(
            top: ConfigConstant.margin2,
            bottom: index == tabController.length - 1 ? mediaQueryPadding.bottom : 0,
          ),
        ),
      ),
    );
  }
}
