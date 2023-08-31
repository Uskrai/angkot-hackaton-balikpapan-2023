import 'dart:async';

import 'package:angkot/client/User.dart';
import 'package:angkot/client/websocket/ApiWebsocket.dart';
import 'package:angkot/maps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../client/ApiClient.dart';
import '../routes/route_layout.dart';
import '../temp/route.dart';

class DriverMapLayout extends StatefulWidget {
  const DriverMapLayout({
    super.key,
    required this.routes,
    required this.currentRoute,
    required this.apiClient,
    required this.center,
    required this.onPressRoute,
    required this.websocket,
  });

  final List<LineRoute> routes;
  final ApiClient apiClient;
  final LatLng center;
  final Function(LineRoute) onPressRoute;
  final DriverWebsocketClient? websocket;
  final LineRoute? currentRoute;

  @override
  State<StatefulWidget> createState() => _DriverMapLayoutState();
}

class _DriverMapLayoutState extends State<DriverMapLayout> {
  final String _route = "Pilih Jalan..";

  LatLng? currentLocation;

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

    websocket.notify.listen((user) {
      notifyDriver(user);
    });

    (() async {
      try {
        var _ = await checkPermission();
        var it = Geolocator.getPositionStream();

        StreamSubscription<Position>? listen;
        listen = it.listen((event) {
          var latlng = LatLng(event.latitude, event.longitude);

          if (mounted && !websocket.isClosed()) {
            websocket.changeLocation(latlng);
          }

          if (mounted) {
            setState(() {
              currentLocation = latlng;
            });
          }

          if (!mounted) {
            listen?.cancel();
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
    var currentRoute = widget.currentRoute;
    var websocket = widget.websocket;
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              center: widget.center,
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
                  if (currentRoute != null)
                    for (var line in currentRoute.lines)
                      Polyline(
                        points: line.points,
                        color: Colors.blue,
                        strokeWidth: 3,
                      ),
                  // Polyline(points: points, color: Colors.red)
                ],
              ),
              MarkerLayer(
                markers: [
                  if (websocket != null)
                    for (var user in websocket.users.map(
                      (it) => markerFromUser(
                        user: it,
                        onTap: () {
                          //
                        },
                      ),
                    ))
                      if (user != null) user,
                  Marker(
                    point: websocket != null
                        ? websocket.currentUser.location
                        : (currentLocation ?? widget.center),
                    builder: (context) {
                      return Image.asset("assets/icon/user.png");
                    },
                    width: 20,
                    height: 20,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(-1.278407, 116.822300),
                    builder: (context) => GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(
                                    Icons.directions_bus,
                                    size: 80,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'Ahmad Submul',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'ID: ANGKOT215',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 40),
                                  FloatingActionButton(
                                    onPressed: () {},
                                    child: const Icon(
                                      Icons.waving_hand,
                                      size: 30,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Image.asset("assets/icon/shared-taxi.png"),
                    ),
                  ),
                ],
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
                      widget.currentRoute?.name ?? _route,
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

  Future lihatPenumpang() {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                'Kursi Angkot',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Icon(Icons.check_circle, color: Colors.green),
                  Icon(Icons.check_circle, color: Colors.green),
                  Icon(Icons.check_circle, color: Colors.green),
                  Icon(Icons.check_circle, color: Colors.green),
                  Icon(Icons.check_circle, color: Colors.green),
                  Icon(Icons.cancel, color: Colors.red),
                  Icon(Icons.cancel, color: Colors.red),
                ],
              ),
              const Text(
                '5 dari 7 kursi telah diduduki',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future notifyDriver(UserWithId user) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('Orderan Masuk dari ${user.user.email}'),
                subtitle: const Text(
                  'Apakah Anda ingin menerima atau menolak orderan ini?',
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  OutlinedButton(
                    onPressed: () {
                      widget.websocket?.responsePickup(user.id, false);
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                    child: const Text('Tolak'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      widget.websocket?.responsePickup(user.id, true);
                      Navigator.pop(context);
                    },
                    child: const Text('Terima'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
