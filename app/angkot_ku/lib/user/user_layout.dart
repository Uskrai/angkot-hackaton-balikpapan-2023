import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Menu Angkot',
    ),
    Text(
      'Menu Bis',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  PersistentBottomSheetController? _bottomSheetController;

  void _showBottomSheet() {
    _bottomSheetController = Scaffold.of(context).showBottomSheet(
          (context) => Container(
            height: 200,
            color: Colors.red,
            child: const Center(
              child: Text('Ini adalah BottomSheet'),
            ),
          ),
      elevation: 8.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
            _showBottomSheet();
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