import 'package:flutter/material.dart';

import 'authentication/login_layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Angkot Ku',
        theme: ThemeData(),
        home: const Scaffold(
          body: LoginLayout(),
        )
    );
  }
}
