import 'package:flutter/material.dart' hide Route;
import 'package:state_notifier/state_notifier.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:typed_data';

import '../models/models.dart';
import '../utils/utils.dart';
import '../extensions/extensions.dart';
import '../states/states.dart';

/// Los state notifiers son mas utiles y capaces utilizando riverpod en vez de provider
class MapStateNotifier extends StateNotifier<MapState> {
  MapStateNotifier() : super(const MapState());

  late final GoogleMapController _mapController;
  
  late final BitmapDescriptor iconI;
  late final Uint8List iconA;
  late final Uint8List iconB;

  static const _north = LatLng(90.0, 0.0);
  static const _south = LatLng(-90.0, 0.0);
  static const _boundsPadding = 50.0;

  bool _unknowPosition = false;
  bool tracking = false;

  Future<void> loadResources() async {
    /// Forma de obtenerlo como imagen, al parecer el tamaño lo define el tamaño de la imagen
    iconI = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(), 'assets/zelda2.png');

    /// Solucion alterna en la que se basa en el deviceRatio y se guardan varios tamaños
    // double mq = MediaQuery.of(context).devicePixelRatio;
    // String icon = "images/car.png";
    // if (mq>1.5 && mq<2.5) {icon = "images/car2.png";}
    // else if(mq >= 2.5){icon = "images/car3.png";}

    /// Esto es como se crea un icono personalizado por medio de un canvas
    iconA = await getBytesFromCanvas(const Color(0xFF3bb2d0), 'A', 100);
    iconB = await getBytesFromCanvas(const Color(0xFF8a8acb), 'B', 100);

    Position? position;

    try {
      position = await Geolocator.getCurrentPosition();
    } catch (e) {
      position = await Geolocator.getLastKnownPosition();
    }

    if(position == null) {
      state =  state.copyWith(initialPosition: _south) ;
      _unknowPosition = true;
    } else {
      state =  state.copyWith(initialPosition: position.toLatLng()) ;
    }
  }

  void onMapCreated(GoogleMapController controller) => _mapController = controller;

  @override
  void dispose(){
    _mapController.dispose();
    super.dispose();
  }

  void addMarker(LatLng latlng, String marker) {
     if(marker == 'A') {
      state = state.copyWith(activeMarker: 'B', markerA: latlng);
    } else {
      state = state.copyWith(activeMarker: 'B', markerB: latlng);
    }
  }

  void removeMarker(String marker) {
    if(marker == 'A') {
      state = state.copyWith(activeMarker: marker, markerA: _north, routePoints: const []);
    } else {
      state = state.copyWith(activeMarker: marker, markerB: _north, routePoints: const []);
    }
  }

  Future<void> animateCamera(LatLng? latlng) async {
    if(latlng != null){
      await _mapController.animateCamera(CameraUpdate.newLatLng(latlng));
    }
  }

  Future<void> updateLocation(LatLng? latlng) async {
    if(latlng != null){
      state = state.copyWith(markerI: latlng);

      /// Por si inicia con el gps apagado cuando lo prenda mueva la camara (solo sucedera en ese caso)
      if(_unknowPosition){
        await animateCamera(latlng);
        _unknowPosition = false;
      }

      if(state.tracking){
        await animateCamera(latlng);
      }
    }
  }
  
  Future<void> traceRoute(Route route) async {
    if(route.distance < 5000) {
      final polyline = route.geometry.coordinates.map((c) => LatLng(c[1], c[0])).toList();
      state = state.copyWith(routePoints: polyline);
    }

    final bbox = getBounds(route.geometry.coordinates);
    final bounds = LatLngBounds(southwest: bbox[0], northeast: bbox[1]);

    await _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, _boundsPadding));
  }

  void cleanRoute() => state = state.copyWith(routePoints: const []);

  Future<void> navigate() async {
    if(state.canRoute){
      final bearing = Geolocator.bearingBetween(
        state.markerA.latitude, 
        state.markerA.longitude, 
        state.markerB.latitude, 
        state.markerB.longitude
      );

      final zoom = await _mapController.getZoomLevel();

      await _mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: state.markerA,
            zoom: zoom,
            bearing: bearing,
            tilt: 45
          )
        )
      );
    } 
  }

  void stopTracking() {
    state = state.copyWith(tracking: false);
  }

  void toggleTracking(){
    state = state.copyWith(tracking: !state.tracking);
  }
} 