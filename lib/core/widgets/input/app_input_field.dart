import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/theme.dart';

enum AppInputType { text, password, multiline, dropdown, phone, date }

class AppInputField extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final AppInputType type;
  final bool required;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;

  /// dropdown
  final List<String>? dropdownItems;
  final bool enabled;

  /// single select
  final String? value;
  final Function(String?)? onChanged;

  /// multi select
  final bool multiSelect;
  final List<String>? selectedValues;
  final Function(List<String>)? onMultiChanged;
  final String? Function(String?)? validator;
  final DateTime? firstDate;
  final DateTime? lastDate;

  final int maxLines;

  const AppInputField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.type = AppInputType.text,
    this.required = false,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.dropdownItems,
    this.value,
    this.onChanged,
    this.multiSelect = false,
    this.selectedValues,
    this.onMultiChanged,
    this.maxLines = 1,
    this.validator,
    this.enabled = true,
    this.firstDate,
    this.lastDate,
  });

  @override
  State<AppInputField> createState() => _AppInputFieldState();
}

class _AppInputFieldState extends State<AppInputField> {
  bool obscure = true;

  TextStyle get inputStyle => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.neutrals02,
  );

  @override
  Widget build(BuildContext context) {
    final labelWidget = RichText(
      text: TextSpan(
        text: widget.label,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
          color: AppColors.neutrals02,
          fontWeight: FontWeight.w400,
        ),
        children: widget.required
            ? const [
                TextSpan(
                  text: " *",
                  style: TextStyle(color: Colors.red),
                ),
              ]
            : [],
      ),
    );

    Widget field;

    switch (widget.type) {
      case AppInputType.password:
        field = TextFormField(
          enabled: widget.enabled,
          controller: widget.controller,
          obscureText: obscure,
          keyboardType: widget.keyboardType,
          style: inputStyle,
          validator: (value) {
            if (widget.required && (value == null || value.trim().isEmpty)) {
              return "${widget.label} is required";
            }
            return null;
          },
          decoration: _decoration().copyWith(
            suffixIcon: IconButton(
              icon: Icon(
                obscure ? Icons.visibility_off : Icons.visibility,
                size: 18,
              ),
              onPressed: () => setState(() => obscure = !obscure),
            ),
          ),
        );
        break;

      case AppInputType.multiline:
        field = TextFormField(
          enabled: widget.enabled,
          controller: widget.controller,
          maxLines: widget.maxLines,
          keyboardType: widget.keyboardType,
          style: inputStyle,
          decoration: _decoration(),
          validator: (value) {
            if (widget.required && (value == null || value.trim().isEmpty)) {
              return "${widget.label} is required";
            }
            return null;
          },
        );
        break;

      case AppInputType.dropdown:
        field = FormField<String>(
          initialValue: widget.value,
          validator: (_) {
            if (widget.validator != null) {
              return widget.validator!(widget.value);
            }

            if (widget.required &&
                !widget.multiSelect &&
                (widget.value == null || widget.value!.isEmpty)) {
              return "${widget.label} is required";
            }

            return null;
          },
          builder: (fieldState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SearchableDropdown(
                  items: widget.dropdownItems ?? [],
                  hint: widget.hint,
                  value: widget.value,
                  multiSelect: widget.multiSelect,
                  selectedValues: widget.selectedValues ?? [],
                  hasError: fieldState.hasError,
                  onChanged: (value) {
                    fieldState.didChange(value);
                    widget.onChanged?.call(value);
                  },
                  onMultiChanged: widget.onMultiChanged,
                ),

                if (fieldState.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 6, left: 16),
                    child: Text(
                      fieldState.errorText!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            );
          },
        );
        break;

      case AppInputType.phone:
        field = TextFormField(
          enabled: widget.enabled,
          controller: widget.controller,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(11),
            TextInputFormatter.withFunction((oldValue, newValue) {
              String text = newValue.text;

              // Don't allow deleting the prefix
              if (text.isEmpty) {
                text = '01';
              }

              // Always keep the prefix as 01
              if (!text.startsWith('01')) {
                if (text.length == 1) {
                  text = '01';
                } else {
                  text = '01${text.replaceFirst(RegExp(r'^0?1?'), '')}';
                }
              }

              return TextEditingValue(
                text: text,
                selection: TextSelection.collapsed(offset: text.length),
              );
            }),
          ],
          maxLength: 10,
          style: inputStyle,
          decoration: _decoration().copyWith(counterText: ""),
          validator: (value) {
            if (widget.required && (value == null || value.trim().isEmpty)) {
              return "${widget.label} is required";
            }

            if (value != null &&
                value.isNotEmpty &&
                !RegExp(r'^\d{10}$').hasMatch(value)) {
              return "Enter a valid 10 digit phone number";
            }

            return null;
          },
        );
        break;

      case AppInputType.date:
        field = TextFormField(
          enabled: widget.enabled,
          controller: widget.controller,
          keyboardType: TextInputType.datetime,
          style: inputStyle,
          decoration: _decoration().copyWith(
            hintText: "DD/MM/YYYY",
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today_outlined),
              onPressed: _pickDate,
            ),
          ),
          validator: (value) {
            if (widget.required && (value == null || value.trim().isEmpty)) {
              return "${widget.label} is required";
            }

            if (value != null && value.isNotEmpty && !_isValidDate(value)) {
              return "Enter a valid date";
            }

            return null;
          },
        );
        break;
      default:
        field = TextFormField(
          enabled: widget.enabled,
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          style: inputStyle,
          decoration: _decoration().copyWith(suffixIcon: widget.suffixIcon),
          onChanged: widget.onChanged,
          validator: (value) {
            if (widget.required && (value == null || value.trim().isEmpty)) {
              return "${widget.label} is required";
            }
            return null;
          },
        );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        labelWidget,
        const SizedBox(height: 6),
        field,
        const SizedBox(height: 14),
      ],
    );
  }

  InputDecoration _decoration() {
    return InputDecoration(
      hintText: widget.hint,
      hintStyle: const TextStyle(fontSize: 14, color: AppColors.neutrals03),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      filled: true,
      fillColor: AppColors.neutrals01,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: AppColors.primary01.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: AppColors.primary01, width: 1.5),
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();

    DateTime initial = now;

    if (widget.controller?.text.isNotEmpty == true) {
      try {
        final parts = widget.controller!.text.split("/");
        if (parts.length == 3) {
          initial = DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
        }
      } catch (_) {}
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: widget.firstDate ?? DateTime(1950),
      lastDate: widget.lastDate ?? now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary01),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final day = picked.day.toString().padLeft(2, "0");
      final month = picked.month.toString().padLeft(2, "0");
      final year = picked.year.toString();

      final value = "$day/$month/$year";

      widget.controller?.text = value;

      // 🔥 Notify parent
      widget.onChanged?.call(value);

      setState(() {});
    }
  }
}

