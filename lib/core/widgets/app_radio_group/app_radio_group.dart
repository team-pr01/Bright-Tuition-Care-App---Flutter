import 'package:flutter/material.dart';
import '../../config/theme.dart';

class AppRadioOption<T> {
  final T value;
  final String label;

  const AppRadioOption({
    required this.value,
    required this.label,
  });
}

class AppRadioGroup<T> extends StatelessWidget {
  final T? selectedValue;
  final List<AppRadioOption<T>> options;
  final ValueChanged<T> onChanged;
  final double spacing;
  final double radioToTextSpacing;

  const AppRadioGroup({
    super.key,
    required this.selectedValue,
    required this.options,
    required this.onChanged,
    this.spacing = 20,
    this.radioToTextSpacing = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: 8,
      children: options.map((option) {
        final isSelected = selectedValue == option.value;

        return InkWell(
          onTap: () => onChanged(option.value),
          borderRadius: BorderRadius.circular(24),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Radio<T>(
                value: option.value,
                groupValue: selectedValue,
                onChanged: (value) {
                  if (value != null) {
                    onChanged(value);
                  }
                },

                activeColor: AppColors.primary01,

                fillColor: WidgetStateProperty.resolveWith<Color?>(
                  (states) {
                    if (states.contains(WidgetState.selected)) {
                      return AppColors.primary01;
                    }

                    return AppColors.neutrals03;
                  },
                ),

                materialTapTargetSize:
                    MaterialTapTargetSize.shrinkWrap,

                visualDensity: const VisualDensity(
                  horizontal: -4,
                  vertical: -4,
                ),
              ),

              SizedBox(width: radioToTextSpacing),

              Text(
                option.label,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(
                      color: isSelected
                          ? AppColors.primary01
                          : AppColors.neutrals02,
                      fontWeight: FontWeight.w400,
                    ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}