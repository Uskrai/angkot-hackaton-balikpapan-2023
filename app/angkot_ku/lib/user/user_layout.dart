import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
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

class HomeUserLayout extends StatefulWidget {
  const HomeUserLayout({super.key});

  @override
  State<StatefulWidget> createState() => _HomeUserLayoutState();

}

class _HomeUserLayoutState extends State<HomeUserLayout>{
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    Text(
      'Menu Angkot',
    ),
    FlutterMap(
      options: MapOptions(
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
        PolylineLayer(
          polylineCulling: true,
          polylines: [
            // for (var line in widget.route.lines)
            //   Polyline(
            //     points: line.points,
            //     color: Colors.blue,
            //     strokeWidth: 3,
            //   ),
            // Polyline(points: points, color: Colors.red)
          ],
        ),
        // MarkerLayer(
        //   markers: [
        //     for (var user in widget.client.users.map(
        //           (it) => markerFromUser(it),
        //     ))
        //       if (user != null) user,
        //     Marker(
        //       point: widget.client.currentUser.location,
        //       builder: (context) {
        //         return Image.asset("assets/icon/user.png");
        //       },
        //       width: 20,
        //       height: 20,
        //     ),
        //   ],
        // ),
      ],
    )
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  PersistentBottomSheetController? _bottomSheetController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            _widgetOptions.elementAt(_selectedIndex),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
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
                icon: Icon(Icons.directions_bus),
                onPressed: () {
                  _onItemTapped(0);
                },
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.directions_car),
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