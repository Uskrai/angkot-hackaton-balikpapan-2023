import 'package:angkot_ku/routes/route_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../client/ApiClient.dart';
import '../maps.dart';
import '../temp/route.dart';

class UserAngkotLayout extends StatefulWidget {
  const UserAngkotLayout({super.key,
    required this.roleRoutes,
    required this.apiClient});

  final RoleRoute roleRoutes;
  final ApiClient apiClient;

  @override
  State<StatefulWidget> createState() => _UserAngkotLayoutState();
}

class _UserAngkotLayoutState extends State<UserAngkotLayout> {

  String _route = "Pilih Jalan..";
  late void Function(BuildContext context, LineRoute route) onPressRoute;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              center: LatLng(-0.42317170805325727, 116.98292392032356),
              zoom: 16,
            ),
            children: [
              TileLayer(
                maxZoom: 19,
                minZoom: 0,
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: "org.github.uskrai.angkot",
              ),
              PolylineLayer(
                polylineCulling: true,
                polylines: [
                    Polyline(
                      points: [LatLng(-0.42317170805325727, 116.98292392032356)],
                      color: Colors.blue,
                      strokeWidth: 3,
                    ),
                  // Polyline(points: points, color: Colors.red)
                ],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(-0.42317170805325727, 116.98292392032356),
                    builder: (context) {
                      return Image.asset('assets/images/icon.png');
                    },
                    width: 100,
                    height: 100,
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  RouteLayout(
                    route: _route,
                    apiClient: widget.apiClient,
                    onPressRoute: (route) {
                      // return onPressRoute(context, route)
                    },
                    routes: widget.roleRoutes.sharedTaxi,
                  )
              ));
            },
            child: Container(
              height: size.height * 0.07,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                  borderRadius : BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  boxShadow : [BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.25),
                      offset: Offset(0,4),
                      blurRadius: 4
                  )],
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {

                        },
                        icon: const Icon(Icons.route)
                    ),
                    Text(
                      _route,
                      style: const TextStyle(
                        color: CupertinoColors.systemGrey2
                      ),
                    ),
                    IconButton(
                        onPressed: () {

                        },
                        icon: const Icon(Icons.change_circle)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}