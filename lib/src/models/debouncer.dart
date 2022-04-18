import 'package:flutter/material.dart';
import 'dart:async';

class Debouncer {
  final int seconds;
  Timer? _timer;

  Debouncer({this.seconds = 3});

  void run(VoidCallback callback){
    if(_timer?.isActive ?? false) _timer!.cancel();
    _timer = Timer(Duration(seconds: seconds), callback);
  }

  void cancel() => _timer?.cancel();
}