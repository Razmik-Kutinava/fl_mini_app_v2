import 'package:http/http.dart' as http;
import 'dart:convert';
import 'mock_data_service.dart';

class ApiService {
  static const String baseUrl = 'https://api.coffee.com/v1';
  static const bool useMockData = true; // Переключите на false для использования реального API

  Future<dynamic> get(String endpoint) async {
    // Используем mock данные для тестирования
    if (useMockData) {
      await MockDataService.delay();
      
      if (endpoint == '/api/locations') {
        return MockDataService.getMockLocations();
      }
      
      if (endpoint.contains('/api/locations/') && endpoint.contains('/menu')) {
        return {
          'categories': MockDataService.getMockCategories(),
          'products': MockDataService.getMockProducts(),
        };
      }
    }

    // Реальный API запрос
    try {
      final response = await http.get(Uri.parse('$baseUrl$endpoint'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    // Используем mock данные для тестирования
    if (useMockData) {
      await MockDataService.delay();
      
      if (endpoint == '/api/promo-codes/validate') {
        final code = body['code'] as String? ?? '';
        return MockDataService.validatePromoCode(code);
      }
      
      if (endpoint == '/api/orders') {
        // Имитация успешного создания заказа
        return {
          'orderId': 'ORDER_${DateTime.now().millisecondsSinceEpoch}',
          'status': 'pending',
          'paymentUrl': null,
        };
      }
    }

    // Реальный API запрос
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
