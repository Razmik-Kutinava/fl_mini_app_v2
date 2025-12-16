class Location {
  final String id;
  final String name;
  final String address;
  final double lat;
  final double lng;
  final bool isActive;
  final double? distance; // рассчитывается клиентом
  final double? rating;
  final bool? isOpen;

  Location({
    required this.id,
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
    required this.isActive,
    this.distance,
    this.rating,
    this.isOpen,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      isActive: json['isActive'] as bool? ?? true,
      distance: json['distance'] != null ? (json['distance'] as num).toDouble() : null,
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      isOpen: json['isOpen'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'lat': lat,
      'lng': lng,
      'isActive': isActive,
      'distance': distance,
      'rating': rating,
      'isOpen': isOpen,
    };
  }
}
