import 'package:cambodia_geography/app.dart';
import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/widgets/cg_app_bar_title.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        title: CGAppBarTitle(title: AppLocalizations.of(context)!.helloWorld),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("Language"),
            subtitle: Text(AppLocalizations.of(context)?.localeName ?? ""),
            onTap: () {
              final supportedLocales = AppLocalizations.supportedLocales;
              if (supportedLocales.first.languageCode == AppLocalizations.of(context)?.localeName) {
                App.of(context)?.updateLocale(supportedLocales.last);
              } else {
                App.of(context)?.updateLocale(supportedLocales.first);
              }
            },
          )
        ],
      ),
    );
  }
}
