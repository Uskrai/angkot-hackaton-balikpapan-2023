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
          // Navigator.push(context, MaterialPageRoute(builder: (context) =>
          //     AngkotRoutesLayout(
          //       route: _route,
          //       apiClient: widget.apiClient,
          //       onPressRoute: (route) {
          //         // return onPressRoute(context, route)
          //       },
          //       routes: widget.roleRoutes.sharedTaxi,
          //     )
          // ));

          // showModalBottomSheet(
          //   context: context,
          //   builder: (BuildContext context) {
          //     return Container(
          //       height: 200,
          //       child: Column(
          //         children: [
          //           Container(
          //             width: double.infinity,
          //             height: 150,
          //             decoration: BoxDecoration(
          //               boxShadow: [
          //                 BoxShadow(
          //                   color: Color.fromRGBO(0, 0, 0, 0.25),
          //                   offset: Offset(0, 0),
          //                   blurRadius: 4,
          //                 ),
          //               ],
          //               color: Colors.white,
          //             ),
          //             child: Column(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               children: [
          //                 Text(
          //                   'MENUNGGU PERMINTAAN',
          //                   textAlign: TextAlign.center,
          //                   style: TextStyle(
          //                     fontSize: 22,
          //                     fontWeight: FontWeight.bold,
          //                   ),
          //                 ),
          //                 SizedBox(height: 10),
          //                 Text(
          //                   'Sedang mencari supir...',
          //                   textAlign: TextAlign.center,
          //                   style: TextStyle(
          //                     fontSize: 18,
          //                     color: Colors.grey[600],
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ],
          //       ),
          //     );
          //   },
          // );

          // showModalBottomSheet(
          //   context: context,
          //   builder: (BuildContext context) {
          //     return Container(
          //       padding: EdgeInsets.all(20),
          //       child: Column(
          //         mainAxisSize: MainAxisSize.min,
          //         children: <Widget>[
          //           Icon(
          //             Icons.directions_bus,
          //             size: 80,
          //             color: Colors.grey[400],
          //           ),
          //           SizedBox(height: 20),
          //           Text(
          //             'Ahmad Submul',
          //             style: TextStyle(
          //               fontSize: 22,
          //               fontWeight: FontWeight.bold,
          //             ),
          //           ),
          //           SizedBox(height: 10),
          //           Text(
          //             'ID: ANGKOT215',
          //             style: TextStyle(
          //               fontSize: 14,
          //               color: Colors.grey,
          //             ),
          //           ),
          //           SizedBox(height: 40),
          //           FloatingActionButton(
          //             onPressed: () {},
          //             child: Icon(
          //               Icons.waving_hand,
          //               size: 30,
          //             ),
          //           ),
          //         ],
          //       ),
          //     );
          //   },
          // );

          // showDialog(
          //   context: context,
          //   builder: (BuildContext context) {
          //     return AlertDialog(
          //       title: Text('Orderan Masuk'),
          //       content: Text('Apakah Anda ingin menerima atau menolak orderan ini?'),
          //       actions: <Widget>[
          //         TextButton(
          //           onPressed: () {
          //             // Kode yang akan dijalankan saat tombol "Terima" diklik
          //             Navigator.pop(context);
          //           },
          //           child: Text('Terima'),
          //         ),
          //         TextButton(
          //           onPressed: () {
          //             // Kode yang akan dijalankan saat tombol "Tolak" diklik
          //             Navigator.pop(context);
          //           },
          //           child: Text('Tolak'),
          //         ),
          //       ],
          //     );
          //   },
          // );

          // showDialog(
          //   context: context,
          //   builder: (BuildContext context) {
          //     return Dialog(
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(12),
          //       ),
          //       child: Container(
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(12),
          //           boxShadow: const [
          //             BoxShadow(
          //               color: Color.fromRGBO(0, 0, 0, 0.25),
          //               offset: Offset(0, 4),
          //               blurRadius: 4,
          //             ),
          //           ],
          //           color: const Color.fromRGBO(255, 255, 255, 1),
          //         ),
          //         padding: const EdgeInsets.symmetric(horizontal: 29, vertical: 12),
          //         child: Column(
          //           mainAxisSize: MainAxisSize.min,
          //           children: <Widget>[
          //             SizedBox(
          //               width: 271,
          //               height: 69,
          //               child: Stack(
          //                 children: <Widget>[
          //                   const Positioned(
          //                     top: 36,
          //                     left: 0,
          //                     child: Text(
          //                       'Pesanan Telah Diterima',
          //                       textAlign: TextAlign.left,
          //                       style: TextStyle(
          //                         color: Color.fromRGBO(0, 0, 0, 1),
          //                         fontFamily: 'Poppins',
          //                         fontSize: 22,
          //                         letterSpacing:
          //                         0 /*percentages not used in flutter. defaulting to zero*/,
          //                         fontWeight: FontWeight.normal,
          //                         height: 1,
          //                       ),
          //                     ),
          //                   ),
          //                   Positioned(
          //                     top: 0,
          //                     left: 119,
          //                     child: GestureDetector(
          //                       onTap: () {
          //                         Navigator.of(context).pop();
          //                       },
          //                       child: const Icon(
          //                         Icons.close,
          //                         color: Colors.grey,
          //                         size: 24,
          //                       ),
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     );
          //   },
          // );
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