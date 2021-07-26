import 'package:cambodia_geography/cambodia_geography.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/widgets_exports.dart';
import 'package:cambodia_geography/helpers/number_helper.dart';
import 'package:cambodia_geography/mixins/cg_media_query_mixin.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/models/places/place_model.dart';
import 'package:cambodia_geography/screens/place_detail/local_widgets/images_presentor.dart';
import 'package:cambodia_geography/screens/place_detail/local_widgets/place_title.dart';
import 'package:cambodia_geography/widgets/cg_bottom_nav_wrapper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class PlaceDetailScreen extends StatefulWidget {
  const PlaceDetailScreen({
    required this.place,
    Key? key,
  }) : super(key: key);

  final PlaceModel place;

  @override
  _PlaceDetailScreenState createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> with CgThemeMixin, CgMediaQueryMixin {
  late ScrollController scrollController;
  late PageController pageController;
  late CambodiaGeography geo;
  late PlaceModel place;

  late ValueNotifier<bool> initedFlexibleSpaceNotifier;
  late ValueNotifier<double> headerOpacityNotifier;

  double get expandedHeight => MediaQuery.of(context).size.width * 9 / 16 - kToolbarHeight;

  @override
  void initState() {
    geo = CambodiaGeography.instance;
    place = widget.place;

    scrollController = ScrollController();
    pageController = PageController();
    initedFlexibleSpaceNotifier = ValueNotifier(false);
    headerOpacityNotifier = ValueNotifier(0.0);
    scrollController.addListener(_scrollListener);
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback(
      (timeStamp) async {
        await Future.delayed(Duration(milliseconds: 500));
        initedFlexibleSpaceNotifier.value = true;
      },
    );
  }

  void _scrollListener() {
    double offset = scrollController.offset - kToolbarHeight * 2;
    double maxHeight = expandedHeight;
    if (offset >= maxHeight) offset = maxHeight;
    if (offset <= 0) offset = 0;
    headerOpacityNotifier.value = offset / maxHeight;
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    pageController.dispose();
    super.dispose();

    initedFlexibleSpaceNotifier.dispose();
    headerOpacityNotifier.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: buildBottomNavigationBar(),
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          buildAppBar(),
          buildBody(),
        ],
      ),
    );
  }

  SliverList buildBody() {
    return SliverList(
      delegate: SliverChildListDelegate([
        PlaceTitle(place: place),
        Container(
          color: colorScheme.surface,
          margin: const EdgeInsets.symmetric(vertical: ConfigConstant.margin2),
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: ConfigConstant.margin2),
          child: MarkdownBody(
            data: place.body.toString(),
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
          ),
        ),
        const SizedBox(height: ConfigConstant.objectHeight1)
      ]),
    );
  }

  MorphingSliverAppBar buildAppBar() {
    return MorphingSliverAppBar(
      elevation: 0,
      expandedHeight: expandedHeight,
      collapsedHeight: kToolbarHeight,
      pinned: true,
      floating: true,
      stretch: true,
      title: buildAppBarTitle(),
      flexibleSpace: buildFlexibleSpace(),
    );
  }

  Widget buildFlexibleSpace() {
    List<String> images = place.images?.map((e) => e.url ?? '').toList() ?? [];
    Widget child = FlexibleSpaceBar(
      background: ImagesPresentor(
        images: images,
        controller: pageController,
      ),
    );
    return ValueListenableBuilder(
      child: child,
      valueListenable: initedFlexibleSpaceNotifier,
      builder: (context, value, child) {
        return AnimatedOpacity(
          opacity: initedFlexibleSpaceNotifier.value ? 1 : 0,
          duration: ConfigConstant.fadeDuration,
          child: child,
        );
      },
    );
  }

  Widget buildAppBarTitle() {
    Widget child = CgAppBarTitle(title: place.khmer.toString());
    return ValueListenableBuilder<double>(
      child: child,
      valueListenable: headerOpacityNotifier,
      builder: (context, value, child) {
        return Opacity(
          opacity: headerOpacityNotifier.value,
          child: child,
        );
      },
    );
  }

  Widget buildBottomNavigationBar() {
    return CgBottomNavWrapper(
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.mode_comment,
              color: colorScheme.primary,
            ),
          ),
          Text(
            NumberHelper.toKhmer((place.commentLength ?? 0).toString()),
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
