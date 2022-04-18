import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class DialogModel {
  final IconData icon;
  final String title;
  final String body;
  final String mainButton;
  final String? secondaryButton;

  const DialogModel({required this.icon, required this.title, required this.body, required this.mainButton, this.secondaryButton});
}

class NotificationsService {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();
  static final navigatorKey = GlobalKey<NavigatorState>();

  static Future<bool> _dialogBuilder(DialogModel dialog) async {
    return await showGeneralDialog<bool>(
      context: navigatorKey.currentContext!, 
      pageBuilder: (_, animation, __) => SlideTransition(
        position: Tween(begin: const Offset(0.0, 1.0), end: const Offset(0.0, 0.0)).animate(animation),
        child: CustomDialog(dialog: dialog),
      ),
    ) ?? false;
  }

   static Future<bool> showPermissionsServicesDialog() async {
    const dialog = DialogModel(
      icon: Icons.location_off_outlined, 
      title: "Location Permissions", 
      body: "You permanently disbaled location permissions, please modify permissions in setting and try again", 
      mainButton: 'Accept',
      // secondaryButton: 'Decline'
    );

    return await _dialogBuilder(dialog);
  }

  static Future<bool> showLocationServicesDialog() async {
    const dialog = DialogModel(
      icon: Icons.gps_fixed, 
      title: "Location Services", 
      body: "You must activate the gps if you want to have location updates", 
      mainButton: 'Accept',
      // secondaryButton: 'Decline'
    );

    return await _dialogBuilder(dialog);
  }

  static Future<bool> showGetRouteDialog() async {
    const dialog = DialogModel(
      icon: Icons.error, 
      title: "Routing Service", 
      body: "There was an error while getting the routes please try again", 
      mainButton: 'Accept',
      // secondaryButton: 'Decline'
    );

    return await _dialogBuilder(dialog);
  }

  static Future<void> showSnackBar(String message) async{
    messengerKey.currentState!.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}