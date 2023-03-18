import 'package:latlong2/latlong.dart';

enum DriverType { bus, sharedTaxi }

abstract class User {
  const User();

  get location;

  User copyWith({
    LatLng? location,
  });

}

class Customer extends User {
  Customer({required this.location});

  @override
  final LatLng location;

  @override
  Customer copyWith({
    LatLng? location,
  }) {
    return Customer(
      location: location ?? this.location,
    );
  }
}

class SharedTaxi extends User {
  SharedTaxi({required this.location});

  @override
  final LatLng location;

  @override
  SharedTaxi copyWith({
    LatLng? location,
  }) {
    return SharedTaxi(
      location: location ?? this.location,
    );
  }
}

class Bus extends User {
  Bus({required this.location});

  @override
  final LatLng location;

  @override
  Bus copyWith({
    LatLng? location,
  }) {
    return Bus(
      location: location ?? this.location,
    );
  }
}