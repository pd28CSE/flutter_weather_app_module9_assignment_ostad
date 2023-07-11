class Geocoding {
  final String cityName;
  final double latitude;
  final double longitude;

  Geocoding({
    required this.cityName,
    required this.latitude,
    required this.longitude,
  });

  factory Geocoding.fromJson(Map<String, dynamic> json) {
    return Geocoding(
      cityName: json['local_names']['en'],
      latitude: json['lat'],
      longitude: json['lon'],
    );
  }
}
