import 'package:angkot/maps.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class NeedLocationWidget extends StatefulWidget {
  const NeedLocationWidget({super.key, required this.builder});

  final Widget Function(BuildContext, LatLng) builder;

  @override
  State<NeedLocationWidget> createState() => _NeedLocationWidgetState();
}

class _NeedLocationWidgetState extends State<NeedLocationWidget> {
  Future<LatLng>? getLocation;

  @override
  void initState() {
    super.initState();

    getLocation = getUserLocation();
  }

  Future<LatLng> getUserLocation() async {
    return await getCurrentLatLng();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getLocation,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Builder(builder: (context) {
            return widget.builder(context, snapshot.data!);
          });
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
