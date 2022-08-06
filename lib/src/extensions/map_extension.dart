import 'dart:convert';

extension MapExtension on Map {
  /**
   * Encodes the present map as a JSON string using [jsonEncode]
   */
  String get encode => jsonEncode(this);
}
