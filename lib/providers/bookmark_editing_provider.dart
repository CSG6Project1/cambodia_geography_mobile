import 'package:cambodia_geography/exports/exports.dart';

class BookmarkEditingProvider extends ChangeNotifier {
  late bool _editing;
  List<String> _checkPlaceIds = [];
  List<String> get checkPlaceIds => this._checkPlaceIds;

  bool isChecked(String placeId) {
    return this.checkPlaceIds.contains(placeId);
  }

  void toggleCheckBox(String placeId) {
    if (checkPlaceIds.contains(placeId)) {
      checkPlaceIds.removeWhere((e) => e == placeId);
    } else {
      checkPlaceIds.add(placeId);
    }
    notifyListeners();
  }

  BookmarkEditingProvider() {
    _editing = false;
  }

  bool get editing => this._editing;
  set editing(bool value) {
    if (this._editing == value) return;
    this._editing = value;
    if (!this._editing) this._checkPlaceIds.clear();
    notifyListeners();
  }
}
