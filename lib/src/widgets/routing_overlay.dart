import 'package:flutter/material.dart';

class RoutingOverlay extends StatelessWidget {
  const RoutingOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: Colors.black38),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const[
          CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 10),
          Text('Routing...', style: TextStyle(fontSize: 16, color: Colors.white))
        ],
      ),
    );
  }
}