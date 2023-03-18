import 'dart:async';
import 'dart:convert';

import 'Authenticated.dart';
import 'package:http/http.dart' as http;

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

  // ApiWebSocket here
}