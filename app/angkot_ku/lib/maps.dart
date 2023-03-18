import 'package:latlong2/latlong.dart';

LatLng decodeLatLng(dynamic loc) {
  var latitude = loc["latitude"];
  var longitude = loc["longitude"];

  return LatLng(latitude, longitude);
}