class CareCenter {
  final String id;
  final String name;
  final String? address;
  final String? phone;
  final double lat;
  final double lng;
  final double distanceMeters;

  const CareCenter({
    required this.id,
    required this.name,
    this.address,
    this.phone,
    required this.lat,
    required this.lng,
    required this.distanceMeters,
  });

  String get distanceLabel {
    if (distanceMeters < 1000) {
      return '${distanceMeters.round()} m';
    }
    return '${(distanceMeters / 1000).toStringAsFixed(1)} km';
  }
}