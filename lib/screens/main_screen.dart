import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/location_provider.dart';
import '../providers/products_provider.dart';
import '../providers/cart_provider.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import '../widgets/category_chip.dart';
import '../widgets/cart_button_fab.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import 'product_detail_screen.dart';
import 'cart_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    _loadMenu();
  }

  Future<void> _loadMenu() async {
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    final productsProvider = Provider.of<ProductsProvider>(context, listen: false);
    
    if (locationProvider.selectedLocation != null) {
      await productsProvider.loadMenu(locationProvider.selectedLocation!.id);
    }
  }

  void _showProductDetail(Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProductDetailScreen(product: product),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<LocationProvider>(
          builder: (context, locationProvider, child) {
            return Row(
              children: [
                const Icon(Icons.local_cafe),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    locationProvider.selectedLocation?.name ?? 'Кофейня',
                    style: AppTextStyles.h3.copyWith(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<ProductsProvider>(
        builder: (context, productsProvider, child) {
          if (productsProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // Промо-блок
              Container(
                height: 120,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF6B7A), Color(0xFFFFB347)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Icon(Icons.local_offer, color: Colors.white, size: 40),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'АКЦИЯ -20%',
                            style: AppTextStyles.h2.copyWith(color: Colors.white),
                          ),
                          Text(
                            'На весь заказ',
                            style: AppTextStyles.body.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Категории
              SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    CategoryChip(
                      label: 'Все',
                      isSelected: productsProvider.selectedCategoryId == null,
                      onTap: () => productsProvider.selectCategory(null),
                    ),
                    const SizedBox(width: 8),
                    ...productsProvider.categories.map((category) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: CategoryChip(
                          label: category.name,
                          isSelected: productsProvider.selectedCategoryId == category.id,
                          onTap: () => productsProvider.selectCategory(category.id),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Товары
              Expanded(
                child: productsProvider.products.isEmpty
                    ? Center(
                        child: Text(
                          'Товары не найдены',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(8),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: productsProvider.products.length,
                        itemBuilder: (context, index) {
                          final product = productsProvider.products[index];
                          return ProductCard(
                            product: product,
                            onTap: () => _showProductDetail(product),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return CartButtonFab(
            total: cartProvider.total,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
            },
          );
        },
      ),
    );
  }
}
