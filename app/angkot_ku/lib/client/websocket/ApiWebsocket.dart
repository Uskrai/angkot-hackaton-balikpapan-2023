import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:latlong2/latlong.dart';
import 'package:web_socket_channel/io.dart';

import '../../temp/route.dart';
import '../../maps.dart';
import '../User.dart';

abstract class ApiWebsocketClient {
  Stream get changed;
  List<User> get users;

  User get currentUser;

  void connect();
  void changeLocation(LatLng location);
  void close();
  bool isClosed();
}

abstract class GenericWebsocketClient extends ApiWebsocketClient {
  IOWebSocketChannel? get _wsChannel;

  String get routeName;

  @override
  void changeLocation(LatLng location) {
    _wsChannel?.sink.add(
      jsonEncode(
        {
          "UpdateLocation": {
            "location": {
              "latitude": currentUser.location.latitude,
              "longitude": currentUser.location.longitude,
            }
          }
        },
      ),
    );
  }
}

class CustomerWebsocketClient extends GenericWebsocketClient {
  CustomerWebsocketClient(this.url, this.route, this.customer, this.driver);

  final _changedController = StreamController();

  @override
  String get routeName => "customer";

  @override
  IOWebSocketChannel? _wsChannel;

  final DriverType driver;

  @override
  Stream get changed => _changedController.stream;

  @override
  List<User> get users => _users.values.toList();
  final HashMap<String, User> _users = HashMap();

  @override
  User get currentUser => customer;

  String url;
  LineRoute route;
  Customer customer;

  @override
  void connect() {
    String uri;
    switch (driver) {
      case DriverType.bus:
        uri = Uri.encodeFull("ws://$url/customer/bus/${route.id}");
        break;
      case DriverType.sharedTaxi:
        uri = Uri.encodeFull("ws://$url/customer/shared-taxi/${route.id}");
        break;
    }

    var channel = IOWebSocketChannel.connect(uri);
    channel.sink.add(
      jsonEncode(
        {
          "InitialMessage": {
            "location": {
              "latitude": customer.location.latitude,
              "longitude": customer.location.longitude,
            }
          }
        },
      ),
    );

    channel.stream.listen(
      (event) {
        var json = jsonDecode(event);

        if (handleReceive(json, _users)) {
          _changedController.add(null);
        }
      },
    );

    _wsChannel = channel;
  }

  @override
  void changeLocation(LatLng location) {
    customer = customer.copyWith(
      location: location,
    );

    super.changeLocation(location);
    _changedController.add(null);
  }

  @override
  void close() {
    _changedController.close();
    _wsChannel?.sink.close();
  }

  @override
  bool isClosed() {
    return _changedController.isClosed || _wsChannel?.closeCode != null;
  }
}

class SharedTaxiWebsocketClient extends GenericWebsocketClient {
  SharedTaxiWebsocketClient(this.url, this.route, this.sharedTaxi);
  final _changedController = StreamController();
  @override
  Stream get changed => _changedController.stream;

  @override
  String get routeName => "shared-taxi";

  @override
  IOWebSocketChannel? _wsChannel;

  final String url;
  final LineRoute route;

  @override
  User get currentUser => sharedTaxi;
  SharedTaxi sharedTaxi;

  @override
  List<User> get users => _users.values.toList();
  final HashMap<String, User> _users = HashMap();

  @override
  void connect() {
    var uri = Uri.encodeFull(
      "ws://$url/$routeName/${route.name}",
    );
    var channel = IOWebSocketChannel.connect(uri);
    channel.sink.add(
      jsonEncode(
        {
          "InitialMessage": {
            "location": {
              "latitude": sharedTaxi.location.latitude,
              "longitude": sharedTaxi.location.longitude,
            }
          }
        },
      ),
    );

    channel.stream.listen((event) {
      var json = jsonDecode(event);

      if (handleReceive(json, _users)) {
        _changedController.add(null);
      }
    });
  }

  @override
  void changeLocation(LatLng location) {
    sharedTaxi = sharedTaxi.copyWith(
      location: location,
    );
    super.changeLocation(location);
  }

  @override
  void close() {
    _changedController.close();
    _wsChannel?.sink.close();
  }

  @override
  bool isClosed() {
    return _changedController.isClosed || _wsChannel?.closeCode != null;
  }
}

class BusWebsocketClient extends GenericWebsocketClient {
  BusWebsocketClient(this.url, this.route, this.bus);
  final _changedController = StreamController();
  @override
  Stream get changed => _changedController.stream;

  @override
  String get routeName => "bus";

  @override
  IOWebSocketChannel? _wsChannel;

  final String url;
  final LineRoute route;

  @override
  User get currentUser => bus;
  Bus bus;

  @override
  List<User> get users => _users.values.toList();
  final HashMap<String, User> _users = HashMap();

  @override
  void connect() {
    var uri = Uri.encodeFull(
      "ws://$url/$routeName/${route.name}",
    );
    var channel = IOWebSocketChannel.connect(uri);
    channel.sink.add(
      jsonEncode(
        {
          "InitialMessage": {
            "location": {
              "latitude": bus.location.latitude,
              "longitude": bus.location.longitude,
            }
          }
        },
      ),
    );

    channel.stream.listen((event) {
      var json = jsonDecode(event);

      if (handleReceive(json, _users)) {
        _changedController.add(null);
      }
    });
  }

  @override
  void changeLocation(LatLng location) {
    bus = bus.copyWith(
      location: location,
    );
    super.changeLocation(location);
  }

  @override
  void close() {
    _changedController.close();
    _wsChannel?.sink.close();
  }

  @override
  bool isClosed() {
    return _changedController.isClosed || _wsChannel?.closeCode != null;
  }
}

bool handleReceive(dynamic json, HashMap<String, User> users) {
  var isHandled = true;
  if (json["NewUser"] != null) {
    var newUser = json["NewUser"];
    var id = newUser["id"];
    var userType = newUser["user"];
    dynamic user;

    if (userType["SharedTaxi"] != null) {
      user = userType["SharedTaxi"];
    } else if (userType["Customer"] != null) {
      user = userType["Customer"];
    } else if (userType["Bus"] != null) {
      user = userType["Bus"];
    }

    String email = user['email'];
    var location = decodeLatLng(user["location"]);

    if (userType["SharedTaxi"] != null) {
      users[id] = SharedTaxi(
        email: email,
        location: location,
      );
    } else if (userType["Customer"] != null) {
      users[id] = Customer(
        email: email,
        location: location,
      );
    } else if (userType["Bus"] != null) {
      users[id] = Bus(
        email: email,
        location: location,
      );
    }
  } else if (json["UpdateLocation"] != null) {
    var updateLocation = json["UpdateLocation"];

    var id = updateLocation["id"];
    var location = decodeLatLng(updateLocation["location"]);

    var user = users[id];
    if (user != null) {
      users[id] = user.copyWith(
        location: location,
      );
    }
  } else if (json["RemoveUser"] != null) {
    var removeUser = json["RemoveUser"];
    String id = removeUser["id"];

    users.remove(id);
  } else {
    isHandled = false;
  }

  return isHandled;
}

