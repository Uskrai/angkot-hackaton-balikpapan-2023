import 'package:angkot_ku/authentication/login_layout.dart';
import 'package:angkot_ku/temp/dummy_route.dart';
import 'package:angkot_ku/temp/route.dart';
import 'package:angkot_ku/user/user_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';

import 'angkot/angkot_home_layout.dart';
import 'client/ApiClient.dart';
import 'client/Role.dart';

void main() {
  var apiClient = ApiClient(url: "192.168.2.35:3000");
  runApp(
    MyApp(
      apiClient: apiClient,
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    required this.apiClient,
  });

  final ApiClient apiClient;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    widget.apiClient.authenticationStream.listen((_) {
      setState(() {});
    });

    widget.apiClient.routeStream.listen((_) {
      setState(() {});
    });
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AngkotKu',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Builder(
        builder: (context) {
          switch (widget.apiClient.authenticationStatus) {
            case AuthenticationStatus.authenticated:
              var route = widget.apiClient.route;
              if (route != null) {
                switch (widget.apiClient.auth!.roles[0].name) {
                  case RoleType.customer:
                    return HomeUserLayout(
                      routes: route,
                      apiClient: widget.apiClient,
                    );
                  case RoleType.sharedTaxi:
                    return AngkotHomeLayout(
                      routes: route,
                      apiClient: widget.apiClient,
                    );
                  case RoleType.bus:
                    return  HomeUserLayout(
                      routes: route,
                      apiClient: widget.apiClient,
                    );
                  }
              }else {
                return CircularProgressIndicator();
              }
              default:
              return LoginLayout(
                apiClient: widget.apiClient,
                onLoggedIn: () {
                  setState(() {});
                },
              );
              // return HomeUserLayout();
          }
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: FlutterMap(options: MapOptions(), children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: "org.github.uskrai.angkot",
          )
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
