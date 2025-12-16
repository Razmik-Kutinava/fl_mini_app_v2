import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../providers/location_provider.dart';
import '../models/location.dart';
import '../widgets/location_card.dart';
import '../utils/app_colors.dart';
import 'main_screen.dart';

class LocationSelectScreen extends StatefulWidget {
  const LocationSelectScreen({super.key});

  @override
  State<LocationSelectScreen> createState() => _LocationSelectScreenState();
}

class _LocationSelectScreenState extends State<LocationSelectScreen> {
  final MapController _mapController = MapController();
  LatLng? _center;

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  Future<void> _loadLocations() async {
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    await locationProvider.loadLocations();

    if (locationProvider.userPosition != null) {
      setState(() {
        _center = LatLng(
          locationProvider.userPosition!.latitude,
          locationProvider.userPosition!.longitude,
        );
      });
    } else if (locationProvider.locations.isNotEmpty) {
      final firstLocation = locationProvider.locations.first;
      setState(() {
        _center = LatLng(firstLocation.lat, firstLocation.lng);
      });
    } else {
      // Москва по умолчанию
      setState(() {
        _center = const LatLng(55.7558, 37.6173);
      });
    }
  }

  void _selectLocation(Location location) {
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    locationProvider.selectLocation(location);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Выберите кофейню'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Consumer<LocationProvider>(
        builder: (context, locationProvider, child) {
          if (locationProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // Карта
              SizedBox(
                height: 300,
                child: _center != null
                    ? FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: _center!,
                          initialZoom: 13.0,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.coffee_app',
                          ),
                          MarkerLayer(
                            markers: locationProvider.locations.map((location) {
                              return Marker(
                                point: LatLng(location.lat, location.lng),
                                width: 40,
                                height: 40,
                                child: GestureDetector(
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(location.name)),
                                    );
                                  },
                                  child: const Icon(
                                    Icons.location_on,
                                    color: AppColors.primary,
                                    size: 40,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
              // Список кофеен
              Expanded(
                child: ListView.builder(
                  itemCount: locationProvider.locations.length,
                  itemBuilder: (context, index) {
                    final location = locationProvider.locations[index];
                    return LocationCard(
                      location: location,
                      onTap: () => _selectLocation(location),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
