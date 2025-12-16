import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../models/modifier.dart';
import '../providers/cart_provider.dart';
import '../widgets/modifier_selector.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  ModifierSelection _selectedModifiers = ModifierSelection();
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _initializeModifiers();
  }

  void _initializeModifiers() {
    final modifiers = widget.product.modifiers;
    if (modifiers != null) {
      if (modifiers.size != null && modifiers.size!.options.isNotEmpty) {
        _selectedModifiers = _selectedModifiers.copyWith(
          size: modifiers.size!.options.first,
        );
      }
      if (modifiers.milk != null && modifiers.milk!.options.isNotEmpty) {
        _selectedModifiers = _selectedModifiers.copyWith(
          milk: modifiers.milk!.options.first,
        );
      }
    }
  }

  double _calculateTotalPrice() {
    double basePrice = widget.product.price;
    double sizePrice = _selectedModifiers.size?.price ?? 0;
    double milkPrice = _selectedModifiers.milk?.price ?? 0;
    double extrasPrice = _selectedModifiers.extras.fold<double>(
      0,
      (sum, extra) => sum + extra.price,
    );
    return (basePrice + sizePrice + milkPrice + extrasPrice) * _quantity;
  }

  void _addToCart() {
    // Проверка обязательных модификаторов
    if (widget.product.modifiers?.size?.required == true &&
        _selectedModifiers.size == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пожалуйста, выберите размер')),
      );
      return;
    }

    final cartItem = CartItem(
      product: widget.product,
      selectedModifiers: _selectedModifiers,
      quantity: _quantity,
      totalPrice: _calculateTotalPrice(),
    );

    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.addItem(cartItem);

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Добавлено в корзину')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.product.name,
                        style: AppTextStyles.h2,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Фото
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: widget.product.imageUrl != null
                            ? CachedNetworkImage(
                                imageUrl: widget.product.imageUrl!,
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  height: 200,
                                  color: AppColors.background,
                                  child: const Icon(Icons.image_not_supported),
                                ),
                              )
                            : Container(
                                height: 200,
                                color: AppColors.background,
                                child: const Icon(Icons.image, size: 64),
                              ),
                      ),
                      const SizedBox(height: 16),
                      // Описание
                      Text(
                        widget.product.description,
                        style: AppTextStyles.body,
                      ),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 24),
                      // Размер
                      if (widget.product.modifiers?.size != null)
                        SizeSelector(
                          sizes: widget.product.modifiers!.size!.options,
                          selected: _selectedModifiers.size,
                          onSelect: (size) {
                            setState(() {
                              _selectedModifiers = _selectedModifiers.copyWith(size: size);
                            });
                          },
                        ),
                      if (widget.product.modifiers?.size != null)
                        const SizedBox(height: 24),
                      // Молоко
                      if (widget.product.modifiers?.milk != null)
                        MilkSelector(
                          milks: widget.product.modifiers!.milk!.options,
                          selected: _selectedModifiers.milk,
                          onSelect: (milk) {
                            setState(() {
                              _selectedModifiers = _selectedModifiers.copyWith(milk: milk);
                            });
                          },
                        ),
                      if (widget.product.modifiers?.milk != null)
                        const SizedBox(height: 24),
                      // Дополнительно
                      if (widget.product.modifiers?.extras != null)
                        ExtrasSelector(
                          extras: widget.product.modifiers!.extras!.options,
                          selected: _selectedModifiers.extras,
                          onToggle: (extra, isSelected) {
                            setState(() {
                              final extras = List<ModifierOption>.from(_selectedModifiers.extras);
                              if (isSelected) {
                                extras.add(extra);
                              } else {
                                extras.removeWhere((e) => e.label == extra.label);
                              }
                              _selectedModifiers = _selectedModifiers.copyWith(extras: extras);
                            });
                          },
                        ),
                      if (widget.product.modifiers?.extras != null)
                        const SizedBox(height: 24),
                      // Количество
                      Row(
                        children: [
                          Text(
                            'Количество:',
                            style: AppTextStyles.h3,
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () {
                                  if (_quantity > 1) {
                                    setState(() => _quantity--);
                                  }
                                },
                              ),
                              Text(
                                '$_quantity',
                                style: AppTextStyles.h3,
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () {
                                  setState(() => _quantity++);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Кнопка добавить
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _addToCart,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.shopping_cart),
                              const SizedBox(width: 8),
                              Text(
                                'Добавить в корзину ${_calculateTotalPrice().toInt()}₽',
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
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
