import 'package:flutter/material.dart';
import '../../config/theme.dart';

class SegmentedSwitch extends StatelessWidget {

  final List<String> items;
  final int? selectedIndex;
  final Function(int) onChanged;

  const SegmentedSwitch({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      height: 48,

      padding: const EdgeInsets.all(4),

      decoration: BoxDecoration(

        color: AppColors.primary03,

        borderRadius: BorderRadius.circular(
          AppRadius.small,
        ),

      ),

      child: LayoutBuilder(

        builder: (context, constraints) {

          final itemWidth =
              constraints.maxWidth / items.length;

          return Stack(

            children: [

              /// Highlight ONLY if selected
              if (selectedIndex != null)
                AnimatedPositioned(

                  duration:
                      const Duration(milliseconds: 250),

                  curve: Curves.easeInOut,

                  left: selectedIndex! * itemWidth,

                  top: 0,
                  bottom: 0,

                  child: Container(

                    width: itemWidth,

                    decoration: BoxDecoration(

                      color: AppColors.neutrals01,

                      borderRadius:
                          BorderRadius.circular(
                        AppRadius.small,
                      ),

                      boxShadow: const [

                        BoxShadow(

                          color: Color(0x260D99FF),

                          offset: Offset(-2, 0),

                          blurRadius: 4,

                        ),

                      ],

                    ),

                  ),

                ),

              /// Buttons
              Row(

                children: List.generate(

                  items.length,

                  (index) {

                    final isSelected =
                        selectedIndex == index;

                    return Expanded(

                      child: GestureDetector(

                        behavior:
                            HitTestBehavior.opaque,

                        onTap: () =>
                            onChanged(index),

                        child: Center(

                          child: AnimatedDefaultTextStyle(

                            duration:
                                const Duration(
                              milliseconds: 200,
                            ),

                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(

                                  fontWeight:
                                      FontWeight.w400,

                                  color: isSelected
                                      ? AppColors
                                          .neutrals02
                                      : AppColors
                                          .neutrals03,

                                ),

                            child: Text(
                              items[index],
                            ),

                          ),

                        ),

                      ),

                    );

                  },

                ),

              ),

            ],

          );

        },

      ),

    );

  }

}