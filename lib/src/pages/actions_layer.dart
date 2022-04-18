part of 'google_maps_page.dart';

class ActionsLayer extends StatelessWidget {
  const ActionsLayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0.925, 0.95),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Trace Route
          FloatingActionButton(
            onPressed: () {
              /// Para leer solo el state
              final map = context.read<MapState>();

              if(map.canRoute){
                context.read<DirectionsProvider>().getDirections(map.markerA, map.markerB);
              }
            },
            child: const Icon(Icons.route),
          ),

          const SizedBox(height: 10.0),

          /// Navigate
          FloatingActionButton(
            onPressed: context.read<MapStateNotifier>().navigate,
            child: const Icon(Icons.navigation_rounded),
          ),

          const SizedBox(height: 10.0),

          /// Center Camera
          FloatingActionButton(
            onPressed: () async {
              final position = await context.read<LocationProvider>().getPosition();
              context.read<MapStateNotifier>().animateCamera(position?.toLatLng());
            },
            child: const Icon(Icons.gps_fixed),
          ),

          const SizedBox(height: 10.0),

          /// Toggle Map Animation Camera Traking
          Selector<MapState, bool>(
            selector: (_, model) => model.tracking,
            builder: (_, tracking, __) {
              return FloatingActionButton(
                onPressed: context.read<MapStateNotifier>().toggleTracking,
                child: Icon(tracking ? Icons.man : Icons.directions_run),
              );
            },
          ),

          const SizedBox(height: 10.0),

          /// Toggle Location Updates Listen
          Selector<LocationProvider, bool>(
            selector: (_, model) => model.listening,
            builder: (_, listening, __) {
              return FloatingActionButton(
                onPressed: context.read<LocationProvider>().togglePositionStream,
                child: Icon(listening ? Icons.location_off_outlined : Icons.location_on_outlined),
              );
            },
          ),

          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}