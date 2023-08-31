import 'package:angkot/client/Role.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import 'client/User.dart';

LatLng decodeLatLng(dynamic loc) {
  var latitude = loc["latitude"];
  var longitude = loc["longitude"];

  return LatLng(latitude, longitude);
}

Future<void> checkPermission() async {
  var locationService = await Geolocator.isLocationServiceEnabled();
  if (!locationService) {
    throw "Location service is required";
  }

  var permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw "Location permissions are denied";
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw "Location permissions are permanently denied, we cannot request permissions.";
  }
}

Future<LatLng> getCurrentLatLng() async {
  await checkPermission();

  var position = await Geolocator.getCurrentPosition();

  return LatLng(position.latitude, position.longitude);
}

// Future<void> showMap(
//     BuildContext context,
//     LineRoute route,
//     ApiWebsocketClient Function(LatLng) createClient, [
//       mounted = true,
//     ]) async {
//   if (!mounted) return;
//   LatLng latlng;
//
//   try {
//     latlng = await getCurrentLatLng();
//   } catch (e) {
//     if (!mounted) return;
//     if (e is String) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e)));
//     }
//     return;
//   }
//
//   var client = createClient(latlng);
//   if (!mounted) return;
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) {
//         return WebsocketMapWidget(
//           client: client,
//           route: route,
//         );
//       },
//     ),
//   );
// }

Marker? markerFromUser({required User user, Function? onTap}) {
  if (user is Customer) {
    return Marker(
      point: user.location,
      width: 20,
      height: 20,
      builder: (context) {
        return Image.asset("assets/icon/customer.png");
      },
    );
  } else if (user is SharedTaxi) {
    return Marker(
      point: user.location,
      width: 20,
      height: 20,
      builder: (context) => GestureDetector(
        onTap: () {
          onTap?.call();
        },
        child: Image.asset("assets/icon/shared-taxi.png"),
      ),
    );
  } else if (user is Bus) {
    return Marker(
      point: user.location,
      width: 20,
      height: 20,
      builder: (context) => GestureDetector(
        onTap: () {
          onTap?.call();
        },
        child: Image.asset("assets/icon/bus.png"),
      ),
    );
  }

  return null;
}
