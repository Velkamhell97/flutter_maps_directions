part of 'google_maps_page.dart';

class SearchLayer extends StatefulWidget {
  const SearchLayer({Key? key}) : super(key: key);

  @override
  State<SearchLayer> createState() => _SearchLayerState();
}

class _SearchLayerState extends State<SearchLayer> {
  late final SearchProvider search;
  late final PlacesProvider placesProvider;
  late final MapStateNotifier map;

  OverlayEntry? _entry;

  String _selected = '';

  final _focusNodeA = FocusNode();
  final _focusNodeB = FocusNode();

  final _debouncerA = Debouncer();
  final _debouncerB = Debouncer();

  @override
  void initState() {
    super.initState();

    search = Provider.of<SearchProvider>(context, listen: false);
    placesProvider = Provider.of<PlacesProvider>(context, listen: false);
    map = Provider.of<MapStateNotifier>(context, listen: false);

    /// Si tiene el foco cancela y quita el overlay, ademas de establecer el texto para no disparar la busqieda
    _focusNodeA.addListener(() {
      if(_focusNodeA.hasFocus){
        _debouncerB.cancel();
        _removeOverlay();

        _selected = search.textControllerA.text;

        /// Si estaba buscando en el otro lo cancela
        if(placesProvider.placesB == placesProvider.placesB.fetchingState()){
          placesProvider.addQuery(search.textControllerB.text, 'B');
        }
      }
    });

    _focusNodeB.addListener(() { //-Igual que arriba pero para el A
      if(_focusNodeB.hasFocus){
        _debouncerA.cancel();
        _removeOverlay();

        _selected = search.textControllerB.text;

        if(placesProvider.placesA == placesProvider.placesA.fetchingState()){
          placesProvider.addQuery(search.textControllerA.text, 'A');
        }
      }
    });
  }

  @override
  void dispose() {
    _removeOverlay();
    _debouncerA.cancel();
    _debouncerB.cancel();
    super.dispose();
  }

  static const _boxDecoration = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
    color: Colors.white,
    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)]
  );
  
  /// Aunque no se utilizo los completer pueden ser muy utiles
  // Future<List<Suggestion>> _debouce(String query, String label) {
  //   final completer = Completer<List<Suggestion>>();
  //
  //   if(_debouncer != null){
  //     _debouncer!.cancel();
  //   }
  //
  //   _debouncer = Timer(_duration, () async {
  //     final suggestions = await directions.getSuggestions(query);
  //     directions.updateFetching(label, FetchingState.data);
  //
  //     completer.complete(suggestions);
  //   });
  //
  //   return completer.future;
  // }

  /// Como cada input tiene sus options se debe separar esta funcion
  void _showOverlay(BuildContext context, List<Suggestion> options,  String query, Function(Suggestion) onSelected){
    final rendexBox = context.findRenderObject() as RenderBox;
    final offset = rendexBox.localToGlobal(Offset.zero);

    _entry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: offset.dy + rendexBox.size.height,
          left: offset.dx,
          child: OptionsBuilder(
            onSelected: onSelected, 
            options: options,
            query: query, 
            width: rendexBox.size.width
          ),
        );
      },
    );

    Overlay.of(context)!.insert(_entry!);
  }

  void _removeOverlay() {
    if(_entry != null){
      _entry!.remove();
      _entry = null;
    }
  }

  Future<void> _onSelectSuggestion(Suggestion suggestion, String marker) async {
    _selected = suggestion.placeName;
    
    
    search.updateTextController(suggestion.placeName, marker);
    context.read<MapStateNotifier>().addMarker(suggestion.latlng, marker);
    
    _removeOverlay();

    final map = context.read<MapState>();
    
    if(map.canRoute){
      /// Si se hace con el focusScope se causa un rebuild de toda la pagina y vuelve a mostrar el overlay
      /// Tambien se podria pasar el valueNotifier del search para ocultarlo al buscar
      (marker == 'A' ? _focusNodeA.unfocus() : _focusNodeB.unfocus());
      context.read<DirectionsProvider>().getDirections(map.markerA, map.markerB);
    }
  }

  void _clear(String marker){
    if(marker == 'A'){
      _debouncerA.cancel();
      _focusNodeA.requestFocus();
    } else {
      _debouncerB.cancel();
      _focusNodeB.requestFocus();
    }

    _selected = '';
    search.clearTextController(marker);
    placesProvider.clearQuery(marker);
    map.removeMarker(marker);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: _boxDecoration,
      child: Column(
        children: [
          //--------------------------------------
          // Direction A Input
          //--------------------------------------
          Row(
            children: [
              const LeadingBox(color: Color(0xff3bb2d0), letter: 'A'),
              Expanded(
                child: Selector<PlacesProvider, PlacesState>(
                  selector: (_, model) => model.placesA,
                  builder: (context, places, __) {
                    if(places.data){
                      Future.microtask(() => _showOverlay(
                        context, 
                        places.suggestions, 
                        places.query, 
                        (selected) => _onSelectSuggestion(selected, 'A')
                      ));
                    } else {
                      _removeOverlay();
                    }

                    return TextField(
                      controller: search.textControllerA,
                      focusNode: _focusNodeA,
                      autocorrect: false,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                        suffixIcon: SuffixIcon(places: places, onClear: () => _clear('A'))
                      ),
                      onChanged: (query) {
                        if(query.isEmpty) return _clear('A');
                        if(query.equals(_selected)) return; ///Por el rebuild del onSelect

                        placesProvider.placesA = placesProvider.placesA.fetchingState();
                        _debouncerA.run(() async {
                          _selected = query;
                          final myLocation = context.read<MapState>().markerI;
                          await placesProvider.getSuggestions(query, 'A', myLocation);
                        });
                      },
                    );
                  },
                )
              )
            ],
          ),

          Divider(color: Colors.grey.withOpacity(0.4), height: 1, thickness: 1),

          //--------------------------------------
          // Direction B Input
          //--------------------------------------
          Row(
            children: [
              const LeadingBox(color: Color(0xff8a8acb), letter: 'B'),
              Expanded(
                child: Selector<PlacesProvider, PlacesState>(
                  selector: (_, model) => model.placesB,
                  builder: (context, places, __) {
                    if(places.data){
                      Future.microtask(() => _showOverlay(
                        context, 
                        places.suggestions, 
                        places.query,
                        (selected) => _onSelectSuggestion(selected, 'B')
                      ));
                    } else {
                      _removeOverlay();
                    }

                    return TextField(
                      controller: search.textControllerB,
                      focusNode: _focusNodeB,
                      autocorrect: false,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                        suffixIcon: SuffixIcon(places: places, onClear: () => _clear('B')),
                      ),
                      onChanged: (query) {
                        if(query.isEmpty) return _clear('B');
                        if(query == _selected) return; ///Por el rebuild del onSelect

                        placesProvider.placesB = placesProvider.placesB.fetchingState();
                        _debouncerB.run(() async {
                          _selected = query;
                          final myLocation = context.read<MapState>().markerI;
                          await placesProvider.getSuggestions(query, 'B', myLocation);
                        });
                      },
                    );
                  },
                )
              )
            ],
          ),

          Divider(color: Colors.grey.withOpacity(0.4), height: 1, thickness: 1),
        ],
      ),
    );
  }
}