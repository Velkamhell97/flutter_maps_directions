import 'package:flutter/material.dart';
import 'dart:async';

import '../services/services.dart';
import '../states/states.dart';

/// Aqui si se utiliza un StateNotifier, se tendria que crear uno para cada PlaceState ya que como
/// Se tienen que declarar en el MateApp por utilizarse en otras pantallas, no puede ser el mismo State
class PlacesProvider extends ChangeNotifier {
  final MapBoxApi _api;

  PlacesProvider(this._api);

  PlacesState _placesA = const PlacesState();
  PlacesState get placesA => _placesA;
  set placesA(PlacesState placesA) {
    _placesA = placesA;
    notifyListeners();
  }

  PlacesState _placesB = const PlacesState();
  PlacesState get placesB => _placesB;
  set placesB(PlacesState placesB) {
    _placesB = placesB;
    notifyListeners();
  }

  Future<void> getSuggestions(String query, String marker) async {
    try {
      final response = await _api.getSuggestions(query);
      
      if(marker == 'A'){
        placesA = placesA.dataState(response.suggestions, response.query.join(' '));
      } else {
        placesB = placesB.dataState(response.suggestions, response.query.join(' '));
      }
    } catch (e) {
      if(marker == 'A'){
        placesA = placesA.errorState('Error: ${e.toString()}');
      } else {
        placesB = placesB.errorState('Error: ${e.toString()}');
      }
    }
  }

  void addQuery(String query, String marker){
    if(marker == 'A'){
      placesA = placesA.copyWith(query: query, fetching: false);
    } else {
      placesB = placesB.copyWith(query: query, fetching: false);
    }
  }

  void clearQuery(String marker){
    if(marker == 'A'){
      placesA = placesA.initialState();
    } else {
      placesB = placesB.initialState();
    }
  }
}