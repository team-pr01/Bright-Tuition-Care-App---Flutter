import 'package:btcclient/core/data/how_it_works_data.dart';
import 'package:btcclient/core/widgets/navbar/common_appbar.dart';
import 'package:btcclient/features/guardian/presentation/widgets/time_line_Item.dart';
import 'package:flutter/material.dart';

class HowItWorksScreen extends StatelessWidget {
  const HowItWorksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final steps = guardianSteps;

    return Scaffold(
      appBar: const CommonAppBar(),

      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 24),
        itemCount: steps.length,
        itemBuilder: (context, index) {
          return Center(
            child: TimelineItem(
              step: steps[index],
              isLast: index == steps.length - 1,
            ),
          );
        },
      ),
    );
  }
}
