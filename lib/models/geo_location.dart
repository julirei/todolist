class GeoLocation {
  const GeoLocation({
    required this.latitude,
    required this.longitude,
  });

  /// Latitude in degrees.
  final double latitude;

  /// Latitude in degrees.
  final double longitude;

  @override
  String toString() =>
      'GeoLocation(${latitude.toStringAsFixed(2)}, ${longitude.toStringAsFixed(2)})';
}
