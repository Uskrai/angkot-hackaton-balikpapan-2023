import 'package:angkot_ku/client/VehicleType.dart';
import 'package:latlong2/latlong.dart';

class LineRoute {
  const LineRoute({
    required this.id,
    required this.name,
    // required this.center,
    required this.type,
    required this.lines,
  });

  final String id;
  final String name;
  // final LatLng center;
  final VehicleType type;
  final List<Lines> lines;
}

class Lines {
  const Lines({
    required this.name,
    required this.points,
  });

  final String name;
  final List<LatLng> points;

  @override
  String toString() {
    return "Lines(name: $name, points: $points)";
  }
}

class RoleRoute {
  const RoleRoute({
    required this.bus,
    required this.sharedTaxi,
  });

  final List<LineRoute> bus;
  final List<LineRoute> sharedTaxi;
}
