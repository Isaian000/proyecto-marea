import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import 'care_center.dart';
import 'care_centers_service.dart';
import 'location_service.dart';

enum CareCentersStatus {
  loading,
  ready,
  serviceDisabled,
  denied,
  deniedForever,
  error,
}

class CareCentersProvider extends ChangeNotifier {
  CareCentersProvider({
    LocationService? locationService,
    CareCentersService? centersService,
  })  : _locationService = locationService ?? LocationService(),
        _centersService = centersService ?? CareCentersService();

  final LocationService _locationService;
  final CareCentersService _centersService;

  CareCentersStatus _status = CareCentersStatus.loading;
  Position? _position;
  List<CareCenter> _centers = const [];
  CareCenter? _selected;

  CareCentersStatus get status => _status;
  Position? get position => _position;
  List<CareCenter> get centers => _centers;
  CareCenter? get selected => _selected;
  LocationService get locationService => _locationService;

  Future<void> load() async {
    _status = CareCentersStatus.loading;
    notifyListeners();

    try {
      final pos = await _locationService.getCurrentPosition();
      final results = await _centersService.searchNearby(
        lat: pos.latitude,
        lng: pos.longitude,
        maxRadiusMeters: null,
      );

      _position = pos;
      _centers = results;
      _selected = results.isNotEmpty ? results.first : null;
      _status = CareCentersStatus.ready;
    } on LocationException catch (e) {
      _status = switch (e.failure) {
        LocationFailure.serviceDisabled => CareCentersStatus.serviceDisabled,
        LocationFailure.denied => CareCentersStatus.denied,
        LocationFailure.deniedForever => CareCentersStatus.deniedForever,
      };
    } catch (e) {
      debugPrint('Error en CareCentersProvider.load: $e');
      _status = CareCentersStatus.error;
    }

    notifyListeners();
  }

  void selectCenter(CareCenter? center) {
    _selected = center;
    notifyListeners();
  }
}