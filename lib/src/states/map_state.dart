import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

class MapState extends Equatable {
  static const _north = LatLng(90.0, 0.0);
  static const _south = LatLng(-90.0, 0.0);

  final LatLng? initialPosition;
  final String activeMarker;
  final bool tracking;
  final LatLng markerA;
  final LatLng markerB;
  final LatLng markerI;
  final List<LatLng> routePoints;

  const MapState({
    this.initialPosition,
    this.activeMarker = 'A',
    this.tracking = false,
    this.markerA = _north,
    this.markerB = _north,
    this.markerI = _south,
    this.routePoints = const [],
  });

  MapState copyWith({
    LatLng? initialPosition,
    String? activeMarker,
    bool? tracking,
    LatLng? markerA,
    LatLng? markerB,
    LatLng? markerI,
    List<LatLng>? routePoints,
  }) {
    return MapState(
      initialPosition: initialPosition ?? this.initialPosition,
      activeMarker: activeMarker ?? this.activeMarker,
      tracking: tracking ?? this.tracking,
      markerA: markerA ?? this.markerA,
      markerB: markerB ?? this.markerB,
      markerI: markerI ?? this.markerI,
      routePoints: routePoints ?? this.routePoints,
    );
  }

  bool get canRoute => markerA != _north && markerB != _north;
 
  /// Solo las propiedades que causan un rebuild
  @override
  List<Object?> get props => [initialPosition, tracking, markerA, markerB, markerI, routePoints];
}