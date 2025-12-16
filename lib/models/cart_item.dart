import 'product.dart';
import 'modifier.dart';

class CartItem {
  final Product product;
  final ModifierSelection selectedModifiers;
  int quantity;
  final double totalPrice;

  CartItem({
    required this.product,
    required this.selectedModifiers,
    required this.quantity,
    required this.totalPrice,
  });

  double calculatePrice() {
    double basePrice = product.price;
    double sizePrice = selectedModifiers.size != null ? selectedModifiers.size!.price : 0;
    double milkPrice = selectedModifiers.milk != null ? selectedModifiers.milk!.price : 0;
    double extrasPrice = selectedModifiers.extras.fold<double>(
      0,
      (sum, extra) => sum + extra.price,
    );
    return (basePrice + sizePrice + milkPrice + extrasPrice) * quantity;
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': product.id,
      'quantity': quantity,
      'modifiers': {
        'size': selectedModifiers.size?.toJson(),
        'milk': selectedModifiers.milk?.toJson(),
        'extras': selectedModifiers.extras.map((e) => e.toJson()).toList(),
      },
    };
  }
}

class ModifierSelection {
  final ModifierOption? size;
  final ModifierOption? milk;
  final List<ModifierOption> extras;

  ModifierSelection({
    this.size,
    this.milk,
    List<ModifierOption>? extras,
  }) : extras = extras ?? [];

  ModifierSelection copyWith({
    ModifierOption? size,
    ModifierOption? milk,
    List<ModifierOption>? extras,
  }) {
    return ModifierSelection(
      size: size ?? this.size,
      milk: milk ?? this.milk,
      extras: extras ?? this.extras,
    );
  }
}
