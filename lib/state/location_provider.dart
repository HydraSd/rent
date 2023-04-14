import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectedLocationModel extends ChangeNotifier {
  LatLng? location;
  double? distance;

  void setLocationAndDistance(LatLng newLocation, double newDistance) {
    location = newLocation;
    distance = newDistance;
    notifyListeners();
  }
}

// class LocationProvider extends ChangeNotifier {
//   LatLng? _selectedLocation;

//   void setSelectedLocation(LatLng location) {
//     _selectedLocation = location;
//     notifyListeners();
//   }

//   LatLng? get selectedLocation => _selectedLocation;
// }
