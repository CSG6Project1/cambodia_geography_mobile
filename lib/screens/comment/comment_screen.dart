import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cambodia_geography/app.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/helpers/date_helper.dart';
import 'package:cambodia_geography/helpers/number_helper.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/models/comment/comment_list_model.dart';
import 'package:cambodia_geography/models/comment/comment_model.dart';
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
import 'package:cambodia_geography/widgets/cg_no_data_wrapper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  late bool loading;

  late ValueNotifier<bool> isTextEmptyNotifier;

  @override
  void initState() {
    loading = false;
    textController = TextEditingController();
    isTextEmptyNotifier = ValueNotifier(true);
    scrollController = ScrollController();
    commentApi = CommentApi(id: widget.place.id ?? '');
    crudCommentApi = CrudCommentApi();
    super.initState();
    load();

    textController.addListener(() {
      isTextEmptyNotifier.value = textController.text.trim().isEmpty;
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    isTextEmptyNotifier.dispose();
    super.dispose();
  }

  Future<void> load({bool loadMore = false}) async {
    if (loadMore && !(commentListModel?.hasLoadMore() == true)) return;
    String? page = commentListModel?.links?.getPageNumber().next.toString();
    final result = await commentApi.fetchAll(queryParameters: {'page': loadMore ? page : null});
    if (commentApi.success() && result != null) {
      setState(() {
        loading = false;
        if (commentListModel != null && loadMore) {
          commentListModel?.add(result);
        } else {
          commentListModel = result;
        }
      });
    }
  }

  Future<void> createComment(String commentMsg) async {
    if (widget.place.id == null) return;
    if (commentMsg.length == 0) return;
    UserModel? user = context.read<UserProvider>().user;
    CommentModel cmm = CommentModel(
      comment: commentMsg,
      user: user,
      createdAt: DateTime.now(),
    );
    setState(() {
      commentListModel?.items?.insert(commentListModel?.items?.length ?? 0, cmm);
      loading = true;
    });
    textController.clear();
    FocusScope.of(context).unfocus();
    await crudCommentApi.createComment(
      placeId: widget.place.id!,
      comment: commentMsg,
    );
    if (crudCommentApi.success()) {
      await load();
      Fluttertoast.showToast(msg: 'Comment uploaded');
      scrollController.animateTo(0, duration: ConfigConstant.duration, curve: Curves.ease);
    } else
      showOkAlertDialog(context: context, title: 'Comment failed', message: crudCommentApi.message());
  }

  Future<void> onTapCommentOption(CommentModel? comment) async {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.user?.id == null || comment?.user?.id == null) return;
    if (comment?.user?.id == userProvider.user!.id) {
      var option = await showModalActionSheet<String>(
        context: context,
        actions: [
          SheetAction(label: 'Edit', key: 'edit'),
          SheetAction(
            label: 'Delete',
            key: 'delete',
            isDestructiveAction: true,
          ),
        ],
      );
      if (option == 'delete') {
        OkCancelResult result = await showOkCancelAlertDialog(
          context: context,
          title: 'Delete comment',
          isDestructiveAction: true,
          okLabel: 'Delete',
        );
        if (comment?.id == null) return;
        if (result == OkCancelResult.ok) {
          App.of(context)?.showLoading();
          await crudCommentApi.deleteComment(id: comment!.id.toString());
          if (crudCommentApi.success()) {
            await load();
            Fluttertoast.showToast(msg: 'Comment deleted');
            App.of(context)?.hideLoading();
          } else
            showOkAlertDialog(context: context, title: 'Comment failed');
        }
      } else if (option == 'edit') {
        var commentUpdate = await showTextInputDialog(
          context: context,
          title: 'Edit comment',
          textFields: [
            DialogTextField(
              initialText: comment?.comment.toString(),
              maxLines: 10,
              minLines: 1,
            ),
          ],
        );
        if (commentUpdate == null || comment?.id == null) return;
        App.of(context)?.showLoading();
        await crudCommentApi.updateComment(id: comment!.id!, comment: commentUpdate.first);
        if (crudCommentApi.success()) {
          await load();
          Fluttertoast.showToast(msg: 'Comment updated');
        } else {
          await showOkAlertDialog(
            context: context,
            title: 'Comment failed',
            message: crudCommentApi.message(),
          );
        }
        App.of(context)?.hideLoading();
      }
    } else
      await showModalActionSheet(
        context: context,
        actions: [
          SheetAction(
            label: 'Report',
            isDestructiveAction: true,
          ),
        ],
      );
  }

  @override
  Widget build(BuildContext context) {
    comments = commentListModel?.items;
    return Scaffold(
      appBar: buildAppBar(context),
      body: RefreshIndicator(
        onRefresh: () => load(),
        child: CgNoDataWrapper(
          isNoData: comments?.isEmpty == true,
          child: CgLoadMoreList(
            onEndScroll: () => load(loadMore: true),
            child: CgMeasureSize(
              onChange: (size) {
                if (size.height < MediaQuery.of(context).size.height) load(loadMore: true);
              },
              child: ListView.builder(
                key: listKey,
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                controller: scrollController,
                itemCount: comments?.length ?? 10,
                itemBuilder: (context, index) {
                  if (comments?.length == index) {
                    return Visibility(
                      key: Key('$index'),
                      visible: commentListModel?.hasLoadMore() == true,
                      child: Container(
                        alignment: Alignment.center,
                        padding: ConfigConstant.layoutPadding,
                        child: const CircularProgressIndicator(),
                      ),
                    );
                  }
                  return buildComment(
                    comment: comments?[index],
                    isLastIndex: index == (comments?.length ?? 0) - 1,
                  );
                },
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: CgBottomNavWrapper(
        padding: const EdgeInsets.symmetric(
          horizontal: ConfigConstant.margin2,
          vertical: ConfigConstant.margin1,
        ).copyWith(right: 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ClipRRect(
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
            Expanded(
              child: CgTextField(
                controller: textController,
                hintText: 'មតិយោបល់របស់អ្នក...',
                maxLines: 5,
                minLines: 1,
                fillColor: Colors.transparent,
                borderSide: BorderSide.none,
                onSubmitted: (comment) {
                  createComment(comment);
                },
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: ValueListenableBuilder<bool>(
                valueListenable: isTextEmptyNotifier,
                builder: (context, isTextEmpty, child) {
                  return AnimatedCrossFade(
                    sizeCurve: Curves.ease,
                    duration: ConfigConstant.fadeDuration,
                    crossFadeState: isTextEmptyNotifier.value ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                    secondChild: const SizedBox(height: ConfigConstant.objectHeight1),
                    firstChild: Container(
                      child: IconButton(
                        icon: Icon(Icons.send, color: colorScheme.primary),
                        onPressed: () async {
                          await createComment(textController.text);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildComment({
    required CommentModel? comment,
    required bool isLastIndex,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            vertical: ConfigConstant.margin1,
            horizontal: ConfigConstant.margin2,
          ),
          tileColor: colorScheme.surface,
          onLongPress: () => onTapCommentOption(comment),
          leading: buildProfilePic(comment?.user?.profileImg?.url),
          title: loading && isLastIndex ? CgCustomShimmer(child: buildCommentText(comment)) : buildCommentText(comment),
        ),
        if (!isLastIndex) const Divider(height: 0),
      ],
    );
  }

  Widget buildCommentText(CommentModel? comment) {
    String date = comment?.createdAt != null
        ? DateHelper.displayDateByDate(comment!.createdAt!, locale: context.locale.languageCode)
        : "";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedCrossFade(
          duration: ConfigConstant.fadeDuration,
          crossFadeState: comment != null ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: Container(
            width: double.infinity,
            child: Text(
              comment?.user?.username != null
                  ? (comment?.user?.username.toString() ?? '') + ' • ' + date
                  : "CamGeo's User" + ' • ' + date,
              style: textTheme.caption,
            ),
          ),
          secondChild: CgCustomShimmer(
            child: Row(
              children: [
                Container(
                  height: 12,
                  width: 100,
                  color: colorScheme.surface,
                ),
              ],
            ),
          ),
        ),
        AnimatedContainer(
          duration: ConfigConstant.fadeDuration,
          height: comment?.comment != null ? 0 : ConfigConstant.margin1,
        ),
        AnimatedCrossFade(
          duration: ConfigConstant.fadeDuration,
          crossFadeState: comment?.comment != null ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: Container(
            width: double.infinity,
            child: Text(
              comment?.comment ?? '',
              style: textTheme.bodyText2,
            ),
          ),
          secondChild: CgCustomShimmer(
            child: Row(
              children: [
                Container(
                  height: 12,
                  width: 120,
                  color: colorScheme.surface,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  ClipRRect buildProfilePic(String? image) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(ConfigConstant.objectHeight1),
      child: Container(
        width: ConfigConstant.objectHeight1,
        height: ConfigConstant.objectHeight1,
        color: colorScheme.background,
        child: CgNetworkImageLoader(
          imageUrl: image,
          width: ConfigConstant.objectHeight1,
          height: ConfigConstant.objectHeight1,
          fit: BoxFit.cover,
        ),
      ),
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
          style: textTheme.bodyText1,
          children: [
            TextSpan(
              text: '• ' + NumberHelper.toKhmer(commentListModel?.meta?.totalCount ?? widget.place.commentLength),
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
}
