import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;


List<String> splitByMatch(String text, String query){
  final reg = RegExp('(?<=$query)|(?=$query)', caseSensitive: false);
  return text.split(reg);
}

/// Tambien se puede convertir un widget a imagen y luego a bytes pero es mas complejo (repaint boundary)
Future<Uint8List> getBytesFromCanvas(Color color, String text, double radius) async {
  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);
  
  final center = radius / 2;
  final Paint paint = Paint()..color = color;
  canvas.drawCircle(Offset(center, center), center, paint);

  TextPainter painter = TextPainter(
    text: TextSpan(text: text, style: const TextStyle(fontSize: 30)),
    textDirection: TextDirection.ltr
  )..layout();
  painter.paint(canvas, Offset(center - painter.width * 0.5, center - painter.height * 0.5));

  final img = await pictureRecorder.endRecording().toImage(radius.toInt(), radius.toInt());
  final data = await img.toByteData(format: ui.ImageByteFormat.png);
  return data!.buffer.asUint8List();
}

Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);

  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
}

List<LatLng> getBounds(List<List<double>> coords){
  final List<double> lats = []; 
  final List<double> lngs = []; 

  for (int i = 0; i < coords.length; i++)  {
    lats.add(coords[i][1]);
    lngs.add(coords[i][0]);
  }

  /// El minimo y maximo de una lista
  double minlat = lats.reduce(min);
  double maxlat = lats.reduce(max);
  double minlng = lngs.reduce(min);
  double maxlng = lngs.reduce(max);

  return [LatLng(minlat, minlng), LatLng(maxlat, maxlng)];
}