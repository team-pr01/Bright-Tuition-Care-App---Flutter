import 'package:btcclient/core/widgets/navbar/common_appbar.dart';
import 'package:btcclient/features/refer/presentation/provider/my_leads_provider.dart';
import 'package:btcclient/features/refer/presentation/screens/refer_form_screen.dart';
import 'package:btcclient/features/refer/presentation/widgets/add_payment_method_screen.dart';
import 'package:btcclient/features/refer/presentation/widgets/lead_card.dart';
import 'package:btcclient/features/refer/presentation/widgets/skeleton/lead_card_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyLeadsScreen extends ConsumerStatefulWidget {
  const MyLeadsScreen({super.key});

  @override
  ConsumerState<MyLeadsScreen> createState() => _MyLeadsScreenState();
}

class _MyLeadsScreenState extends ConsumerState<MyLeadsScreen> {
  int? expandedIndex;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(myLeadsProvider.notifier).fetchLeads();
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(myLeadsProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myLeadsProvider);

    return Scaffold(
      appBar: const CommonAppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(myLeadsProvider.notifier).refresh();
        },
        child: Builder(
          builder: (context) {
            if (state.loading) {
              return ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(12),
                itemCount: 6,
                itemBuilder: (_, __) => const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: LeadCardSkeleton(),
                ),
              );
            }

            if (state.error != null) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .7,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(state.error!, textAlign: TextAlign.center),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              ref.read(myLeadsProvider.notifier).fetchLeads();
                            },
                            child: const Text("Retry"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            if (state.leads.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .7,
                    child: const Center(child: Text("No Leads Found")),
                  ),
                ],
              );
            }

            return ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: state.leads.length + (state.loadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.leads.length) {
                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(12),
                    itemCount: 6,
                    itemBuilder: (_, __) => const Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: LeadCardSkeleton(),
                    ),
                  );
                }

                final lead = state.leads[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: LeadCard(
                    lead: lead,
                    onPayment: () async {
                      final updated = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddPaymentMethodScreen(lead: lead),
                        ),
                      );

                      if (updated == true && mounted) {
                        ref.read(myLeadsProvider.notifier).refresh();
                      }
                    },
                    onEdit: () async {
                      final updated = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              AddLeadScreen(lead: lead, isEditing: true),
                        ),
                      );

                      if (updated == true && mounted) {
                        ref.read(myLeadsProvider.notifier).refresh();
                      }
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
