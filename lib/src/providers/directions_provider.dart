import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'dart:async';

import '../services/mapbox_api.dart';
import '../states/states.dart';

/// La unica diferencia con un stateNotifier esque definimos el nuevo estado con el copyWith directamente
class DirectionsProvider extends ChangeNotifier {
  final MapBoxApi _api;

  DirectionsProvider(this._api);

  DirectionsState _directions = const DirectionsState();
  DirectionsState get directions => _directions;
  set directions(DirectionsState directions) {
    _directions = directions;
    notifyListeners();
  }
  
  Future<void> getDirections(LatLng pointA, LatLng pointB) async {
    if(directions.fetching) return;

    directions = directions.fetchingState();

    try {
      final response = await _api.getDirections(pointA, pointB);
      directions = directions.dataState(response.routes[0]);
    } catch (e) {
      print('Error: ${e.toString()}');
      directions = directions.errorState('Error: ${e.toString()}');
    }
  }
}