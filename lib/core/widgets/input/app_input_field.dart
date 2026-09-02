import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/core/widgets/reusable_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../config/theme.dart';

enum AppInputType {
  text,
  password,
  multiline,
  dropdown,
  dropdown2, // NEW
  phone,
  date,
}

class AppInputField extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final AppInputType type;
  final bool required;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;

  /// Dropdown
  final List<String>? dropdownItems;
  final bool enabled;

  /// Single select
  final String? value;
  final Function(String?)? onChanged;

  /// Multi select
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
      // ============================================================
      // PASSWORD
      // ============================================================

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
              onPressed: () {
                setState(() {
                  obscure = !obscure;
                });
              },
            ),
          ),
        );
        break;

      // ============================================================
      // MULTILINE
      // ============================================================

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

      // ============================================================
      // EXISTING DROPDOWN
      // ============================================================

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

      // ============================================================
      // NEW DROPDOWN 2
      // ============================================================

      // ============================================================
      // DROPDOWN 2
      // SINGLE + MULTI SELECT
      // ============================================================

      // ============================================================
      // DROPDOWN 2
      // SINGLE + MULTI SELECT
      // ============================================================

      case AppInputType.dropdown2:
        if (widget.multiSelect) {
          field = FormField<List<String>>(
            initialValue: widget.selectedValues ?? const [],
            validator: (_) {
              if (widget.validator != null) {
                return widget.validator!(
                  (widget.selectedValues ?? []).join(", "),
                );
              }

              if (widget.required &&
                  (widget.selectedValues == null ||
                      widget.selectedValues!.isEmpty)) {
                return "${widget.label} is required";
              }

              return null;
            },
            builder: (fieldState) {
              return _Dropdown2Field(
                label: labelWidget,
                hint: widget.hint,
                items: widget.dropdownItems ?? [],
                enabled: widget.enabled,
                multiSelect: true,
                selectedValues: widget.selectedValues ?? [],
                hasError: fieldState.hasError,
                onMultiChanged: (values) {
                  fieldState.didChange(values);
                  widget.onMultiChanged?.call(values);
                },
                onChanged: null,
                errorText: fieldState.errorText,
              );
            },
          );
        } else {
          field = FormField<String>(
            initialValue: widget.value,
            validator: (_) {
              if (widget.validator != null) {
                return widget.validator!(widget.value);
              }

              if (widget.required &&
                  (widget.value == null || widget.value!.isEmpty)) {
                return "${widget.label} is required";
              }

              return null;
            },
            builder: (fieldState) {
              return _Dropdown2Field(
                label: labelWidget,
                hint: widget.hint,
                items: widget.dropdownItems ?? [],
                enabled: widget.enabled,
                multiSelect: false,
                value: widget.value,
                selectedValues: const [],
                hasError: fieldState.hasError,
                onChanged: (value) {
                  fieldState.didChange(value);
                  widget.onChanged?.call(value);
                },
                onMultiChanged: null,
                errorText: fieldState.errorText,
              );
            },
          );
        }
        break;
      // ============================================================
      // PHONE
      // ============================================================

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

              if (text.isEmpty) {
                text = '01';
              }

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
          maxLength: 11,
          style: inputStyle,
          decoration: _decoration().copyWith(counterText: ""),
          validator: (value) {
            if (widget.required && (value == null || value.trim().isEmpty)) {
              return "${widget.label} is required";
            }

            if (value != null &&
                value.isNotEmpty &&
                !RegExp(r'^\d{11}$').hasMatch(value)) {
              return "Enter a valid 11 digit phone number";
            }

            return null;
          },
        );
        break;

      // ============================================================
      // DATE
      // ============================================================

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

      // ============================================================
      // NORMAL TEXT
      // ============================================================

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

    if (widget.type == AppInputType.dropdown2) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [field, const SizedBox(height: 14)],
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

  // ================================================================
  // NORMAL INPUT DECORATION
  // ================================================================

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

  // ================================================================
  // DATE PICKER
  // ================================================================

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

      widget.onChanged?.call(value);

      setState(() {});
    }
  }
}

