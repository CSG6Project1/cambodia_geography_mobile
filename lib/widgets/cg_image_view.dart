import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:flutter/material.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageViewer extends StatefulWidget {
  final List<String> images;
  final Function(int)? onPageChanged;
  final int currentImageIndex;
  final double statusBarHeight;

  const ImageViewer({
    Key? key,
    required this.images,
    required this.statusBarHeight,
    this.onPageChanged,
    this.currentImageIndex = 0,
  }) : super(key: key);

  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  late PageController pageController;
  late int pageIndex;
  @override
  void initState() {
    pageController = PageController();
    pageIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          PageIndicatorContainer(
            padding: const EdgeInsets.only(bottom: ConfigConstant.objectHeight1),
            shape: IndicatorShape.roundRectangleShape(size: const Size(8, 8), cornerSize: Size.square(4)),
            indicatorColor: Theme.of(context).colorScheme.secondary,
            indicatorSelectorColor: Theme.of(context).colorScheme.primary,
            length: widget.images.length,
            child: PhotoViewGallery.builder(
              itemCount: widget.images.length,
              pageController: pageController,
              onPageChanged: (value) {
                widget.onPageChanged!(value);
                pageIndex = value;
              },
              backgroundDecoration: BoxDecoration(color: Colors.transparent),
              builder: (context, index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(widget.images[index]),
                  initialScale: PhotoViewComputedScale.contained * 1,
                  maxScale: PhotoViewComputedScale.contained * 2.5,
                  minScale: PhotoViewComputedScale.contained * 1,
                  heroAttributes: PhotoViewHeroAttributes(tag: widget.images[index]),
                );
              },
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: AppBar(
                elevation: 0.0,
                automaticallyImplyLeading: true,
                backgroundColor: Colors.transparent,
                centerTitle: true,
                title: Text(
                  "${pageIndex + 1}/${widget.images.length}",
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
