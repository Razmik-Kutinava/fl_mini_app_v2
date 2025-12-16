import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static const String _permissionKey = 'notification_permission_granted';

  Future<bool> requestPermission() async {
    final status = await Permission.notification.request();
    final granted = status.isGranted;
    
    if (granted) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_permissionKey, true);
    }
    
    return granted;
  }

  Future<bool> isPermissionGranted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_permissionKey) ?? false;
  }
}
