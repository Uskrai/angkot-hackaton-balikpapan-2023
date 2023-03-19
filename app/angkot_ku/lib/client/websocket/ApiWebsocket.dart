import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:latlong2/latlong.dart';
import 'package:web_socket_channel/io.dart';

import '../../temp/route.dart';
import '../../maps.dart';
import '../User.dart';

class InitialMessage {
  InitialMessage({required this.email});
  String email;
}

abstract class ApiWebsocketClient {
  Stream get changed;
  List<User> get users;

  Iterable<MapEntry<String, User>> get usersEntries;

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

class ResponsePickupFromUser {
  ResponsePickupFromUser(
      {required this.user, required this.id, required this.accept});

  User user;
  String id;
  bool accept;
}

class CustomerWebsocketClient extends GenericWebsocketClient {
  CustomerWebsocketClient(
    this.url,
    this.authorization,
    this.route,
    this.customer,
    this.driver,
  );

  final _changedController = StreamController();

  @override
  String get routeName => "customer";

  @override
  IOWebSocketChannel? _wsChannel;

  final DriverType driver;

  @override
  Iterable<MapEntry<String, User>> get usersEntries => _users.entries;

  @override
  Stream get changed => _changedController.stream;

  @override
  List<User> get users => _users.values.toList();
  final HashMap<String, User> _users = HashMap();

  final _notifyController = StreamController<ResponsePickupFromUser>();

  Stream get notify => _notifyController.stream;

  @override
  User get currentUser => customer;

  final String authorization;
  String url;
  LineRoute route;
  Customer customer;

  void _notifyChange() {
    if (!isClosed()) {
      _changedController.add(null);
    }
  }

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

    var channel = IOWebSocketChannel.connect(
      uri,
      headers: {
        "Authorization": "Bearer $authorization",
      },
    );
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

        if (handleReceiveDefault(json, _users)) {
          _notifyChange();
        }

        if (handleReceive(json)) {
          return;
        }

        var initial = decodeInitialMessage(json);
        if (initial != null) {
          customer = customer.copyWith(email: initial.email);
        }
      },
    );

    _wsChannel = channel;
  }

  bool handleReceive(dynamic json) {
    if (json['PickupResponse']) {
      var type = json["PickupResponse"];
      bool accept = type["accept"];
      String id = type["id"];

      var user = _users[id];

      if (user != null) {
        _notifyController.add(ResponsePickupFromUser(
          user: user,
          id: id,
          accept: accept,
        ));
      }
    }

    return false;
  }

  void requestPickup(String id) {
    _wsChannel?.sink.add(
      jsonEncode(
        {
          "PickupRequest": {
            "id": id,
          }
        },
      ),
    );
  }

  void responsePickup(String id, bool accept) {
    //
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

abstract class DriverWebsocketClient extends GenericWebsocketClient {
  Stream<UserWithId> get notify;

  bool handleReceive(dynamic json) {
    if (json['PickupRequest'] != null) {
      return handlePickupRequest(json['PickupRequest']['id']);
    }

    return false;
  }

  bool handlePickupRequest(String id);
  void responsePickup(String id, bool accept);
}

class SharedTaxiWebsocketClient extends DriverWebsocketClient {
  SharedTaxiWebsocketClient(
    this.url,
    this.authorization,
    this.route,
    this.sharedTaxi,
  );
  final _changedController = StreamController();
  @override
  Stream get changed => _changedController.stream;

  @override
  String get routeName => "shared-taxi";

  @override
  IOWebSocketChannel? _wsChannel;

  final String authorization;
  final String url;
  final LineRoute route;

  final _notifyController = StreamController<UserWithId>();

  @override
  Stream<UserWithId> get notify => _notifyController.stream;

  @override
  User get currentUser => sharedTaxi;
  SharedTaxi sharedTaxi;

  @override
  List<User> get users => _users.values.toList();

  @override
  Iterable<MapEntry<String, User>> get usersEntries => _users.entries;
  final HashMap<String, User> _users = HashMap();

  void _notifyChange() {
    if (!isClosed()) {
      _changedController.add(null);
    }
  }

  @override
  void connect() {
    var uri = Uri.encodeFull(
      "ws://$url/$routeName/${route.id}",
    );
    var channel = IOWebSocketChannel.connect(
      uri,
      headers: {
        "Authorization": "Bearer $authorization",
      },
    );
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

      if (handleReceiveDefault(json, _users)) {
        _notifyChange();
        return;
      }

      if (super.handleReceive(json)) {
        return;
      }

      var initial = decodeInitialMessage(json);
      if (initial != null) {
        sharedTaxi = sharedTaxi.copyWith(email: initial.email);
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
  bool handlePickupRequest(String id) {
    var it = _users[id];

    if (it != null) {
      _notifyController.add(UserWithId(user: it, id: id));
    }

    return false;
  }

  @override
  void responsePickup(String id, bool accept) {
    _wsChannel?.sink.add(
      jsonEncode(
        {
          "PickupResponse": {"id": id, "accept": accept},
        },
      ),
    );
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

class BusWebsocketClient extends DriverWebsocketClient {
  BusWebsocketClient(this.url, this.authorization, this.route, this.bus);
  final _changedController = StreamController();
  @override
  Stream get changed => _changedController.stream;

  @override
  String get routeName => "bus";

  final _notifyController = StreamController<UserWithId>();
  @override
  Stream<UserWithId> get notify => _notifyController.stream;

  @override
  IOWebSocketChannel? _wsChannel;

  final String url;
  final String authorization;
  final LineRoute route;

  @override
  User get currentUser => bus;

  Bus bus;

  @override
  List<User> get users => _users.values.toList();
  @override
  Iterable<MapEntry<String, User>> get usersEntries => _users.entries;
  final HashMap<String, User> _users = HashMap();

  void _notifyChange() {
    if (!isClosed()) {
      _changedController.add(null);
    }
  }

  @override
  void connect() {
    print(route.id);
    var uri = Uri.encodeFull(
      "ws://$url/$routeName/${route.id}",
    );
    var channel = IOWebSocketChannel.connect(
      uri,
      headers: {
        "Authorization": "Bearer $authorization",
      },
    );
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

      if (handleReceiveDefault(json, _users)) {
        _notifyChange();
        return;
      }

      if (super.handleReceive(json)) {
        return;
      }

      var initial = decodeInitialMessage(json);
      if (initial != null) {
        bus = bus.copyWith(email: initial.email);
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
  bool handlePickupRequest(String id) {
    var it = _users[id];

    if (it != null) {
      _notifyController.add(UserWithId(user: it, id: id));
    }

    return false;
  }

  @override
  void responsePickup(String id, bool accept) {
    _wsChannel?.sink.add(
      jsonEncode(
        {
          "PickupResponse": {"id": id, "accept": accept},
        },
      ),
    );
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

InitialMessage? decodeInitialMessage(dynamic json) {
  if (json['InitialMessage'] != null) {
    var email = json["InitialMessage"]['email'];

    print(json);
    return InitialMessage(email: email);
  }
  return null;
}

bool handleReceiveDefault(dynamic json, HashMap<String, User> users) {
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
