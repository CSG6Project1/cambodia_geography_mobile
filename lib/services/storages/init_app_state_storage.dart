import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/services/base_storages/share_preference_storage.dart';
import 'package:cambodia_geography/types/app_state_type.dart';

class InitAppStateStorage extends SharePreferenceStorage {
  @override
  String get key => "InitAppStateStorage";

  Future<void> setCurrentState(AppStateType state) async {
    await super.write("$state".replaceAll("AppStateType.", ""));
  }

  Future<String> getInitialRouteName() async {
    AppStateType? type = await _getCurrentAppStateType();
    String route;
    switch (type) {
      case AppStateType.setLangauge:
        route = RouteConfig.INIT_LANG;
        break;
      case AppStateType.skippedAuth:
        route = RouteConfig.HOME;
        break;
      case AppStateType.signedOut:
        route = RouteConfig.HOME;
        break;
      default:
        route = RouteConfig.INIT_LANG;
        break;
    }
    return route;
  }

  Future<AppStateType?> _getCurrentAppStateType() async {
    String? currentState = await super.read();
    AppStateType? type;
    switch (currentState) {
      case "setLangauge":
        type = AppStateType.setLangauge;
        break;
      case "skippedAuth":
        type = AppStateType.skippedAuth;
        break;
      case "signedOut":
        type = AppStateType.signedOut;
        break;
      default:
        type = null;
        break;
    }
    return type;
  }
}
