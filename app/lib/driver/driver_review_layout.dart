import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AngkotReviewLayout extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AngkotReviewLayoutState();
}

class _AngkotReviewLayoutState extends State<AngkotReviewLayout> {
  String _route = "Pilih Jalan..";


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Column(
         children: [
           Container(
             margin: const EdgeInsets.only(top: 40),
             decoration: BoxDecoration(),
             padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
             child: Row(
               mainAxisSize: MainAxisSize.min,
               children: <Widget>[
                 Container(
                   decoration: BoxDecoration(),
                   padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                   child: Column(
                     mainAxisSize: MainAxisSize.min,
                     children: const <Widget>[
                       Text(
                         'Hello, Semangat kerjanya',
                         textAlign: TextAlign.left,
                         style: TextStyle(
                             color: Color.fromRGBO(0, 96, 194, 1),
                             fontFamily: 'Poppins',
                             fontSize: 15,
                             letterSpacing:
                             0 /*percentages not used in flutter. defaulting to zero*/,
                             fontWeight: FontWeight.normal,
                             height: 1),
                       ),
                       SizedBox(height: 1),
                       Text(
                         'Pak Nico',
                         textAlign: TextAlign.left,
                         style: TextStyle(
                             color: Color.fromRGBO(0, 96, 194, 1),
                             fontFamily: 'Poppins',
                             fontSize: 15,
                             letterSpacing:
                             0 /*percentages not used in flutter. defaulting to zero*/,
                             fontWeight: FontWeight.normal,
                             height: 1),
                       ),
                     ],
                   ),
                 ),
                 SizedBox(width: 113),
                 IconButton(
                   icon: Icon(Icons.logout),
                   onPressed: () {
                     // add your logout functionality here
                   },
                 ),
               ],
             ),
           ),
           Divider(),
           Container(
             margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
             width: double.infinity,
             height: size.height * 0.1,
             child: Container(
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(12),
                 boxShadow: const [
                   BoxShadow(
                     color: Color.fromRGBO(0, 0, 0, 0.25),
                     offset: Offset(0, 4),
                     blurRadius: 4,
                   ),
                 ],
                 color: Color.fromRGBO(255, 255, 255, 1),
               ),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: [
                   Icon(Icons.star),
                   Icon(Icons.star),
                   Icon(Icons.star),
                   Icon(Icons.star),
                   Icon(Icons.star_border),
                 ],
               ),
             ),
           )
         ],
        )
    );
  }

}