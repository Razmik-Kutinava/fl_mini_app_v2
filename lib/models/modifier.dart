class ModifierGroups {
  final SizeModifiers? size;
  final MilkModifiers? milk;
  final ExtraModifiers? extras;

  ModifierGroups({
    this.size,
    this.milk,
    this.extras,
  });

  factory ModifierGroups.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ModifierGroups();
    return ModifierGroups(
      size: json['size'] != null ? SizeModifiers.fromJson(json['size']) : null,
      milk: json['milk'] != null ? MilkModifiers.fromJson(json['milk']) : null,
      extras: json['extras'] != null ? ExtraModifiers.fromJson(json['extras']) : null,
    );
  }
}

class SizeModifiers {
  final bool required;
  final List<ModifierOption> options;

  SizeModifiers({
    required this.required,
    required this.options,
  });

  factory SizeModifiers.fromJson(Map<String, dynamic> json) {
    return SizeModifiers(
      required: json['required'] as bool? ?? false,
      options: (json['options'] as List<dynamic>)
          .map((item) => ModifierOption.fromJson(item))
          .toList(),
    );
  }
}

class MilkModifiers {
  final bool required;
  final List<ModifierOption> options;

  MilkModifiers({
    required this.required,
    required this.options,
  });

  factory MilkModifiers.fromJson(Map<String, dynamic> json) {
    return MilkModifiers(
      required: json['required'] as bool? ?? false,
      options: (json['options'] as List<dynamic>)
          .map((item) => ModifierOption.fromJson(item))
          .toList(),
    );
  }
}

class ExtraModifiers {
  final bool required;
  final List<ModifierOption> options;

  ExtraModifiers({
    required this.required,
    required this.options,
  });

  factory ExtraModifiers.fromJson(Map<String, dynamic> json) {
    return ExtraModifiers(
      required: json['required'] as bool? ?? false,
      options: (json['options'] as List<dynamic>)
          .map((item) => ModifierOption.fromJson(item))
          .toList(),
    );
  }
}

class ModifierOption {
  final String label;
  final String? volume;
  final double price;

  ModifierOption({
    required this.label,
    this.volume,
    required this.price,
  });

  factory ModifierOption.fromJson(Map<String, dynamic> json) {
    return ModifierOption(
      label: json['label'] as String,
      volume: json['volume'] as String?,
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'volume': volume,
      'price': price,
    };
  }
}
