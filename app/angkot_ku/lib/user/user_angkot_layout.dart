import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class UserAngkotLayout extends StatefulWidget {
  const UserAngkotLayout({super.key});

  @override
  State<StatefulWidget> createState() => _UserAngkotLayoutState();
}

class _UserAngkotLayoutState extends State<UserAngkotLayout> {
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
                    const Text(
                      "Pilih Rute..",
                      style: TextStyle(
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