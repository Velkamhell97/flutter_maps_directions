import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';

class PermissionsBuilder extends StatelessWidget {
  const PermissionsBuilder({Key? key}) : super(key: key);

  static const _text = "Debes aceptar los permisos de ubicacion para poder utilizar los servicios de mapas correctamente";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(_text, textAlign: TextAlign.center, style: TextStyle()),
          const SizedBox(height: 5.0),
          ElevatedButton( 
            onPressed: () => context.read<PermissionsProvider>().checkPermissions(),
            child: const Text('Solicitar Permisos')
          )
        ],
      ),
    );
  }
}