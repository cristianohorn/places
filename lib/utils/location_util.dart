import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

const GOOGLE_API_KEY = "AIzaSyDTX1Nb2ZpgbVYVviNiXXUVSGq9P5R0UA8";

class LocationUtil {
  static String generateLocationPreviewImage({
    required double latitude,
    required double longitude,
  }) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=19&size=600x300&maptype=roadmap&markers=color:red%7Alabel:C%7C$latitude,$longitude&key=$GOOGLE_API_KEY';
  }

  static Future<String> getAddressFrom(LatLng position) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$GOOGLE_API_KEY';
    final response = await http.get(Uri.parse(url));
    Map<String, dynamic> data = json.decode(response.body);
    return data['results'][0]['formatted_address'].toString();
  }
}
