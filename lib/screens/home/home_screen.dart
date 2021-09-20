import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cambodia_geography/cambodia_geography.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/mixins/cg_media_query_mixin.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/models/tb_district_model.dart';
import 'package:cambodia_geography/models/tb_province_model.dart';
import 'package:cambodia_geography/screens/home/local_widgets/verify_email_banner.dart';
import 'package:cambodia_geography/widgets/cg_app_bar_title.dart';
import 'package:cambodia_geography/widgets/cg_menu_leading_button.dart';
import 'package:cambodia_geography/widgets/cg_scaffold.dart';
import 'package:rect_getter/rect_getter.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'local_widgets/province_card.dart';
import 'local_widgets/search_button.dart';

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

  late ValueNotifier<double> scrollOffsetNotifier;

  /// store provinces info whether
  /// it is expanded or not.
  ///
  /// example:
  /// ```
  /// {
  ///   1: true,
  ///   2: false
  ///   3: true,
  /// }
  /// ```
  Map<int, bool> provinceExpansionTileInfo = {};

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
    scrollOffsetNotifier = ValueNotifier(0.0);
    super.initState();

    scrollController.addListener(() {
      scrollOffsetNotifier.value = scrollController.offset;
    });
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
      if (tabController.index != middleIndex) {
        tabController.animateTo(middleIndex);
        try {
          this.currentProvinceCode = CambodiaGeography.instance.tbProvinces[middleIndex].code;
        } catch (e) {}
      }
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
    return CgScaffold(
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
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, _index) {
              if (_index == 0) return VerifyEmailBanner();
              int index = _index - 1;
              itemKeys[index] = RectGetter.createGlobalKey();
              final province = geo.tbProvinces[index];
              final districts = geo.districtsSearch(provinceCode: province.code ?? '');
              return buildProvinceCardItem(index, province, districts);
            },
            childCount: tabController.length + 1,
          ),
        )
      ],
    );
  }

  Widget buildAppBarTitle() {
    return InkWell(
      onTap: () async {
        List<TbProvinceModel> provinces = CambodiaGeography.instance.tbProvinces;
        String? selectedProvinceCode = await showConfirmationDialog(
          context: context,
          title: "Move to a province",
          initialSelectedActionKey: currentProvinceCode,
          actions: List.generate(
            provinces.length,
            (index) {
              return AlertDialogAction(
                key: provinces[index].code!,
                label: provinces[index].khmer!,
              );
            },
          ),
        );
        if (selectedProvinceCode != null) {
          try {
            int index = provinces.indexWhere((element) => element.code == selectedProvinceCode);
            scrollController.scrollToIndex(index);
          } catch (e) {}
        }
      },
      child: Wrap(
        key: const Key("HomeTitle"),
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Icon(Icons.map, color: themeData.colorScheme.onPrimary),
          const SizedBox(width: 4.0),
          const CgAppBarTitle(title: 'ប្រទេសកម្ពុជា'),
          Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }

  SearchButton get searchButton {
    return SearchButton(
      animationController: animationController,
    );
  }

  MorphingSliverAppBar buildAppbar() {
    double searchTopMargin = kToolbarHeight + mediaQueryData.padding.top + 8;
    return MorphingSliverAppBar(
      leading: CgMenuLeadingButton(animationController: animationController),
      automaticallyImplyLeading: false,
      collapsedHeight: kToolbarHeight,
      expandedHeight: searchTopMargin + kToolbarHeight + 32,
      pinned: true,
      stretch: true,
      actions: [
        ValueListenableBuilder(
          valueListenable: scrollOffsetNotifier,
          child: searchButton,
          builder: (context, value, child) {
            return Opacity(
              opacity: scrollOffsetNotifier.value > 60 ? 1 : 0,
              child: child,
            );
          },
        ),
      ],
      title: buildAppBarTitle(),
      flexibleSpace: buildFlexibleSpaceBar(searchTopMargin),
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
              style: TextStyle(
                fontFamilyFallback: Theme.of(context).textTheme.bodyText1?.fontFamilyFallback,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFlexibleSpaceBar(double searchTopMargin) {
    return FlexibleSpaceBar(
      collapseMode: CollapseMode.pin,
      background: Container(
        margin: EdgeInsets.only(top: searchTopMargin),
        padding: const EdgeInsets.symmetric(horizontal: ConfigConstant.margin2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ValueListenableBuilder(
              valueListenable: scrollOffsetNotifier,
              builder: (context, value, child) {
                double collapsed = 34 + mediaQueryData.padding.top;
                return IgnorePointer(
                  ignoring: scrollOffsetNotifier.value > collapsed,
                  child: AnimatedContainer(
                    duration: ConfigConstant.fadeDuration,
                    curve: Curves.ease,
                    decoration: BoxDecoration(
                      color: scrollOffsetNotifier.value > 8 ? colorScheme.primary : colorScheme.surface,
                      borderRadius: ConfigConstant.circlarRadius1,
                    ),
                    child: CgTextField(
                      borderSide: BorderSide.none,
                      hintText: scrollOffsetNotifier.value > 8 ? "" : "ស្វែងរកទីកន្លែង...",
                      fillColor: Colors.transparent,
                      onTap: () => searchButton.onPressed(context),
                      suffix: Opacity(
                        opacity: scrollOffsetNotifier.value > collapsed ? 0 : 1,
                        child: AnimatedContainer(
                          duration: ConfigConstant.fadeDuration,
                          curve: Curves.ease,
                          transform: Matrix4.identity()..translate(scrollOffsetNotifier.value > 8 ? 16.0 : 0.0, 0.0),
                          child: Icon(Icons.search, color: scrollOffsetNotifier.value > 8 ? colorScheme.surface : null),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
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
          initiallyDistrictExpanded:
              provinceExpansionTileInfo.containsKey(index) ? provinceExpansionTileInfo[index] == true : false,
          onDistrictExpansionChanged: (bool value) {
            provinceExpansionTileInfo[index] = value;
          },
        ),
      ),
    );
  }
}
