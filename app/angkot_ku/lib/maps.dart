import 'package:angkot_ku/user/user_layout.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

LatLng decodeLatLng(dynamic loc) {
  var latitude = loc["latitude"];
  var longitude = loc["longitude"];

  return LatLng(latitude, longitude);
}

Future<LatLng> getCurrentLatLng() async {
  await checkPermission();
  var position = await Geolocator.getCurrentPosition();

  return LatLng(position.latitude, position.longitude);
}
