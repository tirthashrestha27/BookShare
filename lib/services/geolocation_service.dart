import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class GeoLocationService {
  Future<bool> checkLocationService() async {
    bool status = await Geolocator().isLocationServiceEnabled();
    return status;
  }

  Future<Position> getLocation() async {
    // Geolocator().forceAndroidLocationManager = true;

    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    return position;
  }

  Future<String> getAddress(Position position) async {
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    print(position);

    Placemark placeMark = placemarks[0];
    String name = placeMark.name;
    String subLocality = placeMark.subLocality;

    String locality = placeMark.locality;
    String administrativeArea = placeMark.administrativeArea;
    String postalCode = placeMark.postalCode;
    String country = placeMark.country;
    String address =
        "$name, $subLocality, $locality, $administrativeArea $postalCode, $country";
    return address;
  }

  Future<double> distanceBetweenCoordintaes(GeoPoint A, GeoPoint B) async {
    double distanceInMeters = await Geolocator()
        .distanceBetween(A.latitude, A.longitude, B.latitude, B.longitude);
    return distanceInMeters / 1000;
  }
}
