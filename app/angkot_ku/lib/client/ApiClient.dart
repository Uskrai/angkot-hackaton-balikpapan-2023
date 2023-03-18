import 'dart:async';
import 'dart:convert';

import 'package:angkot_ku/client/User.dart';
import 'package:angkot_ku/client/VehicleType.dart';
import 'package:angkot_ku/client/websocket/ApiWebsocket.dart';
import 'package:angkot_ku/temp/route.dart';
import 'package:latlong2/latlong.dart';

import 'Authenticated.dart';
import 'package:http/http.dart' as http;

import 'Role.dart';

enum AuthenticationStatus { authenticated, unkown }

enum RouteStatus { loaded, unkown }

class ApiClient {
  ApiClient({required this.url});
  final String url;
  final _authenticationController = StreamController();
  final _routesController = StreamController();

  Authenticated? auth;
  RoleRoute? route;

  Stream get authenticationStream => _authenticationController.stream;
  Stream get routeStream => _routesController.stream;

  var authenticationStatus = AuthenticationStatus.unkown;
  var routeType = DriverType.bus;
  var routeStatus = RouteStatus.unkown;

  void handleRoutesResponse(http.Response response) {
    var body = response.body;
    dynamic json;

    try {
      json = jsonDecode(response.body);
    } catch (_) {
      throw body;
    }

    var error = json["message"];
    if (error != null) {
      throw error;
    }

    var data = json["data"];
    var session = data["session"];

    List<Role> roles = [];
    for (var role in data["roles"]) {
      RoleType name;
      switch (role["name"]) {
        case "Customer":
          name = RoleType.customer;
          break;
        case "Shared Taxi":
          name = RoleType.sharedTaxi;
          break;
        case "Bus":
          name = RoleType.bus;
          break;
        default:
          name = RoleType.customer;
          break;
      }
      roles.add(Role(id: role["id"], name: name));
    }
  }

  void handleLoginResponse(http.Response response) {
    var body = response.body;
    dynamic json;

    try {
      json = jsonDecode(response.body);
    } catch (_) {
      throw body;
    }

    var error = json["message"];
    if (error != null) {
      throw error;
    }

    var data = json["data"];
    var session = data["session"];

    List<Role> roles = [];
    for (var role in data["roles"]) {
      RoleType name;
      switch (role["name"]) {
        case "Customer":
          name = RoleType.customer;
          break;
        case "Shared Taxi":
          name = RoleType.sharedTaxi;
          _routesController.add(null);
          routeType = DriverType.sharedTaxi;
          break;
        case "Bus":
          name = RoleType.bus;
          _routesController.add(null);
          routeType = DriverType.bus;
          break;
        default:
          name = RoleType.customer;
          break;
      }
      roles.add(Role(id: role["id"], name: name));
    }

    auth = Authenticated(session: session, roles: roles);
    _authenticationController.add(null);
    authenticationStatus = AuthenticationStatus.authenticated;

    getRoutes();
  }

  Future<void> signIn(String email, String password) async {
    var response = await http.post(
      Uri.http(url, "api/v1/auth/login"),
      body: jsonEncode(
        {"email": email, "password": password},
      ),
      headers: {"Content-Type": "application/json"},
    );

    handleLoginResponse(response);
  }

  Future<void> signUp(
    String email,
    String password,
    List<RoleType> role,
  ) async {
    var response = await http.post(Uri.http(url, "api/v1/auth/register"),
        body: jsonEncode(
          {
            "email": email,
            "password": password,
            "roles": role.map((e) {
              switch (e) {
                case RoleType.customer:
                  return {"id": 1};
                case RoleType.sharedTaxi:
                  return {"id": 2};
                case RoleType.bus:
                  return {"id": 3};
              }
            }).toList()
          },
        ),
        headers: {"Content-Type": "application/json"});

    handleLoginResponse(response);
  }

  Future<void> logOut() async {
    authenticationStatus = AuthenticationStatus.unkown;
    auth = null;
    _authenticationController.add(null);
  }

  ApiWebsocketClient createCustomer(
    LineRoute route,
    InitialCustomer customer,
    DriverType driver,
  ) {
    return CustomerWebsocketClient(
      url,
      auth!.session,
      route,
      Customer(email: "", location: customer.location),
      driver,
    );
  }

  ApiWebsocketClient createSharedTaxi(
    LineRoute route,
    InitialSharedTaxi sharedTaxi,
  ) {
    return SharedTaxiWebsocketClient(
      url,
      auth!.session,
      route,
      SharedTaxi(email: "", location: sharedTaxi.location),
    );
  }

  ApiWebsocketClient createBus(
    LineRoute route,
    InitialBus bus,
  ) {
    return BusWebsocketClient(
      url,
      auth!.session,
      route,
      Bus(email: "", location: bus.location),
    );
  }

  Future<void> getRoutes() async {
    var response = await http.get(Uri.http(url, "api/v1/route"),
        headers: {"Content-Type": "application/json"});

    var body = response.body;
    dynamic json;

    try {
      json = jsonDecode(response.body);
    } catch (_) {
      throw body;
    }

    List<LineRoute> bus = List.empty(growable: true);
    List<LineRoute> sharedTaxi = List.empty(growable: true);
    for (var route in json['routes']) {
      String id = route['id'];
      String name = route['name'];

      VehicleType type = VehicleType.Bus;
      switch (route['type']) {
        case "Bus":
          type = VehicleType.Bus;
          break;
        case "SharedTaxi":
          type = VehicleType.SharedTaxi;
          break;
      }

      List<LatLng> points = List.empty(growable: true);
      for (var line in route['lines']) {
        points.add(LatLng(line['latitude'], line['longitude']));
      }
      Lines lines = Lines(name: "", points: points);

      switch (type) {
        case VehicleType.Bus:
          bus.add(LineRoute(id: id, type: type, lines: [lines], name: name));
          break;
        case VehicleType.SharedTaxi:
          sharedTaxi
              .add(LineRoute(id: id, type: type, lines: [lines], name: name));
          break;
      }
    }
    var routes = RoleRoute(bus: bus, sharedTaxi: sharedTaxi);

    route = routes;
    _routesController.add(null);
    routeStatus = RouteStatus.loaded;
  }
}
