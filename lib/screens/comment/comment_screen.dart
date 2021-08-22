import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/helpers/number_helper.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/models/comment/comment_list_model.dart';
import 'package:cambodia_geography/models/comment/comment_model.dart';
import 'package:cambodia_geography/models/image_model.dart';
import 'package:cambodia_geography/models/places/place_model.dart';
import 'package:cambodia_geography/models/user/user_model.dart';
import 'package:cambodia_geography/providers/user_provider.dart';
import 'package:cambodia_geography/services/apis/comment/comment_api.dart';
import 'package:cambodia_geography/services/apis/comment/crud_comment_api.dart';
import 'package:cambodia_geography/widgets/cg_bottom_nav_wrapper.dart';
import 'package:cambodia_geography/widgets/cg_custom_shimmer.dart';
import 'package:cambodia_geography/widgets/cg_load_more_list.dart';
import 'package:cambodia_geography/widgets/cg_measure_size.dart';
import 'package:cambodia_geography/widgets/cg_network_image_loader.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({required this.place, Key? key}) : super(key: key);

  final PlaceModel place;

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> with CgThemeMixin {
  late CommentApi commentApi;
  late CrudCommentApi crudCommentApi;
  late TextEditingController textController;
  late ScrollController scrollController;
  CommentListModel? commentListModel;
  List<CommentModel>? comments;

  @override
  void initState() {
    textController = TextEditingController();
    scrollController = ScrollController();
    commentApi = CommentApi(id: widget.place.id ?? '');
    crudCommentApi = CrudCommentApi();
    super.initState();
    load();
  }

  @override
  void dispose() {
    scrollController.dispose();
    textController.dispose();
    super.dispose();
  }

  Future<void> load({bool loadMore = false}) async {
    if (loadMore && !(commentListModel?.hasLoadMore() == true)) return;
    String? page = commentListModel?.links?.getPageNumber().next.toString();
    final result = await commentApi.fetchAll(queryParameters: {'page': page});
    if (commentApi.success() && result != null) {
      setState(() {
        if (commentListModel != null)
          commentListModel?.add(result);
        else
          commentListModel = result;
      });
    }
  }

  Future<void> createComment(String commentMsg) async {
    if (widget.place.id == null) return;
    if (commentMsg.length == 0) return;
    await crudCommentApi.createComment(
      placeId: widget.place.id!,
      comment: commentMsg,
    );
    if (crudCommentApi.success()) {
      var newComment = CommentModel(
        comment: commentMsg,
        createdAt: DateTime.now(),
        user: UserModel(
          role: '',
          profileImg: ImageModel(
            url:
                'https://res.cloudinary.com/cambodia-geography/image/upload/v1627748799/images/mqmrlezgbjqzdtpyvils.jpg',
          ),
        ),
      );
      setState(() {
        comments?.insert(0, newComment);
      });
      scrollController.animateTo(
        0,
        duration: ConfigConstant.duration,
        curve: Curves.ease,
      );
    } else
      showOkAlertDialog(context: context, title: 'Comment failed');
    textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    comments = commentListModel?.items;
    return Scaffold(
      appBar: buildAppBar(context),
      body: CgLoadMoreList(
        onEndScroll: () => load(loadMore: true),
        child: CgMeasureSize(
          onChange: (size) {
            if (size.height < MediaQuery.of(context).size.height) load(loadMore: true);
          },
          child: ListView.builder(
            controller: scrollController,
            itemCount: comments?.length ?? 10,
            itemBuilder: (context, index) {
              if (comments?.length == index) {
                return Visibility(
                  visible: commentListModel?.hasLoadMore() == true,
                  child: Container(
                    alignment: Alignment.center,
                    padding: ConfigConstant.layoutPadding,
                    child: const CircularProgressIndicator(),
                  ),
                );
              }
              return buildComment(comment: comments?[index]);
            },
          ),
        ),
      ),
      bottomNavigationBar: CgBottomNavWrapper(
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(ConfigConstant.objectHeight1),
            child: Container(
              color: colorScheme.background,
              child: Consumer<UserProvider>(
                builder: (context, provider, child) {
                  return CgNetworkImageLoader(
                    imageUrl: provider.user?.profileImg?.url,
                    width: ConfigConstant.objectHeight1,
                    height: ConfigConstant.objectHeight1,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ),
          title: TextField(
            controller: textController,
            decoration: InputDecoration(
              hintText: 'មតិយោបល់របស់អ្នក...',
              border: InputBorder.none,
            ),
            onSubmitted: (comment) {
              createComment(comment);
            },
          ),
          trailing: IconButton(
            onPressed: () {
              createComment(textController.text);
            },
            icon: Icon(
              Icons.send,
              color: colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildComment({
    required CommentModel? comment,
  }) {
    String date = comment?.createdAt != null ? DateFormat('dd MMM, yyyy, hh:mm a').format(comment!.createdAt!) : "";
    return Column(
      children: [
        ListTile(
          tileColor: colorScheme.surface,
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(ConfigConstant.objectHeight1),
            child: Container(
              color: colorScheme.background,
              child: CgNetworkImageLoader(
                imageUrl: comment?.user?.profileImg?.url,
                width: ConfigConstant.objectHeight1,
                height: ConfigConstant.objectHeight1,
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: AnimatedCrossFade(
            duration: ConfigConstant.fadeDuration,
            crossFadeState: comment != null ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: Text(
              comment?.user?.username != null
                  ? (comment?.user?.username.toString() ?? '') + ' • ' + date
                  : "CamGeo's User",
              style: textTheme.caption,
            ),
            secondChild: CgCustomShimmer(
              child: Container(
                color: colorScheme.surface,
                width: 100,
                height: 12,
              ),
            ),
          ),
          subtitle: AnimatedCrossFade(
            duration: ConfigConstant.fadeDuration,
            crossFadeState: comment?.comment != null ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: Text(
              comment?.comment ?? '',
              style: textTheme.caption,
            ),
            secondChild: CgCustomShimmer(
              child: Container(
                color: colorScheme.surface,
                width: 48,
                height: 12,
              ),
            ),
          ),
        ),
        const Divider(height: 0),
      ],
    );
  }

  MorphingAppBar buildAppBar(BuildContext context) {
    return MorphingAppBar(
      backgroundColor: colorScheme.surface,
      elevation: 0.5,
      automaticallyImplyLeading: false,
      title: RichText(
        text: TextSpan(
          text: 'មតិយោបល់ ',
          style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(color: colorScheme.onSurface),
          children: [
            TextSpan(
              text: '• ' + NumberHelper.toKhmer(widget.place.commentLength),
              style: TextStyle(
                color: textTheme.caption?.color,
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.close,
            color: colorScheme.primary,
          ),
        )
      ],
    );
  }

  // Widget buildLoadingShimmer() {
  //   return ListView(
  //     children: List.generate(widget.place.commentLength ?? 0, (index) {
  //       return Column(
  //         children: [
  //           ListTile(
  //             tileColor: colorScheme.surface,
  //             contentPadding: EdgeInsets.symmetric(
  //               vertical: ConfigConstant.margin2,
  //               horizontal: ConfigConstant.margin1,
  //             ),
  //             leading: CgCustomShimmer(
  //               child: CircleAvatar(
  //                 radius: 36,
  //                 backgroundColor: colorScheme.surface,
  //               ),
  //             ),
  //             title: Row(
  //               children: [
  //                 buildTextShimmer(),
  //               ],
  //             ),
  //           ),
  //           Divider(height: 0),
  //         ],
  //       );
  //     }),
  //   );
  // }

  CgCustomShimmer buildTextShimmer() {
    return CgCustomShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: colorScheme.surface,
            width: 100,
            height: 12,
          ),
          SizedBox(height: ConfigConstant.margin1),
          Container(
            color: colorScheme.surface,
            width: 250,
            height: 12,
          ),
        ],
      ),
    );
  }
}
