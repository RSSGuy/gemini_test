import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapWidget extends StatefulWidget {
  final LatLng initialCenter; final Set<Marker> markers;
  const GoogleMapWidget({super.key, required this.initialCenter, this.markers = const {},});
  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}
class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  late GoogleMapController _mapController;
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: (controller) => _mapController = controller,
      initialCameraPosition: CameraPosition(target: widget.initialCenter, zoom: 12.0,),
      markers: widget.markers, zoomControlsEnabled: true, mapType: MapType.normal,
    );
  }
}