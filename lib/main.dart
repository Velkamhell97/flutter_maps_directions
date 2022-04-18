import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:google_maps/src/states/map_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show AndroidGoogleMapsFlutter;
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'src/pages/google_maps_page.dart';
import 'src/providers/providers.dart';
import 'src/services/services.dart';

void main() async {
  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }

  await dotenv.load();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => MapBoxApi()),
        Provider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => PermissionsProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        /// Este provider expone tanto el provider como el state ambos accesibles por medio del contex.read/watch
        /// o los widgets consumer, selector
        StateNotifierProvider<MapStateNotifier, MapState>(create: (_) => MapStateNotifier()),
        ChangeNotifierProvider(create: (context) => PlacesProvider(context.read<MapBoxApi>())),
        ChangeNotifierProvider(create: (context) => DirectionsProvider(context.read<MapBoxApi>()))
      ],
      child: MaterialApp(
        scaffoldMessengerKey: NotificationsService.messengerKey,
        navigatorKey: NotificationsService.navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const GoogleMapsPage(),  
      ),
    );
  }
}