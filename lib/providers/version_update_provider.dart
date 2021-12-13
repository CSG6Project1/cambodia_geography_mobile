import 'dart:io';

import 'package:cambodia_geography/exports/exports.dart';
import 'package:in_app_update/in_app_update.dart';

class VersionUpdateProvider extends ChangeNotifier {
  bool get isUpdateAvailable => this.immediateUpdateAllowed || this.flexibleUpdateAllowed;

  bool immediateUpdateAllowed = false;
  bool flexibleUpdateAllowed = false;

  Future<void> load() async {
    if (Platform.isAndroid) {
      try {
        AppUpdateInfo? update = await InAppUpdate.checkForUpdate();
        immediateUpdateAllowed = update.immediateUpdateAllowed;
        flexibleUpdateAllowed = update.flexibleUpdateAllowed;
      } catch (e) {
        immediateUpdateAllowed = false;
        flexibleUpdateAllowed = false;
      }
      notifyListeners();
    }
  }

  Future<void> update() async {
    if (isUpdateAvailable) {
      try {
        await InAppUpdate.startFlexibleUpdate();
        await InAppUpdate.completeFlexibleUpdate();
        load();
      } catch (e) {}
    }
  }
}
