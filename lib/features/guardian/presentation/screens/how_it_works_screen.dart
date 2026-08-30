
import 'package:btcclient/core/data/how_it_works_data.dart';
import 'package:btcclient/core/widgets/navbar/common_appbar.dart';
import 'package:btcclient/features/guardian/presentation/widgets/time_line_Item.dart';
import 'package:flutter/material.dart';

class HowItWorksScreen extends StatefulWidget {
  const HowItWorksScreen({super.key});

  @override
  State<HowItWorksScreen> createState() => _HowItWorksScreenState();
}

class _HowItWorksScreenState extends State<HowItWorksScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Animation<double> _fadeAnimation(int index, int totalItems) {
    final double start = (index / totalItems) * 0.65;
    final double end = (start + 0.35).clamp(0.0, 1.0);

    return CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        start,
        end,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  Animation<Offset> _slideAnimation(int index, int totalItems) {
    final double start = (index / totalItems) * 0.65;
    final double end = (start + 0.35).clamp(0.0, 1.0);

    return Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          start,
          end,
          curve: Curves.easeOutCubic,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final steps = guardianSteps;

    return Scaffold(
      appBar: const CommonAppBar(
        title: "How It Works",
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 24),
        itemCount: steps.length,
        itemBuilder: (context, index) {
          final fadeAnimation = _fadeAnimation(
            index,
            steps.length,
          );

          final slideAnimation = _slideAnimation(
            index,
            steps.length,
          );

          return FadeTransition(
            opacity: fadeAnimation,
            child: SlideTransition(
              position: slideAnimation,
              child: Center(
                child: TimelineItem(
                  step: steps[index],
                  isLast: index == steps.length - 1,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

