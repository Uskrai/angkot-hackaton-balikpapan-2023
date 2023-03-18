import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../client/ApiClient.dart';
import '../temp/route.dart';
import 'angkot_log_layout.dart';
import 'angkot_review_layout.dart';

class AngkotHomeLayout extends StatefulWidget {
  const AngkotHomeLayout({super.key, required this.routes, required this.apiClient});

  final RoleRoute routes;
  final ApiClient apiClient;

  @override
  State<StatefulWidget> createState() => _AngkotHomeLayoutState();

}

class _AngkotHomeLayoutState extends State<AngkotHomeLayout> {
  int _selectedIndex = 0;

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