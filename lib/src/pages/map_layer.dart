part of 'google_maps_page.dart';

class MapLayer extends StatelessWidget {
  const MapLayer({Key? key}) : super(key: key);

  void _onTap(BuildContext context, LatLng latlng, String marker, String text) {
    context.read<MapStateNotifier>().addMarker(latlng, marker);
    context.read<PlacesProvider>().addQuery(text, marker);
    context.read<SearchProvider>().updateTextController(text, marker);

    final map = context.read<MapState>();

    if(map.canRoute){
      context.read<DirectionsProvider>().getDirections(map.markerA, map.markerB);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Selector<DirectionsProvider, DirectionsState>(
      selector: (_, model) => model.directions,
      builder: (_, directions, __) {
        if(directions.route != null){
          /// Como este build dibuja el de abajo y la funcion tambien, es necesario esperar que complete el primero
          Future.microtask(() {
            context.read<MapStateNotifier>().traceRoute(directions.route!);
          });
        }
        
        return Consumer<MapState>(
          builder: (context, map, __) {
            /// Cuando cargue el icono del marker de la posicion del usuario, habra cargado la posicion inicial y lo iconos
            if(map.initialPosition == null){
              return const Center(child: CircularProgressIndicator());
            }

            return GoogleMap(
              zoomControlsEnabled: false, /// Controlers del zoom
              initialCameraPosition: CameraPosition(zoom: 14, target: map.initialPosition!),
              minMaxZoomPreference: const MinMaxZoomPreference(8, 16),
              onMapCreated: context.read<MapStateNotifier>().onMapCreated,
              compassEnabled: false,
              // trafficEnabled: true, /// Muestra una capa para trafico
              // myLocationEnabled: true, /// Muestra boton de locacion
              mapToolbarEnabled: false,
              myLocationButtonEnabled: false,
              onTap: (latlng) {
                /// Para que solo agregue marcado si no esta haciendo foco
                // if(FocusScope.of(context).hasFocus) return FocusScope.of(context).unfocus();

                _onTap(context, latlng, map.activeMarker, latlng.parse());
              },
              markers: {
                Marker(
                  markerId: const MarkerId('A'), 
                  position: map.markerA,
                  icon: BitmapDescriptor.fromBytes(context.read<MapStateNotifier>().iconA)
                ),
                Marker(
                  markerId: const MarkerId('B'), 
                  position: map.markerB, 
                  icon: BitmapDescriptor.fromBytes(context.read<MapStateNotifier>().iconB)
                ),
                Marker(
                  markerId: const MarkerId('I'), 
                  position: map.markerI,
                  icon: context.read<MapStateNotifier>().iconI
                ),
              },
              polylines: {
                Polyline(
                  polylineId: const PolylineId('route'), 
                  color: const Color(0xff3b71b0),
                  width: 5,
                  points: map.routePoints
                )
              },
            );
          },
        );
      },
    );
  }
}