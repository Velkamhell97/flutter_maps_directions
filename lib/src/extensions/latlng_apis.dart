import 'package:google_maps_flutter/google_maps_flutter.dart';

extension LatLngParsing on LatLng {
  String parse([String separator = ',']) {
    return "${longitude.toStringAsFixed(4)}$separator${latitude.toStringAsFixed(4)}";
  }

  List<double> toList() {
    return [longitude, latitude];
  }
}