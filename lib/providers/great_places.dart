import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:places/models/places.dart';
import 'package:places/utils/db_util.dart';
import 'package:places/utils/location_util.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Future<void> loadPlaces() async {
    final dataList = await DbUtil.getData('places');

    _items = dataList
        .map(
          (e) => Place(
            id: e['id'],
            title: e['title'],
            image: File(e['image']),
            location: PlaceLocation(
              e['address'],
              latitude: e['latitude'],
              longitude: e['longitude'],
            ),
          ),
        )
        .toList();

    notifyListeners();
  }

  int get itemsCount {
    return _items.length;
  }

  Place itemByIndex(index) {
    return _items[index];
  }

  Future<void> addPlace(String title, File file, LatLng position) async {
    String address = await LocationUtil.getAddressFrom(position);
    final newPlace = Place(
      id: Random().nextDouble().toString(),
      title: title,
      location: PlaceLocation(address,
          latitude: position.latitude, longitude: position.longitude),
      image: file,
    );

    _items.add(newPlace);

    DbUtil.insert('places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': file.path,
      'latitude': position.latitude,
      'longitude': position.longitude,
      'address': address
    });
    notifyListeners();
  }
}
