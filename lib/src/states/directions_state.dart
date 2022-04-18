import 'package:equatable/equatable.dart';

import '../models/models.dart';

class DirectionsState extends Equatable {
  final bool fetching;
  final Route? route;
  final String? error;

  const DirectionsState({
    this.fetching = false, 
    this.route,
    this.error, 
  });

  DirectionsState copyWith({
    bool? fetching, 
    Route? route, 
    String? error, 
    bool clearError = false,
    bool clearRoute = false,
  }) {
    return DirectionsState(
      fetching: fetching ?? this.fetching,
      route: clearRoute ? null : route ?? this.route,
      error: clearError ? null : error ?? this.error
    );
  }

  DirectionsState initialState() => const DirectionsState();

  DirectionsState fetchingState() => copyWith(fetching: true, clearRoute: true, clearError: true);

  DirectionsState dataState(Route route) => copyWith(route: route, fetching: false);

  DirectionsState errorState(String error) => copyWith(fetching: false, clearRoute: true, error: error);

  @override
  List<Object?> get props => [fetching, route, error];
}