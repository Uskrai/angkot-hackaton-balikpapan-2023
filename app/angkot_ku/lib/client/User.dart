import 'package:latlong2/latlong.dart';

enum DriverType { bus, sharedTaxi }

abstract class User {
  const User();

  String get email;
  LatLng get location;

  User copyWith({
    String? email,
    LatLng? location,
  });
}

class Customer extends User {
  Customer({required this.email, required this.location});

  @override
  final String email;

  @override
  final LatLng location;

  @override
  Customer copyWith({
    String? email,
    LatLng? location,
  }) {
    return Customer(
      email: email ?? this.email,
      location: location ?? this.location,
    );
  }
}

class SharedTaxi extends User {
  SharedTaxi({required this.email, required this.location});

  @override
  final String email;

  @override
  final LatLng location;

  @override
  SharedTaxi copyWith({
    String? email,
    LatLng? location,
  }) {
    return SharedTaxi(
      email: email ?? this.email,
      location: location ?? this.location,
    );
  }
}

class Bus extends User {
  Bus({required this.email, required this.location});

  @override
  final String email;

  @override
  final LatLng location;

  @override
  Bus copyWith({
    String? email,
    LatLng? location,
  }) {
    return Bus(
      email: email ?? this.email,
      location: location ?? this.location,
    );
  }
}

class InitialCustomer {
  InitialCustomer({required this.location});
  LatLng location;

  InitialCustomer copyWith({
    LatLng? location,
  }) {
    return InitialCustomer(location: location ?? this.location);
  }
}

class InitialSharedTaxi {
  InitialSharedTaxi({required this.location});
  LatLng location;

  InitialSharedTaxi copyWith({
    LatLng? location,
  }) {
    return InitialSharedTaxi(location: location ?? this.location);
  }
}

class InitialBus {
  InitialBus({required this.location});
  LatLng location;

  InitialBus copyWith({
    LatLng? location,
  }) {
    return InitialBus(location: location ?? this.location);
  }
}
