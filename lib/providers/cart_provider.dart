import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get total => _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  void addItem(CartItem item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      if (quantity > 0) {
        final oldItem = _items[index];
        final newItem = CartItem(
          product: oldItem.product,
          selectedModifiers: oldItem.selectedModifiers,
          quantity: quantity,
          totalPrice: 0,
        );
        // Пересчитываем цену
        final calculatedPrice = newItem.calculatePrice();
        _items[index] = CartItem(
          product: newItem.product,
          selectedModifiers: newItem.selectedModifiers,
          quantity: newItem.quantity,
          totalPrice: calculatedPrice,
        );
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  CartItem? findItem(String productId) {
    try {
      return _items.firstWhere((item) => item.product.id == productId);
    } catch (e) {
      return null;
    }
  }
}
