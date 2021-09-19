import 'package:cambodia_geography/exports/exports.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class CgMarkdownBody extends StatelessWidget {
  const CgMarkdownBody(
    this.body, {
    Key? key,
  }) : super(key: key);

  final String body;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return MarkdownBody(
      data: body,
      selectable: true,
      styleSheet: MarkdownStyleSheet.fromTheme(
        themeData.copyWith(
          textTheme: themeData.textTheme.apply(
            bodyColor: themeData.textTheme.caption?.color,
          ),
        ),
      ),
      onTapLink: (String text, String? href, String title) {
        // TODO: handle on tap on link
        print(href);
      },
    );
  }
}
