import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/navbar/common_appbar.dart';
import 'package:btcclient/features/confirmation/presentation/notifier/confirmation_notifier.dart';
import 'package:btcclient/features/confirmation/presentation/provider/confirmation_provider.dart';
import 'package:btcclient/features/confirmation/presentation/widgets/confirmation_bottom_sheet.dart';
import 'package:btcclient/features/confirmation/presentation/widgets/confirmation_card.dart';

import 'package:btcclient/features/invoices/presentation/widgets/skeleton/invoice_card_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ConfirmationScreen extends ConsumerStatefulWidget {
  final String role;

  const ConfirmationScreen({super.key, required this.role});

  @override
  ConsumerState<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends ConsumerState<ConfirmationScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(confirmationProvider.notifier).fetchLetters(role: widget.role);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(confirmationProvider);

    return Scaffold(
      appBar: const CommonAppBar(title: "Confirmation Letters"),

      body: SafeArea(child: _buildBody(state)),
    );
  }

  Widget _buildBody(ConfirmationState state) {
    if (state.isLoading && state.letters.isEmpty) {
      return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: 5,
        separatorBuilder: (_, __) => const SizedBox(height: 4),
        itemBuilder: (_, __) => const InvoiceCardSkeleton(),
      );
    }

    if (state.error != null && state.letters.isEmpty) {
      return Center(child: Text(state.error!));
    }

    if (!state.isLoading && state.letters.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/navigations/jobs.svg',
              width: 80,
              height: 80,
              colorFilter: const ColorFilter.mode(
                AppColors.primary01,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'No confirmation letters found',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(confirmationProvider.notifier).refresh(widget.role);
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: state.letters.length,
        itemBuilder: (context, index) {
          final letter = state.letters[index];

          return ConfirmationCard(
            letter: letter,
            onView: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) {
                  return ConfirmationBottomSheet(
                    letterId: letter.id,
                    role: widget.role,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
