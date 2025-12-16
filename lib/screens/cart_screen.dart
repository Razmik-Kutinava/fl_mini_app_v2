import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/location_provider.dart';
import '../models/cart_item.dart';
import '../services/api_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _promoCodeController = TextEditingController();
  final ApiService _apiService = ApiService();
  String? _promoCode;
  double _discount = 0;
  bool _isValidatingPromo = false;
  bool _isPlacingOrder = false;

  @override
  void dispose() {
    _promoCodeController.dispose();
    super.dispose();
  }

  Future<void> _validatePromoCode() async {
    final code = _promoCodeController.text.trim();
    if (code.isEmpty) return;

    setState(() => _isValidatingPromo = true);

    try {
      final response = await _apiService.post('/api/promo-codes/validate', {
        'code': code,
      });

      if (!mounted) return;

      if (response['valid'] == true) {
        setState(() {
          _promoCode = code;
          _discount = (response['discount'] as num).toDouble();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Промокод применен')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Неверный промокод')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при проверке промокода: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isValidatingPromo = false);
      }
    }
  }

  Future<void> _placeOrder() async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);

    if (cartProvider.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Корзина пуста')),
      );
      return;
    }

    if (locationProvider.selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выберите кофейню')),
      );
      return;
    }

    setState(() => _isPlacingOrder = true);

    try {
      final total = cartProvider.total - _discount;
      final response = await _apiService.post('/api/orders', {
        'locationId': locationProvider.selectedLocation!.id,
        'items': cartProvider.items.map((item) => item.toJson()).toList(),
        'promoCode': _promoCode,
        'total': total,
      });

      if (!mounted) return;

      if (response['orderId'] != null) {
        cartProvider.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Заказ оформлен!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при оформлении заказа: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isPlacingOrder = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Корзина'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart_outlined, size: 64, color: AppColors.textSecondary),
                  const SizedBox(height: 16),
                  Text(
                    'Корзина пуста',
                    style: AppTextStyles.h2.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Вернуться к меню'),
                  ),
                ],
              ),
            );
          }

          final total = cartProvider.total - _discount;
          final itemCount = cartProvider.itemCount;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cartProvider.items.length,
                  itemBuilder: (context, index) {
                    final item = cartProvider.items[index];
                    return _buildCartItemCard(item, cartProvider);
                  },
                ),
              ),
              // Промокод
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _promoCodeController,
                            decoration: InputDecoration(
                              labelText: 'Промокод',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _isValidatingPromo ? null : _validatePromoCode,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          child: _isValidatingPromo
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text('Применить'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Итоги
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Товары ($itemCount шт)',
                              style: AppTextStyles.body,
                            ),
                            Text(
                              '${cartProvider.total.toInt()} ₽',
                              style: AppTextStyles.body,
                            ),
                          ],
                        ),
                        if (_discount > 0) ...[
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Скидка ($_promoCode)',
                                style: AppTextStyles.body.copyWith(
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                '-${_discount.toInt()} ₽',
                                style: AppTextStyles.body.copyWith(
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ],
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Итого:',
                              style: AppTextStyles.h2,
                            ),
                            Text(
                              '${total.toInt()} ₽',
                              style: AppTextStyles.price.copyWith(fontSize: 24),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isPlacingOrder ? null : _placeOrder,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isPlacingOrder
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.payment),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Оформить заказ ${total.toInt()}₽',
                                        style: AppTextStyles.body.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCartItemCard(CartItem item, CartProvider cartProvider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Фото
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: item.product.imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: item.product.imageUrl!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const SizedBox(
                        width: 60,
                        height: 60,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 60,
                        height: 60,
                        color: AppColors.background,
                        child: const Icon(Icons.image),
                      ),
                    )
                  : Container(
                      width: 60,
                      height: 60,
                      color: AppColors.background,
                      child: const Icon(Icons.image),
                    ),
            ),
            const SizedBox(width: 12),
            // Информация
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${item.product.name}${item.selectedModifiers.size != null ? ' ${item.selectedModifiers.size!.label}' : ''}',
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (item.selectedModifiers.milk != null)
                    Text(
                      '+ ${item.selectedModifiers.milk!.label}',
                      style: AppTextStyles.body.copyWith(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  if (item.selectedModifiers.extras.isNotEmpty) ...[
                    ...item.selectedModifiers.extras.map((extra) => Text(
                          '+ ${extra.label}',
                          style: AppTextStyles.body.copyWith(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        )),
                  ],
                  if (item.selectedModifiers.milk == null &&
                      item.selectedModifiers.extras.isEmpty)
                    Text(
                      'Без добавок',
                      style: AppTextStyles.body.copyWith(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            // Количество и цена
            Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        if (item.quantity > 1) {
                          cartProvider.updateQuantity(
                            item.product.id,
                            item.quantity - 1,
                          );
                        } else {
                          cartProvider.removeItem(item.product.id);
                        }
                      },
                    ),
                    Text(
                      '${item.quantity}',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () {
                        cartProvider.updateQuantity(
                          item.product.id,
                          item.quantity + 1,
                        );
                      },
                    ),
                  ],
                ),
                Text(
                  '${item.totalPrice.toInt()} ₽',
                  style: AppTextStyles.price,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
