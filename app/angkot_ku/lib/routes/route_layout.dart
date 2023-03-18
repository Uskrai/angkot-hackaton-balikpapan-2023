import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteLayout extends StatefulWidget {
  RouteLayout({
    super.key,
    required this.route
  });

  String route = "";

  @override
  State<StatefulWidget> createState() => _RouteLayoutState();

}

class _RouteLayoutState extends State<RouteLayout> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Container(
            // Menu
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
          )
        ],
      )
    );
  }

}