class _SearchableDropdown extends StatefulWidget {
  final List<String> items;
  final String? hint;

  /// single select
  final String? value;
  final Function(String?)? onChanged;

  /// multi select
  final bool multiSelect;
  final List<String> selectedValues;
  final Function(List<String>)? onMultiChanged;
  final bool hasError;

  const _SearchableDropdown({
    required this.items,
    this.hint,
    this.value,
    this.multiSelect = false,
    this.selectedValues = const [],
    this.onChanged,
    this.onMultiChanged,
    this.hasError = false,
  });

  @override
  State<_SearchableDropdown> createState() => _SearchableDropdownState();
}

bool _isValidDate(String value) {
  final regex = RegExp(r'^\d{2}/\d{2}/\d{4}$');

  if (!regex.hasMatch(value)) return false;

  try {
    final parts = value.split("/");

    final date = DateTime(
      int.parse(parts[2]), // year
      int.parse(parts[1]), // month
      int.parse(parts[0]), // day
    );

    // Prevent impossible dates like 31/02/2024
    if (date.day != int.parse(parts[0]) ||
        date.month != int.parse(parts[1]) ||
        date.year != int.parse(parts[2])) {
      return false;
    }

    // Prevent future dates (useful for Date of Birth)
    if (date.isAfter(DateTime.now())) {
      return false;
    }

    return true;
  } catch (_) {
    return false;
  }
}

class _SearchableDropdownState extends State<_SearchableDropdown> {
  late TextEditingController searchController;
  late List<String> filteredItems;
  late List<String> tempSelected;

  @override
  void initState() {
    super.initState();

    searchController = TextEditingController();
    filteredItems = widget.items;
    tempSelected = List.from(widget.selectedValues);
  }

  void openDropdown() async {
    searchController.clear();
    filteredItems = widget.items;
    tempSelected = List.from(widget.selectedValues);

    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _buildModal(),
    );

    if (!widget.multiSelect && result != null) {
      widget.onChanged?.call(result);
    }
  }

  Widget _buildModal() {
    return StatefulBuilder(
      builder: (context, modalSetState) {
        return Container(
          height: 450,
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: AppColors.neutrals01,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              /// SEARCH
              TextFormField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: "Search...",
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  modalSetState(() {
                    filteredItems = widget.items
                        .where(
                          (e) => e.toLowerCase().contains(value.toLowerCase()),
                        )
                        .toList();
                  });
                },
              ),

              const SizedBox(height: 12),

              /// LIST
              Expanded(
                child: ListView.builder(
                  itemCount: filteredItems.length,
                  itemBuilder: (_, index) {
                    final item = filteredItems[index];

                    if (widget.multiSelect) {
                      final selected = tempSelected.contains(item);

                      return CheckboxListTile(
                        value: selected,

                        title: Text(item, style: const TextStyle(fontSize: 14)),
                        visualDensity: const VisualDensity(
                          vertical: -4,
                          horizontal: -4,
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: AppColors.primary01,
                        dense: true,
                        onChanged: (checked) {
                          modalSetState(() {
                            if (checked == true) {
                              if (!tempSelected.contains(item)) {
                                tempSelected.add(item);
                              }
                            } else {
                              tempSelected.remove(item);
                            }
                          });
                        },
                      );
                    }

                    return ListTile(
                      title: Text(item),
                      onTap: () {
                        Navigator.pop(context, item);
                      },
                    );
                  },
                ),
              ),

              /// DONE BUTTON
              if (widget.multiSelect)
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    label: "Apply",
                    variant: AppButtonVariant.gradient,
                    onPressed: () {
                      widget.onMultiChanged?.call(tempSelected);
                      Navigator.pop(context);
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String text;

    if (widget.multiSelect) {
      text = widget.selectedValues.isEmpty
          ? widget.hint ?? "Select"
          : widget.selectedValues.join(", ");
    } else {
      text = widget.value ?? widget.hint ?? "Select";
    }

    return GestureDetector(
      onTap: openDropdown,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        decoration: BoxDecoration(
          // color: Theme.of(context).inputDecorationTheme.fillColor,
          borderRadius: widget.hasError
              ? BorderRadius.circular(AppRadius.medium)
              : BorderRadius.circular(5),
          border: Border.all(
            color: widget.hasError
                ? AppColors.error
                : AppColors.primary01.withOpacity(0.3),
            width: widget.hasError ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  color: widget.value == null
                      ? AppColors.neutrals03
                      : AppColors.neutrals02,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.neutrals03,
            ),
          ],
        ),
      ),
    );
  }
}
