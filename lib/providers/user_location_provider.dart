import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/screens/map/map_screen.dart';
import 'package:cambodia_geography/services/geography/user_location_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class UserLocationProvider extends ChangeNotifier {
  late UserLocationService service;
  Position? currentPosition;
  List<Placemark>? placemarks;

  UserLocationProvider() {
    service = UserLocationService();
  }

  Future<void> determinePosition() async {
    var result = await service.determinePosition();
    if (result != currentPosition && result != null) {
      currentPosition = result;
      placemarks = await service.getPlaceMarks(LatLng(
        currentPosition!.latitude,
        currentPosition!.longitude,
      ));
      notifyListeners();
    }
  }

  String? get errorMessage => service.errorMessage;
}
