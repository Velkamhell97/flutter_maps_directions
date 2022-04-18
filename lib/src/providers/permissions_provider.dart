import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../services/services.dart';

/// Se hubiera podido manejar un state como otros providers, pero aqui los estados no llevan informacion
/// es mas para trabajar como un tipo de abstract class o freezed
enum PermissionState {
  fetching,
  denied,
  allowed,
}

class PermissionsProvider extends ChangeNotifier {
  PermissionState _permissionState = PermissionState.fetching;
  PermissionState get permissionState => _permissionState;
  set permissionState(PermissionState permissionState) {
    _permissionState = permissionState;
    notifyListeners();
  }

  PermissionsProvider() {
    checkPermissions();
  } 

  Future<void> checkPermissions() async {
    LocationPermission permissions = await Geolocator.checkPermission();

    if(permissions == LocationPermission.denied || permissions == LocationPermission.deniedForever){
      permissions = await Geolocator.requestPermission();

      if(permissions == LocationPermission.deniedForever){
        /// A pesar que no es buena practica mezclar UI con servicios este es un unico caso y no habria problema
        await NotificationsService.showPermissionsServicesDialog();
        Geolocator.openAppSettings();
      }
    }

    if(permissions == LocationPermission.denied || permissions == LocationPermission.deniedForever){
      permissionState = PermissionState.denied;
    } else {
      permissionState = PermissionState.allowed;
    }
  }
}