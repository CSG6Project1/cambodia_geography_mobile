import 'dart:math' show cos, sqrt, asin;

import 'package:cambodia_geography/screens/map/map_screen.dart';

// https://stackoverflow.com/questions/54138750/total-distance-calculation-from-latlng-list/54138876
class DistanceCaculatorService {
  DistanceCaculatorService._internal();

  static double _calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  static double calculateDistance(LatLng from, LatLng to) {
    List<LatLng> data = [from, to];
    double totalDistance = 0;
    for (var i = 0; i < data.length - 1; i++) {
      totalDistance += _calculateDistance(
        data[i].latitude,
        data[i].longitude,
        data[i + 1].latitude,
        data[i + 1].longitude,
      );
    }
    return totalDistance;
  }
}
