import 'package:cambodia_geography/models/comment/comment_list_model.dart';
import 'package:cambodia_geography/models/comment/comment_model.dart';
import 'package:cambodia_geography/services/apis/base_app_api.dart';

class CommentApi extends BaseAppApi<CommentModel> {
  CommentApi({required this.id});
  final String id;

  @override
  String get nameInUrl => "places/$id/comments";

  @override
  CommentModel objectTransformer(Map<String, dynamic> json) {
    return CommentModel.fromJson(json);
  }

  @override
  CommentListModel itemsTransformer(Map<String, dynamic> json) {
    return CommentListModel(
      items: buildItems(json),
      meta: buildMeta(json),
      links: buildLinks(json),
    );
  }
}
