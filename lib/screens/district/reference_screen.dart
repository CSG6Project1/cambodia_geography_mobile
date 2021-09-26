import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/mixins/cg_media_query_mixin.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';

class ReferenceScreen extends StatefulWidget {
  const ReferenceScreen({Key? key}) : super(key: key);

  @override
  _ReferenceScreenState createState() => _ReferenceScreenState();
}

class _ReferenceScreenState extends State<ReferenceScreen> with CgThemeMixin, CgMediaQueryMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(tr('title.reference')),
      ),
      body: ListView(
        children: [
          MaterialBanner(
            forceActionsBelow: true,
            backgroundColor: colorScheme.surface,
            leading: CircleAvatar(
              backgroundColor: colorScheme.secondary,
              foregroundColor: colorScheme.onSecondary,
              child: Icon(Icons.info),
            ),
            content: Text(tr('msg.data_collection_reference')),
            actions: [
              CgButton(
                labelText: tr('button.visit_their_reference'),
                foregroundColor: colorScheme.primary,
                backgroundColor: colorScheme.surface,
                onPressed: () {
                  launch('https://geo.nestcode.co/references');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
