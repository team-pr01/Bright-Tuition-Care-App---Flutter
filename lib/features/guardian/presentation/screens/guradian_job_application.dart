import 'dart:async';

import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/utils/date_formatter.dart';
import 'package:btcclient/core/utils/get_appointed_status.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/core/widgets/input/app_input_field.dart';
import 'package:btcclient/core/widgets/navbar/common_appbar.dart';
import 'package:btcclient/core/widgets/application_search_bar/application_search_bar.dart';

import 'package:btcclient/features/auth/data/models/tutor_model.dart';
import 'package:btcclient/features/guardian/presentation/widgets/skeleton/job_application_skeleton_card.dart';
import 'package:btcclient/features/jobs/presentation/provider/job_application_provider.dart';
import 'package:btcclient/features/jobs/presentation/widgets/icon_row.dart';
import 'package:btcclient/features/profile/data/profile_api.dart';
import 'package:btcclient/features/profile/presentation/screens/tutor_profile_view_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GuardianJobApplication extends ConsumerStatefulWidget {
  final String jobId;

  const GuardianJobApplication({
    super.key,
    required this.jobId,
  });

  @override
  ConsumerState<GuardianJobApplication> createState() =>
      _GuardianJobApplicationState();
}

class _GuardianJobApplicationState
    extends ConsumerState<GuardianJobApplication> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController demoDateController = TextEditingController();
  final TextEditingController appointedDateController =
      TextEditingController();

  Timer? debounce;

  String selectedStatus = "All";
  int selectedLimit = 10;

  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref
          .read(jobApplicationProvider.notifier)
          .fetchInitial(widget.jobId);
    });
  }

  @override
  void dispose() {
    debounce?.cancel();

    searchController.dispose();
    demoDateController.dispose();
    appointedDateController.dispose();

    super.dispose();
  }

  // ================================================================
  // VIEW TUTOR CV
  // ================================================================

  Future<void> _viewTutorCV(String tutorId) async {
    final id = tutorId.trim();

    if (id.isEmpty) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tutor information is not available"),
        ),
      );

      return;
    }

    bool loadingDialogShown = false;

    try {
      // ------------------------------------------------------------
      // SHOW LOADING
      // ------------------------------------------------------------

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      loadingDialogShown = true;

      // ------------------------------------------------------------
      // GET TUTOR PROFILE
      // ------------------------------------------------------------

      final TutorProfileModel tutorProfile =
          await getTutorProfile(id);

      if (!mounted) return;

      // ------------------------------------------------------------
      // CLOSE LOADING
      // ------------------------------------------------------------

      if (loadingDialogShown) {
        Navigator.of(context).pop();
        loadingDialogShown = false;
      }

      // ------------------------------------------------------------
      // OPEN TUTOR CV
      // ------------------------------------------------------------

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TutorResumeScreen(
            profile: tutorProfile,

            // Guardian should not see tutor's
            // sensitive contact information.
            hideContactDetails: true,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      // ------------------------------------------------------------
      // CLOSE LOADING IF STILL OPEN
      // ------------------------------------------------------------

      if (loadingDialogShown) {
        Navigator.of(context).pop();
        loadingDialogShown = false;
      }

      // ------------------------------------------------------------
      // SHOW ERROR
      // ------------------------------------------------------------

      String message = e.toString();

      if (message.startsWith("Exception: ")) {
        message = message.replaceFirst(
          "Exception: ",
          "",
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message.isEmpty
                ? "Failed to load tutor CV"
                : message,
          ),
        ),
      );
    }
  }

  // ================================================================
  // REFRESH
  // ================================================================

  Future<void> _refreshWithIndicator() async {
    await _refreshKey.currentState?.show();

    await ref
        .read(jobApplicationProvider.notifier)
        .fetchInitial(
          widget.jobId,
          refresh: true,
        );
  }

  // ================================================================
  // APPLY FILTERS
  // ================================================================

  void _applyCurrentFilters() {
    ref.read(jobApplicationProvider.notifier).applyFilters(
      jobId: widget.jobId,
      newStatus: selectedStatus == "All"
          ? ""
          : selectedStatus,
      newKeyword: searchController.text,
      newDemoDate: demoDateController.text.isEmpty
          ? null
          : demoDateController.text,
      newAppointedDate:
          appointedDateController.text.isEmpty
              ? null
              : appointedDateController.text,
      newLimit: selectedLimit,
    );
  }

  // ================================================================
  // BUILD
  // ================================================================

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(jobApplicationProvider);

    final notifier =
        ref.read(jobApplicationProvider.notifier);

    return Scaffold(
      appBar: const CommonAppBar(
        title: "Job Applications",
      ),

      body: RefreshIndicator(
        key: _refreshKey,

        onRefresh: () async {
          await notifier.fetchInitial(
            widget.jobId,
            refresh: true,
          );
        },

        child: Column(
          children: [
            // ======================================================
            // FILTERS
            // ======================================================

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  // ==================================================
                  // SEARCH
                  // ==================================================

                  ApplicationSearchBar(
                    controller: searchController,

                    onChanged: (value) {
                      if (debounce?.isActive ?? false) {
                        debounce!.cancel();
                      }

                      debounce = Timer(
                        const Duration(
                          milliseconds: 500,
                        ),
                        () {
                          notifier.applyFilters(
                            jobId: widget.jobId,
                            newKeyword: value,
                            newStatus:
                                selectedStatus == "All"
                                    ? ""
                                    : selectedStatus,
                            newDemoDate:
                                demoDateController
                                        .text
                                        .isEmpty
                                    ? null
                                    : demoDateController.text,
                            newAppointedDate:
                                appointedDateController
                                        .text
                                        .isEmpty
                                    ? null
                                    : appointedDateController
                                        .text,
                            newLimit: selectedLimit,
                          );
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  // ==================================================
                  // STATUS + LIMIT
                  // ==================================================

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
                            setState(() {
                              selectedStatus =
                                  value ?? "All";
                            });

                            _applyCurrentFilters();
                          },
                        ),
                      ),

                      const SizedBox(width: 20),

                      Expanded(
                        child: AppInputField(
                          label: "Limit",
                          type: AppInputType.dropdown,

                          dropdownItems: const [
                            "5",
                            "10",
                            "20",
                            "30",
                          ],

                          value: selectedLimit.toString(),

                          onChanged: (value) {
                            final limit =
                                int.tryParse(
                                      value ?? "10",
                                    ) ??
                                    10;

                            setState(() {
                              selectedLimit = limit;
                            });

                            _applyCurrentFilters();
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // ==================================================
                  // DEMO DATE + APPOINTED DATE
                  // ==================================================

                  Row(
                    children: [
                      Expanded(
                        child: AppInputField(
                          controller:
                              demoDateController,
                          label: "Demo Date",
                          type: AppInputType.date,
                          hint:"mm/dd/yyyy",
                          onChanged: (_) {
                            _applyCurrentFilters();
                          },
                        ),
                      ),

                      const SizedBox(width: 20),

                      Expanded(
                        child: AppInputField(
                          controller:
                              appointedDateController,
                          label: "Appointed Date",
                           hint:"mm/dd/yyyy",
                          type: AppInputType.date,

                          onChanged: (_) {
                            _applyCurrentFilters();
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // ==================================================
                  // CLEAR
                  // ==================================================

                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: "Clear",
                          variant:
                              AppButtonVariant.gradient,

                          onPressed: () {
                            searchController.clear();
                            demoDateController.clear();
                            appointedDateController.clear();

                            setState(() {
                              selectedStatus = "All";
                              selectedLimit = 10;
                            });

                            notifier.applyFilters(
                              jobId: widget.jobId,
                              newStatus: "",
                              newKeyword: "",
                              newDemoDate: null,
                              newAppointedDate: null,
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

            // ======================================================
            // APPLICATION LIST
            // ======================================================

            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        // ==========================================
                        // LOADING SKELETON
                        // ==========================================

                        if (state.isLoading &&
                            state.applications.isEmpty)
                          ListView.builder(
                            itemCount: 6,

                            itemBuilder: (_, __) {
                              return const JobApplicationSkeletonCard();
                            },
                          )

                        // ==========================================
                        // APPLICATIONS
                        // ==========================================

                        else
                          ListView.builder(
                            itemCount:
                                state.applications.length,

                            itemBuilder:
                                (context, index) {
                              final app =
                                  state.applications[index];

                              return Container(
                                margin:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal:
                                      AppSpacing.md,
                                  vertical:
                                      AppSpacing.sm,
                                ),

                                decoration:
                                    BoxDecoration(
                                  color: Colors.white,

                                  borderRadius:
                                      BorderRadius.circular(
                                    16,
                                  ),

                                  border: Border.all(
                                    color:
                                        AppColors.primary01,
                                  ),

                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors
                                          .primary02
                                          .withOpacity(
                                        0.3,
                                      ),
                                      blurRadius: 4,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),

                                child: Padding(
                                  padding:
                                      const EdgeInsets.all(
                                    AppSpacing.md,
                                  ),

                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,

                                    children: [
                                      // =================================
                                      // NAME + STATUS
                                      // =================================

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,

                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                if ((app.tutorCustomId ??
                                                        "")
                                                    .isNotEmpty)
                                                  Text(
                                                    "${app.tutorCustomId} ",
                                                    style:
                                                        AppTextStyles
                                                            .labelMedium
                                                            .copyWith(
                                                      color:
                                                          AppColors
                                                              .primary01,
                                                      fontWeight:
                                                          FontWeight
                                                              .w600,
                                                    ),
                                                  ),

                                                Expanded(
                                                  child:
                                                      Text(
                                                    app.userName,

                                                    overflow:
                                                        TextOverflow
                                                            .ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          Container(
                                            padding:
                                                const EdgeInsets
                                                    .symmetric(
                                              horizontal:
                                                  AppSpacing
                                                      .sm,
                                              vertical: 4,
                                            ),

                                            decoration:
                                                BoxDecoration(
                                              color:
                                                  StatusDataFormatter
                                                      .getJobApplicationStatusColor(
                                                app.status,
                                              ).withOpacity(
                                                0.1,
                                              ),

                                              borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                AppRadius
                                                    .full
                                                    .toDouble(),
                                              ),
                                            ),

                                            child: Text(
                                              app.status
                                                  .toUpperCase(),

                                              style:
                                                  AppTextStyles
                                                      .labelSmall
                                                      .copyWith(
                                                color:
                                                    StatusDataFormatter
                                                        .getJobApplicationStatusColor(
                                                  app.status,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(
                                        height:
                                            AppSpacing.sm,
                                      ),

                                      // =================================
                                      // APPLIED DATE
                                      // =================================

                                      Text(
                                        "Applied: ${DateFormatter.formattedDate(app.appliedOn)}",
                                      ),

                                      const SizedBox(
                                        height:
                                            AppSpacing.sm,
                                      ),

                                      // =================================
                                      // SHORTLISTED + APPOINTED
                                      // =================================

                                      Row(
                                        children: [
                                          Expanded(
                                            child:
                                                IconRow(
                                              icon:
                                                  "assets/icons/status/shortlisted.svg",

                                              title:
                                                  "Shortlisted On",

                                              value:
                                                  app.shortlistedOn !=
                                                          null
                                                      ? DateFormatter
                                                          .formattedDate(
                                                          app.shortlistedOn!,
                                                        )
                                                      : "N/A",
                                            ),
                                          ),

                                          Expanded(
                                            child:
                                                IconRow(
                                              icon:
                                                  "assets/icons/status/appointed.svg",

                                              title:
                                                  "Appointed On",

                                              value:
                                                  app.appointedOn !=
                                                          null
                                                      ? DateFormatter
                                                          .formattedDate(
                                                          app.appointedOn!,
                                                        )
                                                      : "N/A",
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(
                                        height:
                                            AppSpacing.sm,
                                      ),

                                      // =================================
                                      // CONFIRMED + CANCELLED
                                      // =================================

                                      Row(
                                        children: [
                                          Expanded(
                                            child:
                                                IconRow(
                                              icon:
                                                  "assets/icons/status/confirmed.svg",

                                              title:
                                                  "Confirmed On",

                                              value:
                                                  app.confirmedOn !=
                                                          null
                                                      ? DateFormatter
                                                          .formattedDate(
                                                          app.confirmedOn!,
                                                        )
                                                      : "N/A",
                                            ),
                                          ),

                                          Expanded(
                                            child:
                                                IconRow(
                                              icon:
                                                  "assets/icons/status/cancelled.svg",

                                              title:
                                                  "Cancelled On",

                                              value:
                                                  app.rejectedOn !=
                                                          null
                                                      ? DateFormatter
                                                          .formattedDate(
                                                          app.rejectedOn!,
                                                        )
                                                      : "N/A",
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(
                                        height:
                                            AppSpacing.sm,
                                      ),

                                      // =================================
                                      // VIEW CV
                                      // =================================

                                      Align(
                                        alignment:
                                            Alignment
                                                .centerRight,

                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius
                                                  .circular(
                                            8,
                                          ),

                                          onTap: () {
                                            _viewTutorCV(
                                              app.tutorId,
                                            );
                                          },

                                          child: Padding(
                                            padding:
                                                const EdgeInsets
                                                    .symmetric(
                                              horizontal: 8,
                                              vertical: 8,
                                            ),

                                            child: Row(
                                              mainAxisSize:
                                                  MainAxisSize
                                                      .min,

                                              children: [
                                                const Icon(
                                                  Icons
                                                      .visibility_outlined,
                                                  size: 17,
                                                  color: AppColors
                                                      .primary01,
                                                ),

                                                const SizedBox(
                                                  width: 5,
                                                ),

                                                Text(
                                                  "View CV",

                                                  style:
                                                      AppTextStyles
                                                          .labelMedium
                                                          .copyWith(
                                                    color:
                                                        AppColors
                                                            .primary01,
                                                    fontWeight:
                                                        FontWeight
                                                            .w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                        // ==========================================
                        // REFRESH LOADER
                        // ==========================================

                        if (state.isRefreshing)
                          Positioned(
                            top: 12,
                            left: 0,
                            right: 0,

                            child: Center(
                              child: Container(
                                padding:
                                    const EdgeInsets.all(
                                  10,
                                ),

                                decoration:
                                    BoxDecoration(
                                  color: Colors.white,

                                  borderRadius:
                                      BorderRadius.circular(
                                    30,
                                  ),

                                  boxShadow: const [
                                    BoxShadow(
                                      color:
                                          Colors.black12,
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),

                                child: const SizedBox(
                                  width: 20,
                                  height: 20,

                                  child:
                                      CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // ==================================================
                  // PAGINATION
                  // ==================================================

                  if (state.meta != null)
                    Container(
                      padding:
                          const EdgeInsets.all(10),

                      decoration:
                          BoxDecoration(
                        color: Colors.white,

                        boxShadow: [
                          BoxShadow(
                            blurRadius: 4,
                            color: Colors.black
                                .withOpacity(0.1),
                          ),
                        ],
                      ),

                      child: Row(
                        children: [
                          Flexible(
                            child: AppButton(
                              label: "Prev",
                              variant:
                                  AppButtonVariant
                                      .outlineGray,

                              onPressed:
                                  state.meta!.page > 1
                                      ? () {
                                          notifier
                                              .goToPage(
                                            widget.jobId,
                                            state.meta!
                                                    .page -
                                                1,
                                          );
                                        }
                                      : null,
                            ),
                          ),

                          const SizedBox(
                            width: AppSpacing.sm,
                          ),

                          Text(
                            "${state.meta!.page} / ${state.meta!.totalPages}",

                            style:
                                AppTextStyles.labelMedium,
                          ),

                          const SizedBox(
                            width: AppSpacing.sm,
                          ),

                          Flexible(
                            child: AppButton(
                              label: "Next",
                              variant:
                                  AppButtonVariant
                                      .outlineGray,

                              onPressed:
                                  state.meta!.page <
                                          state.meta!
                                              .totalPages
                                      ? () {
                                          notifier
                                              .goToPage(
                                            widget.jobId,
                                            state.meta!
                                                    .page +
                                                1,
                                          );
                                        }
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