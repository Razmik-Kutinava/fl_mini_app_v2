import 'package:flutter/material.dart';
import '../models/modifier.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class SizeSelector extends StatelessWidget {
  final List<ModifierOption> sizes;
  final ModifierOption? selected;
  final Function(ModifierOption) onSelect;

  const SizeSelector({
    super.key,
    required this.sizes,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Размер *',
          style: AppTextStyles.h3,
        ),
        const SizedBox(height: 12),
        Row(
          children: sizes.map((size) {
            final isSelected = selected?.label == size.label;
            return Expanded(
              child: GestureDetector(
                onTap: () => onSelect(size),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? AppColors.primary : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: isSelected
                        ? AppColors.primary.withOpacity(0.1)
                        : Colors.transparent,
                  ),
                  child: Column(
                    children: [
                      Text(
                        size.label,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? AppColors.primary : AppColors.textPrimary,
                        ),
                      ),
                      if (size.volume != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          size.volume!,
                          style: AppTextStyles.body.copyWith(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                      if (size.price > 0) ...[
                        const SizedBox(height: 4),
                        Text(
                          '+${size.price.toInt()}₽',
                          style: AppTextStyles.body.copyWith(
                            fontSize: 12,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class MilkSelector extends StatelessWidget {
  final List<ModifierOption> milks;
  final ModifierOption? selected;
  final Function(ModifierOption) onSelect;

  const MilkSelector({
    super.key,
    required this.milks,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Молоко',
          style: AppTextStyles.h3,
        ),
        const SizedBox(height: 12),
                        ...milks.map((milk) {
          return RadioListTile<ModifierOption>(
            title: Text(milk.label),
            subtitle: milk.price > 0
                ? Text('+${milk.price.toInt()}₽')
                : null,
            value: milk,
            groupValue: selected,
            onChanged: (value) {
              if (value != null) onSelect(value);
            },
            activeColor: AppColors.primary,
          );
        }).toList(),
      ],
    );
  }
}

class ExtrasSelector extends StatelessWidget {
  final List<ModifierOption> extras;
  final List<ModifierOption> selected;
  final Function(ModifierOption, bool) onToggle;

  const ExtrasSelector({
    super.key,
    required this.extras,
    required this.selected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Дополнительно',
          style: AppTextStyles.h3,
        ),
        const SizedBox(height: 12),
        ...extras.map((extra) {
          final isSelected = selected.any((e) => e.label == extra.label);
          return CheckboxListTile(
            title: Text(extra.label),
            subtitle: Text('+${extra.price.toInt()}₽'),
            value: isSelected,
            onChanged: (checked) => onToggle(extra, checked ?? false),
            activeColor: AppColors.primary,
          );
        }).toList(),
      ],
    );
  }
}
