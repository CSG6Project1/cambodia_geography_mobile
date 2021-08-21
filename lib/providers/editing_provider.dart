import 'package:cambodia_geography/exports/exports.dart';

class EditingProvider extends ChangeNotifier {
  late bool _editing;

  EditingProvider() {
    _editing = false;
  }

  bool get editing => this._editing;
  set editing(bool value) {
    if (this._editing == value) return;
    this._editing = value;
    notifyListeners();
  }
}
