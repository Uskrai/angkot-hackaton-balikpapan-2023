import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
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

class HomeUserLayout extends StatelessWidget{
  const HomeUserLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }

}