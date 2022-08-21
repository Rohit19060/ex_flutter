import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../gmap.dart';
import 'location_helper.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({
    super.key,
    required this.onSelectPlace,
  });
  final Function(double, double) onSelectPlace;

  @override
  State<LocationInput> createState() => _LocationInputState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<Function>('onSelectPlace', onSelectPlace));
  }
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl = '';

  void _showPreview(double lat, double lng) {
    final staticMapImageUrl =
        generateLocationPreviewImage(latitude: lat, longitude: lng);
    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      final location = await Location().getLocation();
      _showPreview(location.latitude ?? 0, location.longitude ?? 0);
      widget.onSelectPlace(location.latitude!, location.longitude!);
    } on Exception catch (error) {
      debugPrint(error.toString());
      return;
    }
  }

  Future<void> _selectOnMap() async {
    final selectedLocation = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => const MapScreen(isSelecting: true),
      ),
    );
    if (selectedLocation == null) {
      return;
    }
    _showPreview(selectedLocation.latitude as double,
        selectedLocation.longitude as double);
    widget.onSelectPlace(selectedLocation.latitude as double,
        selectedLocation.longitude as double);
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Container(
            height: 160,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
              ),
            ),
            child: _previewImageUrl.isEmpty
                ? const Center(child: Text('No image selected'))
                : Image.network(
                    _previewImageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.white,
                    ),
                    foregroundColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor),
                  ),
                  onPressed: _getCurrentLocation,
                  icon: const Icon(Icons.location_on),
                  label: const Text('Current')),
              ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.white,
                    ),
                    foregroundColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor),
                  ),
                  onPressed: _selectOnMap,
                  icon: const Icon(Icons.map_rounded),
                  label: const Text('Select on Map'))
            ],
          )
        ],
      );
}
