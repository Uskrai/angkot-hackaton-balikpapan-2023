import 'dart:async';

import 'package:angkot_ku/client/websocket/ApiWebsocket.dart';
import 'package:angkot_ku/maps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../client/ApiClient.dart';
import '../routes/route_layout.dart';
import '../temp/route.dart';

class UserMapLayout extends StatefulWidget {
  const UserMapLayout({
    super.key,
    required this.routes,
    required this.apiClient,
    required this.center,
    required this.onPressRoute,
    required this.websocket,
  });

  final List<LineRoute> routes;
  final ApiClient apiClient;
  final LatLng center;
  final Function(LineRoute) onPressRoute;
  final ApiWebsocketClient? websocket;

  @override
  State<StatefulWidget> createState() => _UserMapLayoutState();
}

class _UserMapLayoutState extends State<UserMapLayout> {
  final String _route = "Pilih Jalan..";

  @override
  void initState() {
    super.initState();

    initWebsocket();
  }

  @override
  void dispose() {
    super.dispose();

    if (widget.websocket != null) {
      widget.websocket!.close();
    }
  }

  void initWebsocket() {
    var websocket = widget.websocket;
    if (websocket == null) {
      return;
    }

    try {
      websocket.connect();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
    websocket.changed.listen((_) {
      setState(() {});
    });

    (() async {
      try {
        var _ = await checkPermission();
        var it = Geolocator.getPositionStream();

        StreamSubscription<Position>? listener;
        listener = it.listen((event) {
          var latlng = LatLng(event.latitude, event.longitude);

          if (mounted && !websocket.isClosed()) {
            websocket.changeLocation(latlng);
          } else {
            listener?.cancel();
          }
        });

        await Future.delayed(const Duration(seconds: 1));
      } catch (e) {
        //
      }
    })();
  }

  // get String _route => widget.routes[0].name;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              center: widget.center,
              // center: widget.client.currentUser.location,
              zoom: 16,
            ),
            children: [
              TileLayer(
                maxZoom: 19,
                minZoom: 0,
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: "org.github.uskrai.angkot",
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RouteLayout(
                    route: _route,
                    apiClient: widget.apiClient,
                    onPressRoute: (route) {
                      widget.onPressRoute(route);
                    },
                    routes: widget.routes,
                  ),
                ),
              );
            },
            child: Container(
              height: size.height * 0.07,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.25),
                    offset: Offset(0, 4),
                    blurRadius: 4,
                  )
                ],
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    IconButton(onPressed: () {}, icon: const Icon(Icons.route)),
                    Text(
                      _route,
                      style: const TextStyle(
                        color: CupertinoColors.systemGrey2,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.change_circle),
                    ),
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
