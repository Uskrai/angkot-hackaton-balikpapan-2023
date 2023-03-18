import 'package:angkot_ku/routes/route_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../client/ApiClient.dart';
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
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
            ],
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  RouteLayout(
                    route: _route,
                    apiClient: widget.apiClient,
                    onPressRoute: (route) {
                      // return (context, route) async
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