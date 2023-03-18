import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../client/ApiClient.dart';
import '../temp/route.dart';

class AngkotRoutesLayout extends StatefulWidget {
  AngkotRoutesLayout({
    super.key,
    required this.route,
    required this.onPressRoute,
    required this.apiClient,
    required this.routes,});

  String route = "";
  final List<LineRoute> routes;
  final void Function(LineRoute) onPressRoute;
  final ApiClient apiClient;

  @override
  State<StatefulWidget> createState() => _AngkotRouteLayoutState();

}

class _AngkotRouteLayoutState extends State<AngkotRoutesLayout> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Column(
          children: [
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
                      Text(
                        widget.route,
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var it in widget.routes)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                        children: [
                          InkWell(
                            onTap: () {

                            },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(it.name),
                                Row(
                                  children: const [
                                    Text("1"),
                                    Icon(
                                      Icons.directions_bus_sharp,
                                      color: Colors.green,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                          const Padding(padding: EdgeInsets.symmetric(
                              vertical: 8
                          )),
                          const Divider()
                        ]
                    ),
                  ),
              ],
            ),
          ],
        )
    );
  }

}