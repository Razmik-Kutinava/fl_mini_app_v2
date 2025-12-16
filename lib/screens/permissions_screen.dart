import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../providers/location_provider.dart';
import '../services/location_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import 'notifications_screen.dart';
import 'location_select_screen.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  final LocationService _locationService = LocationService();
  bool _isLoading = false;

  Future<void> _requestLocationPermission() async {
    setState(() => _isLoading = true);

    try {
      final status = await Permission.location.request();
      
      if (!mounted) return;

      if (status.isGranted) {
        final position = await _locationService.getCurrentPosition();
        if (!mounted) return;
        
        if (position != null) {
          final locationProvider = Provider.of<LocationProvider>(context, listen: false);
          locationProvider.setUserPosition(position);
          
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationsScreen()),
            );
          }
        } else {
          if (mounted) {
            _showError('Не удалось получить ваше местоположение');
          }
        }
      } else {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LocationSelectScreen()),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        _showError('Ошибка при запросе разрешения: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _selectManually() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LocationSelectScreen()),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667EEA),
              Color(0xFF764BA2),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.location_on,
                  size: 100,
                  color: Colors.white,
                ),
                const SizedBox(height: 32),
                Text(
                  'Разрешите доступ к геолокации',
                  style: AppTextStyles.h1.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Чтобы показать ближайшие кофейни',
                  style: AppTextStyles.body.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _requestLocationPermission,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            'Разрешить',
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _isLoading ? null : _selectManually,
                  child: Text(
                    'Выбрать вручную',
                    style: AppTextStyles.body.copyWith(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
