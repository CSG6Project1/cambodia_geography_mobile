import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/screens/place_detail/local_widgets/images_presentor.dart';

class CgImageAppBar extends StatelessWidget {
  const CgImageAppBar({
    Key? key,
    required this.expandedHeight,
    required this.pageController,
    required this.title,
    required this.images,
  }) : super(key: key);

  final double expandedHeight;
  final PageController pageController;
  final String title;
  final List<String> images;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: 0,
      expandedHeight: expandedHeight,
      collapsedHeight: kToolbarHeight,
      pinned: true,
      floating: false,
      stretch: true,
      title: buildAppBarTitle(),
      flexibleSpace: buildFlexibleSpace(),
    );
  }

  Widget buildFlexibleSpace() {
    // List<String> images = place.images?.map((e) => e.url ?? '').toList() ?? [];
    return FlexibleSpaceBar(
      background: ImagesPresentor(
        images: images,
        controller: pageController,
      ),
    );
  }

  Widget buildAppBarTitle() {
    return CgAppBarTitle(title: title);
  }
}
