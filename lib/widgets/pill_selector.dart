import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_constants.dart';
import '../theme/app_colors.dart';

class PillSelector<T> extends ConsumerWidget {
  final List<T> items;
  final T selected;
  final String Function(T) label;
  final void Function(T) onSelected;

  const PillSelector({
    super.key,
    required this.items,
    required this.selected,
    required this.label,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 12,
      children: items.map((item) {
        final isSelected = item == selected;
        return GestureDetector(
          onTap: () => onSelected(item),
          child: AnimatedContainer(
            duration: AppConstants.animationDuration,
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color:
                  isSelected ? AppColors.primary : Colors.transparent,
              borderRadius:
                  BorderRadius.circular(AppConstants.pillRadius),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : Colors.grey.shade300,
              ),
            ),
            child: Text(
              label(item),
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color:
                    isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}