import 'package:angkot_ku/routes/angkot_routes_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../client/ApiClient.dart';
import '../temp/route.dart';
import 'angkot_log_layout.dart';
import 'angkot_review_layout.dart';

class AngkotHomeLayout extends StatefulWidget {
  const AngkotHomeLayout({super.key, required this.roleRoutes, required this.apiClient});

  final RoleRoute roleRoutes;
  final ApiClient apiClient;

  @override
  State<StatefulWidget> createState() => _AngkotHomeLayoutState();

}

class _AngkotHomeLayoutState extends State<AngkotHomeLayout> {
  int _selectedIndex = 0;
  String _route = "Pilih Jalan..";

  final List<Widget> widgetOptions = <Widget>[
    Scaffold(
      body: AngkotReviewLayout(),
    ),
    Scaffold(
      body: AngkotLogLayout(),
    )
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            widgetOptions.elementAt(_selectedIndex),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              AngkotRoutesLayout(
                route: _route,
                apiClient: widget.apiClient,
                onPressRoute: (route) {
                  // return onPressRoute(context, route)
                },
                routes: widget.roleRoutes.sharedTaxi,
              )
          ));
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.directions_car),
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
  }

}