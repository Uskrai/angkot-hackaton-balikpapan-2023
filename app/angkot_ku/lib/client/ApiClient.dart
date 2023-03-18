import 'dart:async';
import 'dart:convert';

import 'Authenticated.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import 'Role.dart';

enum AuthenticationStatus {
  authenticated,
  unkown
}

class ApiClient {
  ApiClient({required this.url});
  final String url;
  final _authenticationController = StreamController();

  Authenticated? auth;

  Stream get authenticationStream => _authenticationController.stream;

  var authenticationStatus = AuthenticationStatus.unkown;

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

    auth = Authenticated(session: session, roles: roles);
    _authenticationController.add(null);
    authenticationStatus = AuthenticationStatus.authenticated;
  }


  // ApiWebSocket here
}