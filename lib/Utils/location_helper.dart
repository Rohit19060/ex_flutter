import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

String generateLocationPreviewImage({
  required double latitude,
  required double longitude,
}) =>
    'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=${dotenv.env['googleAPIKEY']}';

Future<String> getPlaceAddress(double lat, double lng) async {
  final url =
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=${dotenv.env['googleAPIKEY']}';
  final response = await http.get(Uri.parse(url));
  return json
      .decode(response.body)['results'][0]['formatted_address']
      .toString();
}
