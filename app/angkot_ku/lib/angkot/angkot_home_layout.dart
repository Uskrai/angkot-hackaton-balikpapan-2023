import 'package:angkot_ku/client/websocket/ApiWebsocket.dart';
import 'package:angkot_ku/driver/driver_map_layout.dart';
import 'package:angkot_ku/location_widget.dart';
import 'package:angkot_ku/routes/route_layout.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../client/ApiClient.dart';
import '../driver/driver_review_layout.dart';
import '../temp/route.dart';
import '../driver/driver_log_layout.dart';

class AngkotHomeLayout extends StatefulWidget {
  const AngkotHomeLayout({
    super.key,
    required this.routes,
    required this.apiClient,
    required this.createWebsocketClient,
  });

  final List<LineRoute> routes;
  final ApiClient apiClient;
  final DriverWebsocketClient Function(LineRoute, LatLng) createWebsocketClient;

  @override
  State<StatefulWidget> createState() => _AngkotHomeLayoutState();
}

class _AngkotHomeLayoutState extends State<AngkotHomeLayout> {
  int _selectedIndex = 0;
  final _route = "Pilih Jalan...";

  LineRoute? currentRoute;
  DriverWebsocketClient? _api;
  int _count = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _reset() {
    _count++;
  }

  void _onPressRoute(LineRoute route, LatLng location) {
    final api = widget.createWebsocketClient(
      route,
      location,
    );

    setState(() {
      _api = api;
      currentRoute = route;
      _reset();
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return NeedLocationWidget(
      builder: (context, location) {
        final List<Widget> widgetOptions = <Widget>[
          Scaffold(
            body: AngkotReviewLayout(),
          ),
          Scaffold(
            body: DriverMapLayout(
              routes: widget.routes,
              apiClient: widget.apiClient,
              center: location,
              currentRoute: currentRoute,
              websocket: _api,
              onPressRoute: (route) {
                _onPressRoute(route, location);
              },
            ),
          )
        ];

        return Scaffold(
          key: ValueKey(_count),
          body: Center(
            child: Stack(
              children: [
                widgetOptions.elementAt(_selectedIndex),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RouteLayout(
                    route: _route,
                    apiClient: widget.apiClient,
                    onPressRoute: (route) {
                      _onPressRoute(route, location);
                    },
                    routes: widget.routes,
                  ),
                ),
              );
            },
            backgroundColor: Colors.blue,
            child: const Icon(Icons.directions_car),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 8.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: IconButton(
                    icon: Icon(Icons.home),
                    onPressed: () {
                      _onItemTapped(0);
                    },
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: Icon(Icons.access_time),
                    onPressed: () {
                      _onItemTapped(1);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class DriverInnerLayout extends StatefulWidget {
  const DriverInnerLayout({
    super.key,
    required this.routes,
    required this.center,
    required this.apiClient,
    required this.websocket,
    required this.currentRoute,
    required this.createWebsocketClient,
  });

  final List<LineRoute> routes;
  final LatLng center;
  final ApiClient apiClient;
  final ApiWebsocketClient? websocket;
  final LineRoute? currentRoute;
  final Function(LineRoute, LatLng) createWebsocketClient;

  @override
  State<DriverInnerLayout> createState() => _DriverInnerLayoutState();
}

class _DriverInnerLayoutState extends State<DriverInnerLayout> {
  int _count = 0;
  LineRoute? currentRoute;
  ApiWebsocketClient? websocket;

  @override
  void initState() {
    super.initState();
    currentRoute = widget.currentRoute;
    websocket = widget.websocket;
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
