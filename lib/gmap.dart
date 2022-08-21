import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    this.isSelecting = false,
  });

  final bool isSelecting;

  @override
  State<MapScreen> createState() => _MapScreenState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('isSelecting', isSelecting));
  }
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;
  void _selectLocation(LatLng position) =>
      setState(() => _pickedLocation = position);

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: GoogleMap(
        initialCameraPosition:
            const CameraPosition(target: LatLng(37.422, -122.084), zoom: 16),
        onTap: widget.isSelecting ? _selectLocation : null,
        markers: {
          Marker(
            markerId: const MarkerId('m1'),
            position: _pickedLocation ??
                LatLng(_pickedLocation!.latitude, _pickedLocation!.longitude),
          )
        },
      ));
}
