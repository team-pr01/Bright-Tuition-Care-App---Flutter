import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/features/profile/presentation/widgets/profile_overview_card.dart';
import 'package:flutter/material.dart';

class EducationItemCard extends StatefulWidget {
  final String title;
  final List<ProfileInfoItem> items;
  final VoidCallback? onEdit;

  const EducationItemCard({
    super.key,
    required this.title,
    required this.items,
    this.onEdit,
  });

  @override
  State<EducationItemCard> createState() => _EducationItemCardState();
}

class _EducationItemCardState extends State<EducationItemCard> {
  bool expanded = false;

  String _value(String label) {
    try {
      return widget.items
              .firstWhere((e) => e.label == label)
              .value
              ?.trim() ??
          "";
    } catch (_) {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final institute = _value("Institute Name");
    final year = _value("Passing Year");
    final current = _value("Current Institute");

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.neutrals04,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: () {
              setState(() {
                expanded = !expanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: AppColors.primary01.withOpacity(.08),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.school_outlined,
                      color: AppColors.primary01,
                      size: 28,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: AppTextStyles.titleLarge.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 6),

                        if (institute.isNotEmpty)
                          Text(
                            institute,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.neutrals03,
                            ),
                          ),

                        if (year.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              "Passing Year • $year",
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.neutrals03,
                              ),
                            ),
                          ),

                        if (current == "Yes")
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(.08),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Text(
                                "Current Institute",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  Column(
                    children: [
                      IconButton(
                        onPressed: widget.onEdit,
                        icon: const Icon(Icons.edit_outlined),
                      ),
                      AnimatedRotation(
                        turns: expanded ? .5 : 0,
                        duration: const Duration(milliseconds: 250),
                        child: const Icon(Icons.keyboard_arrow_down_rounded),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          AnimatedCrossFade(
            firstChild: const SizedBox(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(22, 0, 22, 22),
              child: Column(
                children: [
                  Divider(
                    color: AppColors.neutrals04,
                  ),

                  const SizedBox(height: 8),

                  ...widget.items.map(
                    (e) => _EducationRow(item: e),
                  ),
                ],
              ),
            ),
            crossFadeState: expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }
}

class _EducationRow extends StatelessWidget {
  final ProfileInfoItem item;

  const _EducationRow({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue =
        item.value != null &&
        item.value!.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 145,
            child: Text(
              item.label,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(
            width: 18,
            child: Center(
              child: Text(
                ":",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Expanded(
            child: Text(
              hasValue ? item.value! : "Not Added",
              style: AppTextStyles.bodyMedium.copyWith(
                color: hasValue
                    ? AppColors.neutrals02
                    : Colors.grey,
                fontStyle:
                    hasValue ? FontStyle.normal : FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}