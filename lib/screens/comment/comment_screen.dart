import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/helpers/number_helper.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/models/comment/comment_list_model.dart';
import 'package:cambodia_geography/models/comment/comment_model.dart';
import 'package:cambodia_geography/models/places/place_model.dart';
import 'package:cambodia_geography/services/apis/comment/comment_api.dart';
import 'package:cambodia_geography/widgets/cg_bottom_nav_wrapper.dart';
import 'package:cambodia_geography/widgets/cg_custom_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({required this.place, Key? key}) : super(key: key);

  final PlaceModel place;

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> with CgThemeMixin {
  late CommentApi commentApi;
  late Future<CommentListModel>? commentListModel;

  @override
  void initState() {
    commentApi = CommentApi(id: widget.place.id ?? '');
    commentListModel = load();
    super.initState();
  }

  Future<CommentListModel> load() async {
    return await commentApi.fetchAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: FutureBuilder<CommentListModel>(
        future: commentListModel,
        builder: (context, snapshot) {
          List<CommentModel>? comments = snapshot.data?.items;
          if (comments == null) return buildLoadingShimmer();
          return ListView.builder(
            itemCount: comments.length,
            itemBuilder: (context, index) {
              return buildComment(comment: comments[index]);
            },
          );
        },
      ),
      bottomNavigationBar: CgBottomNavWrapper(
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            radius: 24,
            backgroundColor: colorScheme.surface,
            foregroundImage: NetworkImage(
              'https://lh5.googleusercontent.com/proxy/PigxOVqG50fy57LwMQ2bBdvp09o93GgNLwLYLxUsW-9IW7MEkeJySNjZX_ikleNQalqnso0L8RJ3212xKWdkhAiuMmCvFQCkIkFyUT9kaTwlJyg=s0-d',
            ),
          ),
          title: TextField(
            decoration: InputDecoration(
              hintText: 'មតិយោបល់របស់អ្នក...',
              border: InputBorder.none,
            ),
          ),
          trailing: Icon(
            Icons.send,
            color: colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Widget buildComment({
    required CommentModel comment,
  }) {
    String date = DateFormat('dd MMM, yyyy, hh:mm a').format(comment.createdAt!);
    return Column(
      children: [
        ListTile(
          tileColor: colorScheme.surface,
          dense: false,
          contentPadding: EdgeInsets.symmetric(
            vertical: ConfigConstant.margin1,
            horizontal: ConfigConstant.margin1,
          ),
          leading: CircleAvatar(
            radius: 36,
            backgroundColor: colorScheme.surface,
            foregroundImage: NetworkImage(
              comment.user?.profileImg?.url ?? '',
            ),
          ),
          title: Text(
            (comment.user?.username.toString() ?? '') + ' • ' + date,
            style: textTheme.caption,
          ),
          subtitle: Text(
            comment.comment ?? '',
            style: textTheme.caption,
          ),
        ),
        Divider(height: 0),
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
          style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
                color: colorScheme.onSurface,
              ),
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

  Widget buildLoadingShimmer() {
    return ListView(
      children: List.generate(widget.place.commentLength ?? 0, (index) {
        return Column(
          children: [
            ListTile(
              tileColor: colorScheme.surface,
              contentPadding: EdgeInsets.symmetric(
                vertical: ConfigConstant.margin2,
                horizontal: ConfigConstant.margin1,
              ),
              leading: CgCustomShimmer(
                child: CircleAvatar(
                  radius: 36,
                  backgroundColor: colorScheme.surface,
                ),
              ),
              title: Row(
                children: [
                  buildTextShimmer(),
                ],
              ),
            ),
            Divider(height: 0),
          ],
        );
      }),
    );
  }

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