// ==================================================================
// DROPDOWN 2
// CHIP BASED MULTI SELECT
// ==================================================================

// ==================================================================
// DROPDOWN 2 FIELD
// HANDLES BOTH SINGLE + MULTI SELECT
// ==================================================================

class _Dropdown2Field extends StatelessWidget {
  final Widget label;
  final String? hint;
  final List<String> items;

  final bool enabled;
  final bool multiSelect;

  final String? value;
  final List<String> selectedValues;

  final bool hasError;
  final String? errorText;

  final Function(String?)? onChanged;
  final Function(List<String>)? onMultiChanged;

  const _Dropdown2Field({
    required this.label,
    required this.hint,
    required this.items,
    required this.enabled,
    required this.multiSelect,
    required this.selectedValues,
    required this.hasError,
    required this.errorText,
    this.value,
    this.onChanged,
    this.onMultiChanged,
  });

  // ================================================================
  // OPEN DROPDOWN
  // ================================================================

  Future<void> _openDropdown(BuildContext context) async {
    if (!enabled) return;

    if (multiSelect) {
      final result = await ReusableModal.show<List<String>>(
        context: context,
        child: _Dropdown2SelectionContent(
          items: items,
          initialSelectedValues: selectedValues,
        ),
      );

      if (result != null) {
        onMultiChanged?.call(result);
      }

      return;
    }

    final result = await ReusableModal.show<String>(
      context: context,
      child: _Dropdown2SingleSelectionContent(
        items: items,
        initialValue: value,
      ),
    );

    if (result != null) {
      onChanged?.call(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasSelection = multiSelect
        ? selectedValues.isNotEmpty
        : value != null && value!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ==========================================================
        // LABEL + DOWN ARROW
        // ==========================================================
        GestureDetector(
          onTap: () => _openDropdown(context),
          behavior: HitTestBehavior.opaque,
          child: Row(
            children: [
              Expanded(child: label),

              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 22,
                color: enabled
                    ? AppColors.neutrals03
                    : AppColors.neutrals03.withOpacity(0.5),
              ),
            ],
          ),
        ),

        const SizedBox(height: 6),

        // ==========================================================
        // INPUT AREA
        // ==========================================================
        GestureDetector(
          onTap: () => _openDropdown(context),
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 48),
            padding: EdgeInsets.symmetric(
              horizontal: hasSelection ? 0 : 12,
              vertical: hasSelection ? 0 : 0,
            ),
            decoration: BoxDecoration(
              color: hasSelection ? Colors.transparent : AppColors.neutrals01,
              borderRadius: BorderRadius.circular(5),
              border: hasSelection
                  ? Border.all(color: Colors.transparent, width: 0)
                  : Border.all(
                      color: hasError
                          ? AppColors.error
                          : AppColors.primary01.withOpacity(0.3),
                      width: hasError ? 1.5 : 1,
                    ),
            ),
            child: multiSelect
                ? _buildMultiSelectContent()
                : _buildSingleSelectContent(),
          ),
        ),

        // ==========================================================
        // ERROR
        // ==========================================================
        if (hasError && errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 16),
            child: Text(
              errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  // ================================================================
  // SINGLE SELECT CONTENT
  // ================================================================

  // ================================================================
  // SINGLE SELECT CONTENT
  // ================================================================

  Widget _buildSingleSelectContent() {
    final bool hasSelection = value != null && value!.isNotEmpty;

    if (!hasSelection) {
      return SizedBox(
        height: 48,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            hint ?? "Select",
            style: const TextStyle(fontSize: 14, color: AppColors.neutrals03),
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(minHeight: 38),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.neutrals03.withOpacity(0.18),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: Text(
          value!,
          style: const TextStyle(fontSize: 14, color: AppColors.neutrals02),
        ),
      ),
    );
  }

  // ================================================================
  // MULTI SELECT CONTENT
  // ================================================================

  Widget _buildMultiSelectContent() {
    if (selectedValues.isEmpty) {
      return SizedBox(
        height: 48,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            hint ?? "Select",
            style: const TextStyle(fontSize: 14, color: AppColors.neutrals03),
          ),
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: selectedValues.map((item) {
        return _SelectedChip(
          label: item,
          onRemove: enabled
              ? () {
                  final updatedValues = List<String>.from(selectedValues)
                    ..remove(item);

                  onMultiChanged?.call(updatedValues);
                }
              : null,
        );
      }).toList(),
    );
  }
}

// ==================================================================
// DROPDOWN 2
// CHIP BASED MULTI SELECT
// ==================================================================

// ==================================================================
// DROPDOWN 2
// SINGLE SELECT MODAL CONTENT
// ==================================================================

class _Dropdown2SingleSelectionContent extends StatefulWidget {
  final List<String> items;
  final String? initialValue;

