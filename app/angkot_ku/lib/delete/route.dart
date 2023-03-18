import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../client/ApiClient.dart';

class LineRoute {
  const LineRoute({
    required this.name,
    required this.center,
    required this.lines,
  });

  final String name;
  final LatLng center;
  final List<Lines> lines;
}

class Lines {
  const Lines({
    required this.name,
    required this.points,
  });

  final String name;
  final List<LatLng> points;

  @override
  String toString() {
    return "Lines(name: $name, points: $points)";
  }
}

class RoleRoute {
  const RoleRoute({
    required this.bus,
    required this.sharedTaxi,
  });

  final List<LineRoute> bus;
  final List<LineRoute> sharedTaxi;
}

class SelectRouteWidget extends StatelessWidget {
  const SelectRouteWidget({
    super.key,
    required this.routes,
    required this.onPressRoute,
    required this.apiClient,
  });

  final List<LineRoute> routes;
  final void Function(LineRoute) onPressRoute;
  final ApiClient apiClient;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 26, 156, 30),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout_rounded),
            iconSize: 30,
            color: Colors.white,
            onPressed: () async { await apiClient.logOut(); },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (var it in routes)
              Padding(
                padding: EdgeInsets.all(10.0),
                child: SizedBox(
                  width: 300,
                  height: 80,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 26, 156, 30),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    onPressed: () {
                      onPressRoute(it);
                    },
                    child: Text(it.name, style: TextStyle(fontSize: 20)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
