import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/screens/place_detail/local_widgets/images_presentor.dart';
import 'package:cambodia_geography/widgets/cg_custom_shimmer.dart';

class CgImageAppBar extends StatelessWidget {
  const CgImageAppBar({
    Key? key,
    required this.expandedHeight,
    required this.pageController,
    required this.title,
    required this.images,
    required this.loading,
  }) : super(key: key);

  final double expandedHeight;
  final PageController pageController;
  final String title;
  final List<String> images;
  final bool loading;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: 0,
      expandedHeight: expandedHeight,
      collapsedHeight: kToolbarHeight,
      pinned: true,
      floating: false,
      stretch: true,
      title: loading ? SizedBox() : buildAppBarTitle(),
      flexibleSpace: buildFlexibleSpace(context),
    );
  }

  Widget buildFlexibleSpace(BuildContext context) {
    return FlexibleSpaceBar(
      background: loading
          ? CgCustomShimmer(
              child: Container(
                height: MediaQuery.of(context).size.width,
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).colorScheme.surface,
              ),
            )
          : ImagesPresentor(
              images: images,
              controller: pageController,
            ),
    );
  }

  Widget buildAppBarTitle() {
    return CgAppBarTitle(title: title);
  }
}
