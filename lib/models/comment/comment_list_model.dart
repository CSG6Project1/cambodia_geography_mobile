import 'package:cambodia_geography/models/apis/base_list_model.dart';
import 'package:cambodia_geography/models/apis/links_model.dart';
import 'package:cambodia_geography/models/apis/meta_model.dart';
import 'package:cambodia_geography/models/comment/comment_model.dart';

class CommentListModel extends BaseListModel<CommentModel> {
  CommentListModel({
    List<CommentModel>? items,
    MetaModel? meta,
    LinksModel? links,
  }) : super(items: items, meta: meta, links: links);
}
