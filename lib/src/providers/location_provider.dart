import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

/// Aqui tampoco es necesario manejar un estado unicamente se escuchan los cambios de una variable, podria utilizarse
/// otro provider como ValueListenable pero como hay logica dentro de la clase se deja el ChangeNotifier
class LocationProvider extends ChangeNotifier {
  bool _initialized = false;
  
  bool _listening = true;
  bool get listening => _listening;
  set listening(bool listening) {
    _listening = listening;
    notifyListeners();
  }

  late final StreamSubscription<Position> _positionStream;

  static const _settings = LocationSettings(distanceFilter: 10); //distancia en metros
  
  /// Si se entra con el gps, se activa una vez y cuando hayan cambios en el gps saltara la asignacion
  /// ahora si se entra sin gps, al activarse solo se hara una vez
  void listenPositionStream(Function(Position) callback){
    if(!_initialized){
      _positionStream = Geolocator.getPositionStream(locationSettings: _settings).listen(callback);
      _initialized = true;

      _positionStream.onError((error) {
        print('Stream error $error');
      });
    }
  }

  void togglePositionStream() {
    if(_initialized){
      if(_positionStream.isPaused){
        _positionStream.resume();
        listening = true;
      } else {
        _positionStream.pause();
        listening = false;
      }
    }
  }

  @override
  void dispose() {
    _positionStream.cancel();
    _initialized = false;
    super.dispose();
  }

  /// Devuelve la posicion actual o ultima en su defecto, no exponemos aqui la posicion si no que se devuelve
  Future<Position?> getPosition() async {
    try {
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      return await Geolocator.getLastKnownPosition();
    } 
  }
}