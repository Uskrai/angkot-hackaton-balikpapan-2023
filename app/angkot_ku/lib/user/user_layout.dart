import 'package:angkot_ku/client/User.dart';
import 'package:angkot_ku/client/websocket/ApiWebsocket.dart';
import 'package:angkot_ku/maps.dart';
import 'package:angkot_ku/user/user_map_layout.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../client/ApiClient.dart';
import '../temp/route.dart';

class HomeUserLayout extends StatefulWidget {
  const HomeUserLayout({
    super.key,
    required this.routes,
    required this.apiClient,
  });

  final RoleRoute routes;
  final ApiClient apiClient;

  @override
  State<StatefulWidget> createState() => _HomeUserLayoutState();
}

class _HomeUserLayoutState extends State<HomeUserLayout> {
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
          return HomeUserInnerWidget(
            routes: widget.routes,
            apiClient: widget.apiClient,
            center: snapshot.data!,
          );
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

class HomeUserInnerWidget extends StatefulWidget {
  const HomeUserInnerWidget({
    super.key,
    required this.routes,
    required this.apiClient,
    required this.center,
  });

  final RoleRoute routes;
  final ApiClient apiClient;
  final LatLng center;

  @override
  State<HomeUserInnerWidget> createState() => _HomeUserInnerWidgetState();
}

class _HomeUserInnerWidgetState extends State<HomeUserInnerWidget> {
  int _selectedIndex = 0;
  int _count = 0;
  ApiWebsocketClient? _api;

  final driverType = {
    0: DriverType.bus,
    1: DriverType.sharedTaxi,
  };

  void _reset() {
    _count++;
  }

  void _onItemTapped(int index) {
    setState(() {
      if (index != _selectedIndex) {
        _selectedIndex = index;
        _api = null;
        _reset();
      }
    });
  }

  void _onPressRoute(
    BuildContext context,
    LineRoute route,
    DriverType driverType,
  ) {
    final api = widget.apiClient.createCustomer(
      route,
      Customer(location: widget.center),
      driverType,
    );

    setState(() {
      _api = api;
      _reset();
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      Scaffold(
        body: UserMapLayout(
          key: const Key("bus"),
          routes: widget.routes.bus,
          apiClient: widget.apiClient,
          center: widget.center,
          onPressRoute: (route) {
            _onPressRoute(context, route, DriverType.bus);
          },
          websocket: _api,
        ),
      ),
      Scaffold(
        // angkot
        body: UserMapLayout(
          routes: widget.routes.sharedTaxi,
          apiClient: widget.apiClient,
          center: widget.center,
          onPressRoute: (route) {
            _onPressRoute(context, route, DriverType.sharedTaxi);
          },
          websocket: _api,
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
        onPressed: () {},
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: IconButton(
                icon: const Icon(Icons.directions_bus),
                onPressed: () {
                  _onItemTapped(0);
                },
              ),
            ),
            Expanded(
              child: IconButton(
                icon: const Icon(Icons.directions_car),
                onPressed: () {
                  _onItemTapped(1);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
