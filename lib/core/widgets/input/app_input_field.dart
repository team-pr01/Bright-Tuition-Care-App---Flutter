import 'package:flutter/material.dart';
import '../../config/theme.dart';

enum AppInputType { text, password, multiline, dropdown }

class AppInputField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final AppInputType type;
  final bool required;
  final Widget? suffixIcon;

  /// dropdown
  final List<String>? dropdownItems;

  /// single select
  final String? value;
  final Function(String?)? onChanged;

  /// multi select
  final bool multiSelect;
  final List<String>? selectedValues;
  final Function(List<String>)? onMultiChanged;

  final int maxLines;

  const AppInputField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.type = AppInputType.text,
    this.required = false,
    this.suffixIcon,
    this.dropdownItems,
    this.value,
    this.onChanged,
    this.multiSelect = false,
    this.selectedValues,
    this.onMultiChanged,
    this.maxLines = 1,
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
        field = TextField(
          controller: widget.controller,
          obscureText: obscure,
          style: inputStyle,
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
        field = TextField(
          controller: widget.controller,
          maxLines: widget.maxLines,
          style: inputStyle,
          decoration: _decoration(),
        );
        break;

      case AppInputType.dropdown:
        field = _SearchableDropdown(
          items: widget.dropdownItems ?? [],
          hint: widget.hint,
          value: widget.value,
          multiSelect: widget.multiSelect,
          selectedValues: widget.selectedValues ?? [],
          onChanged: widget.onChanged,
          onMultiChanged: widget.onMultiChanged,
        );
        break;

      default:
        field = TextField(
          controller: widget.controller,
          style: inputStyle,
          decoration: _decoration().copyWith(
            suffixIcon: widget.suffixIcon,
          ),
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
      hintStyle: const TextStyle(
        fontSize: 14,
        color: AppColors.neutrals03,
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      filled: true,
      fillColor: AppColors.neutrals01,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          color: AppColors.primary01.withOpacity(0.3),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(
          color: AppColors.primary01,
          width: 1.5,
        ),
      ),
    );
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

  const _SearchableDropdown({
    required this.items,
    this.hint,
    this.value,
    this.multiSelect = false,
    this.selectedValues = const [],
    this.onChanged,
    this.onMultiChanged,
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
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16),
          ),
        ),
        child: Column(
          children: [

            /// SEARCH
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: "Search...",
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                modalSetState(() {
                  filteredItems = widget.items
                      .where((e) =>
                          e.toLowerCase().contains(value.toLowerCase()))
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

                      title: Text(
                        item,
                        style: const TextStyle(fontSize: 14),
                      ),

                      controlAffinity:
                          ListTileControlAffinity.leading,

                      activeColor: AppColors.primary01,

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
                child: ElevatedButton(
                  onPressed: () {
                    widget.onMultiChanged?.call(tempSelected);
                    Navigator.pop(context);
                  },
                  child: const Text("Done"),
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
      child: Container(
        height: 45,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.neutrals01,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: AppColors.primary01.withOpacity(0.3),
          ),
        ),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }
}
