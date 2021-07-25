import 'package:cambodia_geography/cambodia_geography.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/widgets_exports.dart';
import 'package:cambodia_geography/helper/number_helper.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/models/places/place_model.dart';
import 'package:cambodia_geography/screens/place_detail/local_widgets/place_title.dart';
import 'package:cambodia_geography/widgets/cg_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:page_indicator/page_indicator.dart';

class PlaceDetailScreen extends StatefulWidget {
  const PlaceDetailScreen({
    required this.place,
    Key? key,
  }) : super(key: key);

  final PlaceModel place;

  @override
  _PlaceDetailScreenState createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> with CgThemeMixin {
  late ScrollController scrollController;
  late PageController pageController;
  late bool isShow;
  late CambodiaGeography geo;

  @override
  void initState() {
    scrollController = ScrollController();
    pageController = PageController();
    geo = CambodiaGeography.instance;
    isShow = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PlaceModel place = widget.place;
    scrollController.addListener(() {
      if (scrollController.offset >= MediaQuery.of(context).size.width / 2)
        setState(() => isShow = true);
      else
        setState(() => isShow = false);
    });
    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          buildAppBar(context: context, place: place),
          buildBody(place),
        ],
      ),
      bottomNavigationBar: buildBottomNav(place),
    );
  }

  Container buildBottomNav(PlaceModel place) {
    return Container(
      height: ConfigConstant.objectHeight4,
      padding: EdgeInsets.only(
        bottom: ConfigConstant.margin2,
        left: 18,
        right: 18,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              print('object');
            },
            icon: Icon(
              Icons.mode_comment,
              color: colorScheme.primary,
            ),
          ),
          Text(
            NumberHelper.toKhmer((place.commentLength ?? 0).toString()),
            style: textTheme.caption,
          ),
          Expanded(child: SizedBox()),
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

  SliverList buildBody(PlaceModel place) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          PlaceTitle(place: place),
          Container(
            margin: EdgeInsets.symmetric(vertical: ConfigConstant.margin2),
            padding: EdgeInsets.all(ConfigConstant.margin2),
            color: colorScheme.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${place.khmer}',
                  style: textTheme.headline6?.copyWith(fontWeight: FontWeight.w700, color: Colors.grey),
                ),
                MarkdownBody(
                  data: place.body.toString(),
                  styleSheet: MarkdownStyleSheet.fromTheme(
                    ThemeData(
                      textTheme: TextTheme(
                        bodyText2: TextStyle(fontSize: 12.0, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar buildAppBar({
    required BuildContext context,
    required PlaceModel place,
  }) {
    final double expandedHeight = MediaQuery.of(context).size.width / 2;
    var onViewImage = () {
      showModalBottomSheet(
        context: context,
        useRootNavigator: true,
        isScrollControlled: true,
        backgroundColor: Colors.black,
        barrierColor: Colors.transparent,
        builder: (context) {
          List<String> images = place.images!.map((e) => e.url ?? '').toList();
          return ImageViewer(
            images: images,
            statusBarHeight: MediaQuery.of(context).padding.top,
            currentImageIndex: pageController.page!.toInt(),
            onPageChanged: (index) {
              pageController.animateToPage(
                index,
                duration: ConfigConstant.duration,
                curve: Curves.easeIn,
              );
            },
          );
        },
      );
    };
    return SliverAppBar(
      elevation: 0,
      brightness: isShow ? Brightness.dark : Brightness.light,
      backgroundColor: isShow ? colorScheme.primary : Colors.transparent,
      expandedHeight: expandedHeight,
      collapsedHeight: kToolbarHeight,
      pinned: true,
      floating: true,
      leading: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(left: ConfigConstant.margin2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isShow ? Colors.transparent : Colors.black26,
        ),
        child: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: CgAppBarTitle(
          title: isShow ? place.khmer.toString() : '',
        ),
        background: GestureDetector(
          onTap: onViewImage,
          child: PageIndicatorContainer(
            padding: const EdgeInsets.only(bottom: ConfigConstant.margin2),
            indicatorColor: Theme.of(context).colorScheme.surface,
            indicatorSelectorColor: Theme.of(context).colorScheme.onSurface,
            length: place.images?.length ?? 0,
            shape: IndicatorShape.roundRectangleShape(
              size: const Size(8, 8),
              cornerSize: Size.square(4),
            ),
            child: PageView(
              controller: pageController,
              onPageChanged: (index) {},
              children: List.generate(place.images?.length ?? 0, (index) {
                return Container(
                  child: Image.network(
                    place.images?[index].url ?? '',
                    fit: BoxFit.cover,
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
