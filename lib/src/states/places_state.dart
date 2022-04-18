import 'package:equatable/equatable.dart';

import '../models/models.dart';

class PlacesState extends Equatable {
  final bool fetching;
  final String query;
  final List<Suggestion> suggestions;
  final bool data;
  final String? error;

  const PlacesState({
    this.fetching = false, 
    this.query = '',
    this.suggestions = const [],
    this.data = false,
    this.error, 
  });

  PlacesState copyWith({
    bool? fetching, 
    String? query,
    List<Suggestion>? suggestions, 
    bool? data, 
    String? error, 
    bool clear = false
  }) {
    return PlacesState(
      fetching: fetching ?? this.fetching,
      query: query ?? this.query,
      suggestions: suggestions ?? this.suggestions,
      data: data ?? this.data,
      error: clear ? null : error ?? this.error
    );
  }

  PlacesState initialState() => const PlacesState();

  PlacesState fetchingState() => copyWith(fetching: true, data: false, clear: true);

  PlacesState dataState(List<Suggestion> suggestions, String query) => copyWith(
    suggestions: suggestions, 
    query: query,
    data: true,  
    fetching: false
  );

  PlacesState errorState(String error) => copyWith(fetching: false, data: false, error: error);

  @override
  List<Object?> get props => [fetching, suggestions, query, error];
}