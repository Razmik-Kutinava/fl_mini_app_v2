import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../models/location.dart';
import '../services/api_service.dart';
import '../services/location_service.dart';

class LocationProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final LocationService _locationService = LocationService();

  Location? _selectedLocation;
  List<Location> _locations = [];
  Position? _userPosition;
  bool _isLoading = false;

  Location? get selectedLocation => _selectedLocation;
  List<Location> get locations => _locations;
  Position? get userPosition => _userPosition;
  bool get isLoading => _isLoading;

  Future<void> loadLocations() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.get('/api/locations');
      final List<dynamic> data = response is List ? response : response['locations'] as List;
      
      final locations = data.map((json) => Location.fromJson(json)).toList();

      // Рассчитать расстояние если есть геолокация
      if (_userPosition != null) {
        _locations = locations.map((location) {
          final distance = _locationService.calculateDistance(
            _userPosition!.latitude,
            _userPosition!.longitude,
            location.lat,
            location.lng,
          );
          return Location(
            id: location.id,
            name: location.name,
            address: location.address,
            lat: location.lat,
            lng: location.lng,
            isActive: location.isActive,
            distance: distance,
            rating: location.rating,
            isOpen: location.isOpen,
          );
        }).toList();
        
        _locations.sort((a, b) {
          final distA = a.distance ?? double.infinity;
          final distB = b.distance ?? double.infinity;
          return distA.compareTo(distB);
        });
      } else {
        _locations = locations;
      }
    } catch (e) {
      debugPrint('Error loading locations: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectLocation(Location location) {
    _selectedLocation = location;
    notifyListeners();
  }

  void setUserPosition(Position position) {
    _userPosition = position;
    notifyListeners();
  }
}
