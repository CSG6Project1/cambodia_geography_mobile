import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/utils/translation_utils.dart';
import 'package:cambodia_geography/widgets/cg_images_viewer.dart';
import 'package:cambodia_geography/widgets/cg_network_image_loader.dart';
import 'package:flutter/material.dart';

class ImagesPresentor extends StatefulWidget {
  const ImagesPresentor({
    Key? key,
    required this.images,
    required this.controller,
    this.onPageChanged,
  }) : super(key: key);

  final List<String> images;
  final PageController controller;
  final void Function(int)? onPageChanged;

  @override
  _ImagesPresentorState createState() => _ImagesPresentorState();
}

class _ImagesPresentorState extends State<ImagesPresentor> {
  late int? currentPage;

  @override
  void initState() {
    currentPage = widget.controller.hasClients ? widget.controller.page?.toInt() : 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.images.isNotEmpty) {
          onViewImages(widget.images);
        }
      },
      child: Stack(
        children: [
          AnimatedOpacity(
            opacity: widget.images.isNotEmpty == true ? 1 : 0,
            duration: ConfigConstant.fadeDuration,
            child: PageView(
              physics: const ClampingScrollPhysics(),
              controller: widget.controller,
              onPageChanged: (index) {
                if (widget.onPageChanged != null) widget.onPageChanged!(index);
                setState(() {
                  currentPage = index;
                });
              },
              children: List.generate(widget.images.length, (index) {
                return CgNetworkImageLoader(
                  imageUrl: widget.images[index],
                  fit: BoxFit.cover,
                );
              }),
            ),
          ),
          if (currentPage != null) buildPageIndicator(context),
        ],
      ),
    );
  }

  Positioned buildPageIndicator(BuildContext context) {
    return Positioned(
      right: ConfigConstant.margin2,
      bottom: ConfigConstant.margin1,
      child: AnimatedCrossFade(
        duration: ConfigConstant.duration,
        crossFadeState: widget.images.length > 0 ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        sizeCurve: Curves.ease,
        firstChild: Container(
          child: Text(
            numberTr("${currentPage! + 1}/${widget.images.length}"),
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          padding: const EdgeInsets.symmetric(horizontal: ConfigConstant.margin1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ConfigConstant.objectHeight1),
            color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
          ),
        ),
        secondChild: const SizedBox(width: ConfigConstant.objectHeight1),
      ),
    );
  }

  Future<void> onViewImages(List<String> images) async {
    BuildContext parentContext = context;
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.9),
      context: context,
      transitionDuration: ConfigConstant.fadeDuration,
      pageBuilder: (context, anim1, anim2) {
        return Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0.0,
            automaticallyImplyLeading: true,
            backgroundColor: Colors.transparent,
            centerTitle: true,
            leading: const CloseButton(),
          ),
          body: Dismissible(
            direction: DismissDirection.vertical,
            key: const Key('key'),
            onDismissed: (_) => Navigator.of(context).pop(),
            child: Theme(
              data: Theme.of(parentContext),
              child: CgImagesViewer(
                imagesUrl: images,
                openAnimation: anim1,
                closeAnimation: anim2,
                statusBarHeight: MediaQuery.of(context).padding.top,
                currentImageIndex: currentPage ?? 0,
                onPageChanged: (index) {
                  widget.controller.animateToPage(
                    index,
                    duration: ConfigConstant.duration,
                    curve: Curves.easeIn,
                  );
                  if (widget.onPageChanged != null) {
                    widget.onPageChanged!(index);
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
