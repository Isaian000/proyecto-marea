//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'care_center.dart';
import 'care_centers_provider.dart';
//import 'dev_tools/firestore_batch_importer.dart';
//import 'dev_tools/jalisco_centers_catalog.dart';
//import 'dev_tools/regional_centers_catalog.dart';

class CareCentersMapPage extends StatelessWidget {
  const CareCentersMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CareCentersProvider()..load(),
      child: const _CareCentersMapView(),
    );
  }
}

class _CareCentersMapView extends StatefulWidget {
  const _CareCentersMapView();

  @override
  State<_CareCentersMapView> createState() => _CareCentersMapViewState();
}

class _CareCentersMapViewState extends State<_CareCentersMapView> {
  final MapController _mapController = MapController();

  void _focusCenter(CareCentersProvider provider, CareCenter center) {
    provider.selectCenter(center);
    _mapController.move(LatLng(center.lat, center.lng), 15);
  }

  Future<void> _openDirections(CareCenter center) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&destination=${center.lat},${center.lng}&travelmode=driving',
    );
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _callCenter(CareCenter center) async {
    if (center.phone == null) return;
    final cleanPhone = center.phone!.replaceAll(RegExp(r'[^\d+]'), '');
    if (cleanPhone.isEmpty) return;
    await launchUrl(Uri.parse('tel:$cleanPhone'));
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CareCentersProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Centros psicológicos cercanos'),
        /*actions: [ 
          if (kDebugMode)
            IconButton(
              tooltip: 'Importar centros a Firestore',
              icon: const Icon(Icons.cloud_upload),
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                try {
                  final count = await importCareCenters(
                    FirebaseFirestore.instance,
                    items: [
                      ...kJaliscoCareCenters,
                      ...kRegionalNeighborCareCenters,
                    ],
                  );
                  if (!mounted) return;
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text('Se importaron $count centros a Firestore.'),
                    ),
                  );
                  await provider.load();
                } catch (e) {
                  if (!mounted) return;
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text('Error al importar: $e'),
                    ),
                  );
                }
              },
            ),
          IconButton(
            tooltip: 'Actualizar ubicación',
            icon: const Icon(Icons.my_location),
            onPressed: provider.load,
          ), 
        ],*/
      ),
      body: switch (provider.status) {
        CareCentersStatus.loading => const Center(
            child: CircularProgressIndicator(),
          ),
        CareCentersStatus.serviceDisabled => _LocationPrompt(
            icon: Icons.location_off,
            message: 'Activa el GPS de tu dispositivo para ubicar centros '
                'cercanos a ti.',
            buttonText: 'Activar ubicación',
            onPressed: provider.locationService.openLocationSettings,
            onRetry: provider.load,
          ),
        CareCentersStatus.denied => _LocationPrompt(
            icon: Icons.location_disabled,
            message: 'Necesitamos tu ubicación actual para mostrar los centros '
                'más cercanos en el mapa.',
            buttonText: 'Permitir ubicación',
            onPressed: provider.load,
          ),
        CareCentersStatus.deniedForever => _LocationPrompt(
            icon: Icons.settings,
            message: 'El permiso de ubicación está bloqueado en ajustes. '
                'Habilítalo para continuar.',
            buttonText: 'Abrir ajustes de la app',
            onPressed: provider.locationService.openAppSettings,
            onRetry: provider.load,
          ),
        CareCentersStatus.error => _LocationPrompt(
            icon: Icons.error_outline,
            message: 'No fue posible consultar los centros. Revisa tu '
                'conexión o permisos de Firestore e inténtalo de nuevo.',
            buttonText: 'Reintentar',
            onPressed: provider.load,
          ),
        CareCentersStatus.ready => _buildMapAndList(provider),
      },
    );
  }

  Widget _buildMapAndList(CareCentersProvider provider) {
    final pos = provider.position;
    if (pos == null) {
      return const Center(
        child: Text('No fue posible obtener tu ubicación actual.'),
      );
    }

    final userLatLng = LatLng(pos.latitude, pos.longitude);

    return Column(
      children: [
        Expanded(
          flex: 5,
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: userLatLng,
              initialZoom: 13,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.flutter_proyecto__marea',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: userLatLng,
                    width: 28,
                    height: 28,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: const [
                          BoxShadow(blurRadius: 6, color: Colors.black26),
                        ],
                      ),
                    ),
                  ),
                  for (final center in provider.centers)
                    Marker(
                      point: LatLng(center.lat, center.lng),
                      width: 42,
                      height: 42,
                      child: GestureDetector(
                        onTap: () => provider.selectCenter(center),
                        child: Icon(
                          Icons.location_on,
                          size: 42,
                          color: provider.selected?.id == center.id
                              ? Colors.red
                              : Colors.deepPurple,
                        ),
                      ),
                    ),
                ],
              ),
              RichAttributionWidget(
                attributions: [
                  TextSourceAttribution('© colaboradores de OpenStreetMap'),
                ],
              ),
            ],
          ),
        ),
        if (provider.selected != null)
          _CenterInfoCard(
            center: provider.selected!,
            onCall: () => _callCenter(provider.selected!),
            onRoute: () => _openDirections(provider.selected!),
            onClose: () => provider.selectCenter(null),
          ),
        Expanded(
          flex: 4,
          child: provider.centers.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'No se encontraron centros psicológicos en el radio '
                      'consultado.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : ListView.separated(
                  itemCount: provider.centers.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, index) {
                    final center = provider.centers[index];
                    final isSelected = provider.selected?.id == center.id;
                    return ListTile(
                      selected: isSelected,
                      leading: const Icon(Icons.psychology),
                      title: Text(center.name),
                      subtitle: Text(
                        '${center.address ?? 'Dirección no disponible'}'
                        '${center.phone != null ? ' • ${center.phone}' : ''}',
                      ),
                      trailing: Text(center.distanceLabel),
                      onTap: () => _focusCenter(provider, center),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _CenterInfoCard extends StatelessWidget {
  final CareCenter center;
  final VoidCallback onCall;
  final VoidCallback onRoute;
  final VoidCallback onClose;

  const _CenterInfoCard({
    required this.center,
    required this.onCall,
    required this.onRoute,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    center.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onClose,
                ),
              ],
            ),
            if (center.address != null) Text(center.address!),
            Text('Distancia: ${center.distanceLabel}'),
            Text('Teléfono: ${center.phone ?? 'No disponible'}'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: center.phone == null ? null : onCall,
                  icon: const Icon(Icons.call),
                  label: const Text('Llamar'),
                ),
                OutlinedButton.icon(
                  onPressed: onRoute,
                  icon: const Icon(Icons.directions),
                  label: const Text('Cómo llegar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LocationPrompt extends StatelessWidget {
  final IconData icon;
  final String message;
  final String buttonText;
  final VoidCallback onPressed;
  final VoidCallback? onRetry;

  const _LocationPrompt({
    required this.icon,
    required this.message,
    required this.buttonText,
    required this.onPressed,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 54),
            const SizedBox(height: 14),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onPressed,
              child: Text(buttonText),
            ),
            if (onRetry != null)
              TextButton(
                onPressed: onRetry,
                child: const Text('Reintentar'),
              ),
          ],
        ),
      ),
    );
  }
}