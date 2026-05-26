import 'dart:async';

import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/utils/date_formatter.dart';
import 'package:btcclient/core/utils/get_appointed_status.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/core/widgets/input/app_input_field.dart';
import 'package:btcclient/core/widgets/navbar/common_appbar.dart';
import 'package:btcclient/features/jobs/presentation/provider/job_application_provider.dart';
import 'package:btcclient/core/widgets/application_search_bar/application_search_bar.dart';
import 'package:btcclient/features/jobs/presentation/widgets/icon_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GuardianJobApplication extends ConsumerStatefulWidget {
  final String jobId;

  const GuardianJobApplication({super.key, required this.jobId});

  @override
  ConsumerState<GuardianJobApplication> createState() =>
      _GuardianJobApplicationState();
}

class _GuardianJobApplicationState
    extends ConsumerState<GuardianJobApplication> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  Timer? debounce;

  String selectedStatus = "All";
  int selectedLimit = 10;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(jobApplicationProvider.notifier).fetchInitial(widget.jobId);
    });
  }

  @override
  void dispose() {
    debounce?.cancel();
    searchController.dispose();
    dateController.dispose();
    super.dispose();
  }

  String get formattedDate {
    if (selectedDate == null) return "";
    return selectedDate!.toIso8601String().split("T").first;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(jobApplicationProvider);
    final notifier = ref.read(jobApplicationProvider.notifier);

    dateController.text = formattedDate;

    return Scaffold(
      appBar: const CommonAppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          await notifier.fetchInitial(widget.jobId);
        },
        child: Column(
          children: [
            /// 🔍 FILTERS
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  /// SEARCH
                  ApplicationSearchBar(
                    controller: searchController,
                    onChanged: (value) {
                      if (debounce?.isActive ?? false) debounce!.cancel();

                      debounce = Timer(const Duration(milliseconds: 500), () {
                        notifier.applyFilters(
                          jobId: widget.jobId,
                          newKeyword: value,
                          newStatus: selectedStatus == "All"
                              ? ""
                              : selectedStatus,
                          newDate: formattedDate.isEmpty ? null : formattedDate,
                          newLimit: selectedLimit,
                        );
                      });
                    },
                  ),

                  const SizedBox(height: 10),

                  /// STATUS + LIMIT
                  Row(
                    children: [
                      Expanded(
                        child: AppInputField(
                          label: "Status",
                          type: AppInputType.dropdown,
                          dropdownItems: const [
                            "All",
                            "applied",
                            "shortlisted",
                            "appointed",
                            "confirmed",
                            "rejected",
                          ],
                          value: selectedStatus,
                          onChanged: (value) {
                            setState(() => selectedStatus = value ?? "All");

                            notifier.applyFilters(
                              jobId: widget.jobId,
                              newStatus: value == "All" ? "" : value,
                              newKeyword: searchController.text,
                              newDate: formattedDate.isEmpty
                                  ? null
                                  : formattedDate,
                              newLimit: selectedLimit,
                            );
                          },
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: AppInputField(
                          label: "Limit",
                          type: AppInputType.dropdown,
                          dropdownItems: const ["5", "10", "20", "30"],
                          value: selectedLimit.toString(),
                          onChanged: (value) {
                            final limit = int.tryParse(value ?? "10") ?? 10;

                            setState(() => selectedLimit = limit);

                            notifier.applyFilters(
                              jobId: widget.jobId,
                              newStatus: selectedStatus == "All"
                                  ? ""
                                  : selectedStatus,
                              newKeyword: searchController.text,
                              newDate: formattedDate.isEmpty
                                  ? null
                                  : formattedDate,
                              newLimit: limit,
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  /// DATE + CLEAR
                  Row(
                    children: [

                      Expanded(
                        child: AppButton(
                          label: "Clear",
                          variant: AppButtonVariant.gradient,
                          onPressed: () {
                            searchController.clear();

                            setState(() {
                              selectedStatus = "All";
                              selectedLimit = 10;
                              selectedDate = null;
                            });

                            notifier.applyFilters(
                              jobId: widget.jobId,
                              newStatus: "",
                              newKeyword: "",
                              newDate: null,
                              newLimit: 10,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// 📋 LIST + PAGINATION
            Expanded(
              child: Column(
                children: [
                  /// LIST
                  Expanded(
                    child: state.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            itemCount: state.applications.length,
                            itemBuilder: (context, index) {
                              final app = state.applications[index];

                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                  vertical: AppSpacing.sm,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.primary01,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary02.withOpacity(
                                        0.3,
                                      ),
                                      blurRadius: 4,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(AppSpacing.md),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /// NAME + STATUS
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                if ((app.tutorCustomId ?? "")
                                                    .isNotEmpty)
                                                  Text(
                                                    "${app.tutorCustomId} ",
                                                    style: AppTextStyles
                                                        .labelMedium
                                                        .copyWith(
                                                          color: AppColors
                                                              .primary01,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                  ),
                                                Expanded(
                                                  child: Text(
                                                    app.userName,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: AppSpacing.sm,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  StatusDataFormatter.getJobApplicationStatusColor(
                                                    app.status,
                                                  ).withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    AppRadius.full.toDouble(),
                                                  ),
                                            ),
                                            child: Text(
                                              app.status.toUpperCase(),
                                              style: AppTextStyles.labelSmall
                                                  .copyWith(
                                                    color:
                                                        StatusDataFormatter.getJobApplicationStatusColor(
                                                          app.status,
                                                        ),
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: AppSpacing.sm),

                                      Text(
                                        "Applied: ${DateFormatter.formattedDate(app.appliedOn)}",
                                      ),
                                      const SizedBox(height: AppSpacing.sm),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: IconRow(
                                              icon:
                                                  "assets/icons/status/shortlisted.svg",
                                              title: "Shortlisted On",
                                              value: app.shortlistedOn != null
                                                  ? DateFormatter.formattedDate(
                                                      app.shortlistedOn!,
                                                    )
                                                  : "N/A",
                                            ),
                                          ),

                                          Expanded(
                                            child: IconRow(
                                              icon:
                                                  "assets/icons/status/appointed.svg",
                                              title: "Appointed On",
                                              value: app.appointedOn != null
                                                  ? DateFormatter.formattedDate(
                                                      app.appointedOn!,
                                                    )
                                                  : "N/A",
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: AppSpacing.sm),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: IconRow(
                                              icon:
                                                  "assets/icons/status/confirmed.svg",
                                              title: "Confirmed On",
                                              value: app.confirmedOn != null
                                                  ? DateFormatter.formattedDate(
                                                      app.confirmedOn!,
                                                    )
                                                  : "N/A",
                                            ),
                                          ),

                                          Expanded(
                                            child: IconRow(
                                              icon:
                                                  "assets/icons/status/cancelled.svg",
                                              title: "Cancelled On",
                                              value: app.rejectedOn != null
                                                  ? DateFormatter.formattedDate(
                                                      app.rejectedOn!,
                                                    )
                                                  : "N/A",
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: AppSpacing.sm),

                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Spacer(),
                                          const Icon(
                                            Icons.visibility,
                                            size: 16,
                                            color: AppColors.primary01,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            "View CV",
                                            style: AppTextStyles.labelMedium
                                                .copyWith(
                                                  color: AppColors.primary01,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),

                  /// PAGINATION
                  if (state.meta != null)
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 4,
                            color: Colors.black.withOpacity(0.1),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Flexible(
                            child: AppButton(
                              label: "Prev",
                         variant: AppButtonVariant.outlineGray,
                              onPressed: state.meta!.page > 1
                                  ? () => notifier.goToPage(
                                      widget.jobId,
                                      state.meta!.page - 1,
                                    )
                                  : null,
                            ),
                          ),

                          const SizedBox(width: AppSpacing.sm),

                          Text(
                            "${state.meta!.page} / ${state.meta!.totalPages}",
                            style: AppTextStyles.labelMedium,
                          ),

                          const SizedBox(width: AppSpacing.sm),

                          Flexible(
                            child: AppButton(
                              label: "Next",
                               variant: AppButtonVariant.outlineGray,
                              onPressed:
                                  state.meta!.page < state.meta!.totalPages
                                  ? () => notifier.goToPage(
                                      widget.jobId,
                                      state.meta!.page + 1,
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
