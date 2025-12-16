import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductsProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Product> _products = [];
  List<ProductCategory> _categories = [];
  String? _selectedCategoryId;
  bool _isLoading = false;

  List<Product> get products {
    if (_selectedCategoryId == null) {
      return _products;
    }
    return _products.where((p) => p.categoryId == _selectedCategoryId).toList();
  }

  List<ProductCategory> get categories => _categories;
  String? get selectedCategoryId => _selectedCategoryId;
  bool get isLoading => _isLoading;

  Future<void> loadMenu(String locationId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.get('/api/locations/$locationId/menu');
      
      if (response['categories'] != null) {
        _categories = (response['categories'] as List<dynamic>)
            .map((json) => ProductCategory.fromJson(json))
            .toList();
      }

      if (response['products'] != null) {
        _products = (response['products'] as List<dynamic>)
            .map((json) => Product.fromJson(json))
            .toList();
      }
    } catch (e) {
      debugPrint('Error loading menu: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectCategory(String? categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  Product? getProductById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
}
