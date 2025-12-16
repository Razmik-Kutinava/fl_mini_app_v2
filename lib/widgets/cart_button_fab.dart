import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class CartButtonFab extends StatelessWidget {
  final double total;
  final VoidCallback onTap;

  const CartButtonFab({
    super.key,
    required this.total,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (total == 0) {
      return const SizedBox.shrink();
    }

    return FloatingActionButton.extended(
      onPressed: onTap,
      backgroundColor: AppColors.primary,
      icon: const Icon(Icons.shopping_cart, color: Colors.white),
      label: Text(
        '${total.toInt()} ₽',
        style: AppTextStyles.body.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
