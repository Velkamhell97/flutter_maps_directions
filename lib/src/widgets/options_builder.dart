import 'package:flutter/material.dart';
import 'dart:math';

import '../models/models.dart';
import '../utils/utils.dart';
import '../extensions/extensions.dart';

class OptionsBuilder extends StatelessWidget {
  final void Function(Suggestion) onSelected;
  final Iterable<Suggestion> options;
  final double height;
  final double width;
  final int maxResults;
  final String query;

  const OptionsBuilder({
    Key? key, 
    required this.onSelected,
    required this.options,
    this.height = 200,
    this.width = double.infinity,
    this.maxResults = 3,
    this.query = ''
  }) : super(key: key);

  static const _bold = TextStyle(fontWeight: FontWeight.bold);
  static const _grey = TextStyle(color: Colors.grey);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(8.0)),
      ),
      child: Builder(
        builder: (_) {
          if(options.isEmpty){
            return const ListTile(title: Text('No se encontraron resultados', style: _grey));
          }

          return SizedBox(
            height: 52.0 * min(options.length, 4),
            width: width,
            child: ListView.builder(
              padding: const EdgeInsets.all(0.0),
              itemCount: options.length,
              itemBuilder: (BuildContext context, int index) {
                final suggestion = options.elementAt(index);

                final matches = splitByMatch(suggestion.placeName, query);

                return ListTile(
                  onTap: () => onSelected(suggestion),
                  title: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                      children: [
                        ...matches.map((text) => TextSpan(text:text, style: text.equals(query) ? _bold : null))
                      ]
                    ),
                  ),
                );
              },
            ),
          );
        }
      )
    );
  }
}