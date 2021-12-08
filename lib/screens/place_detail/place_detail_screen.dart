import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cambodia_geography/cambodia_geography.dart';
import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/widgets_exports.dart';
import 'package:cambodia_geography/mixins/cg_media_query_mixin.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/models/places/place_model.dart';
import 'package:cambodia_geography/screens/place_detail/local_widgets/place_title.dart';
import 'package:cambodia_geography/services/apis/bookmarks/bookmark_api.dart';
import 'package:cambodia_geography/utils/translation_utils.dart';
import 'package:cambodia_geography/widgets/cg_bottom_nav_wrapper.dart';
import 'package:cambodia_geography/widgets/cg_markdown_body.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  double get expandedHeight => MediaQuery.of(context).size.width;

  @override
  void initState() {
    geo = CambodiaGeography.instance;
    place = widget.place;

    scrollController = ScrollController();
    pageController = PageController();

    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    scrollController.dispose();
    super.dispose();
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
            scrollController: scrollController,
            title: place.nameTr ?? "",
            images: place.images?.map((e) => e.url ?? '').toList() ?? [],
          ),
          buildBody(),
        ],
      ),
    );
  }

  SliverList buildBody() {
    return SliverList(
      delegate: SliverChildListDelegate([
        PlaceTitle(
          title: place.nameTr ?? "",
          provinceCode: place.provinceCode,
          lat: place.lat,
          lon: place.lon,
          place: place,
        ),
        Container(
          color: colorScheme.surface,
          margin: const EdgeInsets.symmetric(vertical: ConfigConstant.margin2),
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: ConfigConstant.margin2),
          child: CgMarkdownBody(place.body ?? ""),
        ),
        const SizedBox(height: ConfigConstant.objectHeight1)
      ]),
    );
  }

  Widget buildBottomNavigationBar() {
    return CgBottomNavWrapper(
      child: Row(
        children: [
          IconButton(
            onPressed: () async {
              if (place.id == null) return;
              await Navigator.pushNamed(
                context,
                RouteConfig.COMMENT,
                arguments: place,
              );
            },
            icon: Icon(
              Icons.mode_comment,
              color: colorScheme.primary,
            ),
          ),
          Text(
            numberTr(place.commentLength != null ? place.commentLength : "..."),
            style: textTheme.caption,
          ),
          const Spacer(),
          // IconButton(
          //   onPressed: () {},
          //   icon: Icon(
          //     Icons.share,
          //     color: colorScheme.primary,
          //   ),
          // ),
          IconButton(
            onPressed: () async {
              if (place.id == null) return;
              BookmarkApi bookmarkApi = BookmarkApi();
              await bookmarkApi.addPlace(place.id!);
              if (bookmarkApi.success()) {
                Fluttertoast.showToast(msg: tr('msg.place_added_to_bookmark'));
              } else {
                showOkAlertDialog(
                  context: context,
                  title: tr('msg.error'),
                  message: bookmarkApi.message() ?? tr('msg.fail'),
                );
              }
            },
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
