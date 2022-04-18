class DirectionsResponse {
  final List<Route> routes;
  final List<Waypoint> waypoints;
  final String code;

  const DirectionsResponse({
    required this.routes,
    required this.waypoints,
    required this.code,
  });

  factory DirectionsResponse.fromJson(Map<String, dynamic> json) => DirectionsResponse(
    routes: List<Route>.from(json["routes"].map((x) => Route.fromJson(x))),
    waypoints: List<Waypoint>.from(json["waypoints"].map((x) => Waypoint.fromJson(x))),
    code: json["code"],
  );
}

class Route {
  final double duration;
  final double distance;
  final Geometry geometry;

  const Route({
    required this.duration,
    required this.distance,
    required this.geometry,
  });

  factory Route.fromJson(Map<String, dynamic> json) => Route(
    duration: json["duration"].toDouble(),
    distance: json["distance"].toDouble(),
    geometry: Geometry.fromJson(json["geometry"]),
  );
}

class Geometry {
  final List<List<double>> coordinates;
  final String type;

  const Geometry({
    required this.coordinates,
    required this.type,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
    coordinates: List<List<double>>.from(json["coordinates"].map((x) => List<double>.from(x.map((x) => x.toDouble())))),
    type: json["type"],
  );
}

class Waypoint {
  final double distance;
  final String name;
  final List<double> location;

  const Waypoint({
    required this.distance,
    required this.name,
    required this.location,
  });

  factory Waypoint.fromJson(Map<String, dynamic> json) => Waypoint(
    distance: json["distance"].toDouble(),
    name: json["name"],
    location: List<double>.from(json["location"].map((x) => x.toDouble())),
  );
}
