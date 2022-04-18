import 'package:flutter/material.dart';

import '../states/states.dart';

class SuffixIcon extends StatelessWidget {
  final PlacesState places;
  final VoidCallback onClear;

  const SuffixIcon({Key? key, required this.places, required this.onClear}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(places.fetching){
      return const SizedBox.square(
        dimension: 16,
        child: Center(
          child: SizedBox.square(
            dimension: 16,
            child: CircularProgressIndicator(color: Colors.grey, strokeWidth: 2),
          ),
        ),
      );
    }

    if(places.query.isEmpty) return const SizedBox();

    return InkWell(
      onTap: onClear,
      child: const Icon(Icons.close)
    );
  }
}