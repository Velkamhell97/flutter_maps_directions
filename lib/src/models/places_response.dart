import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

class PlacesResponse {
  final List<String> query;
  final List<Suggestion> suggestions;

  const PlacesResponse({
    required this.query,
    required this.suggestions,
  });

  factory PlacesResponse.fromJson(Map<String, dynamic> json) => PlacesResponse(
    query: List<String>.from(json["query"].map((x) => x)),
    suggestions: List<Suggestion>.from(json["features"].map((x) => Suggestion.fromJson(x))),
  );
}

class Suggestion {
  final String placeName;
  final List<double> center;

  const Suggestion({
    required this.placeName,
    required this.center,
  });

  factory Suggestion.fromJson(Map<String, dynamic> json) => Suggestion(
    placeName: json["place_name"],
    center: List<double>.from(json["center"].map((x) => x.toDouble())),
  );

  LatLng get latlng => LatLng(center[1], center[0]);

}