  const _Dropdown2SingleSelectionContent({
    required this.items,
    this.initialValue,
  });

  @override
  State<_Dropdown2SingleSelectionContent> createState() =>
      _Dropdown2SingleSelectionContentState();
}

class _Dropdown2SingleSelectionContentState
    extends State<_Dropdown2SingleSelectionContent> {
  late TextEditingController searchController;

  late List<String> filteredItems;

  String? selectedValue;

  @override
  void initState() {
    super.initState();

    searchController = TextEditingController();

    filteredItems = List<String>.from(widget.items);

    selectedValue = widget.initialValue;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // ================================================================
  // SEARCH
  // ================================================================

  void _search(String value) {
    setState(() {
      filteredItems = widget.items
          .where((item) => item.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  // ================================================================
  // CANCEL
  // ================================================================

  void _cancel() {
    Navigator.of(context).pop();
  }

  // ================================================================
  // APPLY
  // ================================================================

  void _apply() {
    if (selectedValue == null) {
      return;
    }

    Navigator.of(context).pop(selectedValue);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==========================================================
          // TITLE
          // ==========================================================
          const Text(
            "Select",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: AppColors.neutrals02,
            ),
          ),

          const SizedBox(height: 20),

          // ==========================================================
          // SEARCH BAR
          // ==========================================================
          TextFormField(
            controller: searchController,
            onChanged: _search,
            style: const TextStyle(fontSize: 14, color: AppColors.neutrals02),
            decoration: InputDecoration(
              hintText: "Search...",
              prefixIcon: Icon(Icons.search),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.medium),
                borderSide: BorderSide(
                  color: AppColors.primary01.withOpacity(0.5),
                  width: 1,
                ),
              ),
            ),
          ),

          const SizedBox(height: 18),

          // ==========================================================
          // OPTIONS
          // ==========================================================
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: filteredItems.map((item) {
              final bool isSelected = selectedValue == item;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedValue = item;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary01.withOpacity(0.18)
                        : AppColors.neutrals03.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected
                          ? AppColors.primary01
                          : AppColors.neutrals02,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // ==========================================================
          // CANCEL / APPLY
          // ==========================================================
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 125,
                child: AppButton(
                  label: "Cancel",
                  variant: AppButtonVariant.outline,
                  onPressed: _cancel,
                ),
              ),

              const SizedBox(width: 12),

              SizedBox(
                width: 90,
                child: AppButton(
                  label: "Apply",
                  variant: AppButtonVariant.primary,
                  onPressed: selectedValue == null ? null : _apply,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ==================================================================
// SELECTED CHIP
// ==================================================================

class _SelectedChip extends StatelessWidget {
  final String label;
  final VoidCallback? onRemove;

  const _SelectedChip({required this.label, this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 38),
      padding: const EdgeInsets.only(left: 8, right: 12),
      decoration: BoxDecoration(
        color: AppColors.neutrals03.withOpacity(0.18),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ==========================================================
          // REMOVE ICON
          // ==========================================================
          if (onRemove != null)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onRemove,
              child: Container(
                width: 18,
                height: 18,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary01,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 12, color: Colors.white),
              ),
            ),

          // ==========================================================
          // LABEL
          // ==========================================================
          Flexible(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: AppColors.neutrals02),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================================================================
// DROPDOWN 2 MODAL CONTENT
// ==================================================================

class _Dropdown2SelectionContent extends StatefulWidget {
  final List<String> items;
  final List<String> initialSelectedValues;

  const _Dropdown2SelectionContent({
    required this.items,
    required this.initialSelectedValues,
  });

  @override
  State<_Dropdown2SelectionContent> createState() =>
      _Dropdown2SelectionContentState();
}

class _Dropdown2SelectionContentState
    extends State<_Dropdown2SelectionContent> {
  late List<String> tempSelected;
  late TextEditingController searchController;

  List<String> filteredItems = [];

  @override
  void initState() {
    super.initState();

    tempSelected = List<String>.from(widget.initialSelectedValues);

    filteredItems = List<String>.from(widget.items);

    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // ================================================================
  // SEARCH
  // ================================================================

  void _search(String value) {
    setState(() {
      filteredItems = widget.items
          .where((item) => item.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  // ================================================================
  // TOGGLE ITEM
  // ================================================================

  void _toggleItem(String item) {
    setState(() {
      if (tempSelected.contains(item)) {
        tempSelected.remove(item);
      } else {
        tempSelected.add(item);
      }
    });
  }

  // ================================================================
  // CANCEL
  // ================================================================

  void _cancel() {
    Navigator.of(context).pop();
  }

  // ================================================================
  // OK
  // ================================================================

  void _apply() {
    Navigator.of(context).pop(List<String>.from(tempSelected));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==========================================================
          // TITLE
          // ==========================================================
          const Padding(
            padding: EdgeInsets.only(right: 0),
            child: Text(
              "Select",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: AppColors.neutrals02,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ==========================================================
          // SEARCH
          // ==========================================================
          TextFormField(
            controller: searchController,
            onChanged: _search,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: "Search...",
              prefixIcon: Icon(Icons.search),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.medium),
                borderSide: BorderSide(
                  color: AppColors.primary01.withOpacity(0.5),
                  width: 1,
                ),
              ),
            ),
          ),

          const SizedBox(height: 18),

          // ==========================================================
          // SELECTABLE CHIPS
          // ==========================================================
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: filteredItems.map((item) {
              final isSelected = tempSelected.contains(item);

              return GestureDetector(
                onTap: () => _toggleItem(item),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary01.withOpacity(0.18)
                        : AppColors.neutrals03.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected
                          ? AppColors.primary01
                          : AppColors.neutrals02,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // ==========================================================
          // CANCEL / OK
          // ==========================================================
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 125,
                child: AppButton(
                  label: "Cancel",
                  variant: AppButtonVariant.outline,
                  onPressed: _cancel,
                ),
              ),

              const SizedBox(width: 12),

              SizedBox(
                width: 90,
                child: AppButton(
                  label: "Apply",
                  variant: AppButtonVariant.primary,
                  onPressed: _apply,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ==================================================================
// EXISTING SEARCHABLE DROPDOWN
// ==================================================================

class _SearchableDropdown extends StatefulWidget {
  final List<String> items;
  final String? hint;

  final String? value;
  final Function(String?)? onChanged;

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

    setState(() {
      filteredItems = widget.items;
      tempSelected = List.from(widget.selectedValues);
    });

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
              TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Search...",
                  prefixIcon: Icon(Icons.search),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                    borderSide: BorderSide(
                      color: AppColors.primary01.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
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
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.neutrals03,
            ),
          ],
        ),
      ),
    );
  }
}

// ==================================================================
// DATE VALIDATION
// ==================================================================

bool _isValidDate(String value) {
  final regex = RegExp(r'^\d{2}/\d{2}/\d{4}$');

  if (!regex.hasMatch(value)) {
    return false;
  }

  try {
    final parts = value.split("/");

    final date = DateTime(
      int.parse(parts[2]),
      int.parse(parts[1]),
      int.parse(parts[0]),
    );

    if (date.day != int.parse(parts[0]) ||
        date.month != int.parse(parts[1]) ||
        date.year != int.parse(parts[2])) {
      return false;
    }

    if (date.isAfter(DateTime.now())) {
      return false;
    }

    return true;
  } catch (_) {
    return false;
  }
}
