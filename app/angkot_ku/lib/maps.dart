import 'package:angkot_ku/temp/route.dart';
import 'package:angkot_ku/user/user_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import 'client/User.dart';
import 'client/websocket/ApiWebsocket.dart';

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

Marker? markerFromUser(User user) {
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
      builder: (context) {
        return Image.asset("assets/icon/shared-taxi.png");
      },
    );
  } else if (user is Bus) {
    return Marker(
      point: user.location,
      width: 20,
      height: 20,
      builder: (context) {
        return Image.asset("assets/icon/bus.png");
      },
    );
  }

  return null;
}



