import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../providers/providers.dart';
import '../services/services.dart';
import '../extensions/extensions.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';
import '../states/states.dart';

/// Se definen partes porque solo se usan en este widget o screen
part 'map_layer.dart';
part 'actions_layer.dart';
part 'search_layer.dart';

class GoogleMapsPage extends StatefulWidget {
  const GoogleMapsPage({Key? key}) : super(key: key);

  @override
  State<GoogleMapsPage> createState() => _GoogleMapsPageState();
}

class _GoogleMapsPageState extends State<GoogleMapsPage> {
  final _collapseNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      final map = context.read<MapStateNotifier>();
      final location = context.read<LocationProvider>();

      await map.loadResources();

      final isGpsActive = await Geolocator.isLocationServiceEnabled();

      /// Si lo tiene activado inicia el listener, caso contrario espera a que los encienda para iniciarlo
      if(isGpsActive){
        location.listenPositionStream((position) {
          map.updateLocation(position.toLatLng());
        });
      } else {
        NotificationsService.showLocationServicesDialog();
      }

      Geolocator.getServiceStatusStream().distinct().listen((status) {
        if(status == ServiceStatus.disabled){
          NotificationsService.showLocationServicesDialog();
        } else {
          location.listenPositionStream((position) {
            map.updateLocation(position.toLatLng());
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Selector<PermissionsProvider, PermissionState>(
        selector: (_, model) => model.permissionState,
        builder: (_, state, __) {
          if(state == PermissionState.fetching){
            return const Center(child: CircularProgressIndicator());
          }

          if(state == PermissionState.denied){
            return const PermissionsBuilder();
          }

          return Stack(
            children: [
              //------------------------------------------
              // Google Map
              //------------------------------------------
              Listener(
                onPointerMove: (_) => context.read<MapStateNotifier>().stopTracking(),
                child: const MapLayer()
              ),

              //------------------------------------------
              // Search Box
              //------------------------------------------
              ValueListenableBuilder<bool>(
                valueListenable: _collapseNotifier,
                builder: (_, collapsed, __){
                  return AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    top: collapsed ? -80 : 40,
                    left: 10,
                    right: 10,
                    child: Column(
                      children: [
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: collapsed ? 0 : 1,
                          child: const SearchLayer()
                        ),
                        ExpandibleButton(
                          showSearchBar: !collapsed,
                          onTap: () => setState(() => _collapseNotifier.value = !_collapseNotifier.value)
                        )
                      ],
                    ),
                  );
                },
              ),

              //------------------------------------------
              // Floating Buttons
              //------------------------------------------
              const ActionsLayer(),

              //------------------------------------------
              // Routing Overlay
              //------------------------------------------
              Selector<DirectionsProvider, bool>(
                selector: (_, model) => model.directions.fetching,
                builder: (_, fetching, __) {
                  if(fetching) return const Positioned.fill(child: RoutingOverlay());
                  return const SizedBox.shrink();
                },
              )
            ],
          );
        },
      ),
    );
  }
}
