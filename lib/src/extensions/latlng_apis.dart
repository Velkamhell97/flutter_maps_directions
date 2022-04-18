import 'package:google_maps_flutter/google_maps_flutter.dart';

extension LatLngParsing on LatLng {
  String parse() {
    return "${longitude.toStringAsFixed(4)}, ${latitude.toStringAsFixed(4)}";
  }

  List<double> toList() {
    return [longitude, latitude];
  }
}