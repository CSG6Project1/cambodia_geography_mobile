import 'dart:convert';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/widgets_exports.dart';
import 'package:cambodia_geography/mixins/cg_media_query_mixin.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:delta_markdown/delta_markdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:swipeable_page_route/swipeable_page_route.dart';

class BodyEditorScreen extends StatefulWidget {
  const BodyEditorScreen({
    Key? key,
    required this.body,
  }) : super(key: key);

  final String body;

  @override
  _BodyEditorScreenState createState() => _BodyEditorScreenState();
}

class _BodyEditorScreenState extends State<BodyEditorScreen> with CgThemeMixin, CgMediaQueryMixin {
  late quill.QuillController controller;
  late ScrollController scrollController;
  late FocusNode focusNode;

  @override
  void initState() {
    focusNode = FocusNode();
    try {
      String body = markdownToDelta(widget.body);
      dynamic json = jsonDecode(body);
      controller = quill.QuillController(
        document: quill.Document.fromJson(json),
        selection: TextSelection.collapsed(offset: 0),
      );
    } catch (e) {
      controller = quill.QuillController.basic();
    }
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: MorphingAppBar(
          title: Text("Body"),
          actions: [
            CgButton(
              labelText: "Save",
              foregroundColor: colorScheme.onPrimary,
              onPressed: () {
                var json = jsonEncode(controller.document.toDelta().toJson());
                Navigator.of(context).pop(deltaToMarkdown(json));
              },
            ),
          ],
        ),
        body: quill.QuillEditor(
          controller: controller,
          focusNode: focusNode,
          scrollController: scrollController,
          scrollable: true,
          padding: const EdgeInsets.all(ConfigConstant.margin2),
          autoFocus: true,
          readOnly: false,
          expands: true,
        ),
        bottomNavigationBar: Container(
          height: kToolbarHeight + mediaQueryData.viewInsets.bottom + 8 + mediaQueryData.padding.bottom,
          padding: EdgeInsets.only(bottom: mediaQueryData.viewInsets.bottom),
          color: colorScheme.background,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: ConfigConstant.margin2).copyWith(top: 8),
            scrollDirection: Axis.horizontal,
            child: quill.QuillToolbar.basic(
              controller: controller,
              toolbarIconSize: ConfigConstant.iconSize2,
              showBackgroundColorButton: false,
              showColorButton: false,
              showCodeBlock: false,
              showIndent: false,
              showUnderLineButton: false,
              showHorizontalRule: false,
              showStrikeThrough: false,
            ),
          ),
        ),
      ),
    );
  }
}
