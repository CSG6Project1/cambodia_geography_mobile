import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/mixins/cg_media_query_mixin.dart';
import 'package:cambodia_geography/screens/place_detail/local_widgets/images_presentor.dart';

class CgImageAppBar extends StatefulWidget {
  const CgImageAppBar({
    Key? key,
    required this.expandedHeight,
    required this.pageController,
    required this.title,
    required this.images,
    required this.scrollController,
    this.actions = const [],
  }) : super(key: key);

  final double expandedHeight;
  final PageController pageController;
  final ScrollController scrollController;
  final String title;
  final List<String> images;
  final List<Widget> actions;

  @override
  _CgImageAppBarState createState() => _CgImageAppBarState();
}

class _CgImageAppBarState extends State<CgImageAppBar> with CgMediaQueryMixin {
  late ValueNotifier<bool> isCollapsedNotifier;

  @override
  void initState() {
    isCollapsedNotifier = ValueNotifier(false);
    widget.scrollController.addListener(() {
      isCollapsedNotifier.value =
          widget.scrollController.hasClients && widget.scrollController.offset > mediaQueryData.size.width;
    });
    super.initState();
  }

  @override
  void dispose() {
    isCollapsedNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: 0,
      expandedHeight: widget.expandedHeight,
      collapsedHeight: kToolbarHeight,
      pinned: true,
      floating: false,
      stretch: true,
      title: buildAppBarTitle(),
      flexibleSpace: buildFlexibleSpace(context),
      actions: widget.actions,
    );
  }

  Widget buildFlexibleSpace(BuildContext context) {
    return FlexibleSpaceBar(
      background: ImagesPresentor(
        images: widget.images,
        controller: widget.pageController,
      ),
    );
  }

  Widget buildAppBarTitle() {
    return ValueListenableBuilder(
      valueListenable: isCollapsedNotifier,
      child: CgAppBarTitle(title: widget.title),
      builder: (context, value, child) {
        return AnimatedOpacity(
          duration: ConfigConstant.fadeDuration,
          curve: Curves.ease,
          opacity: isCollapsedNotifier.value ? 1 : 0,
          child: child,
        );
      },
    );
  }
}
