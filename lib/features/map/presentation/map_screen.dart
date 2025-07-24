
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../l10n/app_localizations.dart';
import 'google_map_widget.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const montrealLatLng = LatLng(45.5017, -73.5673);
    final markers = {Marker(markerId: const MarkerId('montreal_marker'), position: montrealLatLng, infoWindow: InfoWindow(title: 'Montreal, QC', snippet: l10n.mapMarkerSnippet,),),};
    return Padding(padding: const EdgeInsets.all(24.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(l10n.mapExplorer, style: Theme.of(context).textTheme.displayLarge), const SizedBox(height: 16),
      Text(l10n.mapDescription, style: Theme.of(context).textTheme.bodyMedium,), const SizedBox(height: 16),
      ElevatedButton.icon(
        icon: const Icon(Icons.timeline),
        label: const Text('Manage Map Routes'),
        onPressed: () {
          context.go('/map-routes');
        },
      ),
      const SizedBox(height: 16),
      Expanded(child: Card(clipBehavior: Clip.antiAlias, child: GoogleMapWidget(initialCenter: montrealLatLng, markers: markers,),),),
    ],),);


  }
}