import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:places/screens/map_screen.dart';
import 'package:places/utils/location_util.dart';

class LocationInput extends StatefulWidget {
  const LocationInput(this.onSelectPosition, {Key? key}) : super(key: key);
  final Function onSelectPosition;
  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;

  void showPreview(double lat, double lng) {
    final staticMapImageUrl = LocationUtil.generateLocationPreviewImage(
      latitude: lat,
      longitude: lng,
    );

    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  Future<void> _getCurrentUserLocation() async {
    final LocationData locData = await Location().getLocation();
    showPreview(locData.latitude!, locData.longitude!);
  }

  Future<void> _selectOnMap() async {
    LatLng? selectedPosition = await Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => MapScreen()),
    );

    if (selectedPosition == null) return;

    widget.onSelectPosition(selectedPosition);
    showPreview(selectedPosition.latitude, selectedPosition.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _previewImageUrl == null
              ? Text('Localizaçao não informada')
              : Image.network(
                  _previewImageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: _getCurrentUserLocation,
              icon: Icon(Icons.location_on),
              label: Text(
                'Localização Atual',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              icon: Icon(Icons.map),
              label: Text(
                'Selecione no mapa',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
