import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../models/models.dart';
import '../extensions/extensions.dart';

class MapBoxApi {
  final _accessToken = dotenv.env['MAPBOX_ACCESS_TOKEN']!;

  static const _authority = 'api.mapbox.com';
  static const _searchApi = '/geocoding/v5/mapbox.places';
  static const _directionsApi = '/directions/v5/mapbox/driving';

  Future<PlacesResponse> getSuggestions(String query, LatLng proximity) async {
    print('Searching for: $query....');

    final endpoint = Uri.https(_authority, "$_searchApi/$query.json", {
      'access_token': _accessToken,
      'country': 'co',
      'proximity': proximity.parse(),
      'limit': '5',
    });

    final response = await http.get(endpoint);

    final placesResponse = PlacesResponse.fromJson(json.decode(response.body));

    return placesResponse;
  }

  Future<DirectionsResponse> getDirections(LatLng pointA, LatLng pointB) async {
    final coordinates = pointA.parse() + ";" + pointB.parse();

    final endpoint = Uri.https(_authority, "$_directionsApi/$coordinates", {
      'access_token': _accessToken,
      'geometries': 'geojson',
    });

    final response = await http.get(endpoint);

    return DirectionsResponse.fromJson(json.decode(response.body));
  }
}
