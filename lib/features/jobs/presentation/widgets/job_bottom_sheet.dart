import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/utils/category_icon_helper.dart';
import 'package:btcclient/core/utils/date_formatter.dart';
import 'package:btcclient/core/utils/get_appointed_status.dart';
import 'package:btcclient/core/utils/safe.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/core/widgets/reusable_bottom_sheet/reusable_bottom_sheet.dart';
import 'package:btcclient/features/auth/presentation/provider/auth_notifier.dart';
import 'package:btcclient/features/hire_tutor/presentation/provider/post_job_provider.dart';
import 'package:btcclient/features/jobs/data/models/application_modal.dart';
import 'package:btcclient/features/jobs/data/models/applied_model.dart';
import 'package:btcclient/features/jobs/data/models/job_model.dart';
import 'package:btcclient/features/jobs/presentation/enums/job_card_variant.dart';
import 'package:btcclient/features/jobs/presentation/helper/job_apply_helper.dart';
import 'package:btcclient/features/jobs/presentation/provider/applied_jobs_provider.dart';
import 'package:btcclient/features/jobs/presentation/provider/job_provider.dart';
import 'package:btcclient/features/jobs/presentation/widgets/icon_row.dart';
import 'package:btcclient/features/tutor/presentation/screens/tutor_application_screen.dart';
import 'package:btcclient/features/tutor/presentation/tutor_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class JobBottomSheet extends ConsumerStatefulWidget {
  final JobModel job;
  final JobCardVariant variant;
  final ApplicationModel? application;
  final Function(int, {String? status}) changeTab;

  const JobBottomSheet({
    super.key,
    required this.job,
    required this.variant,
    this.application,
    required this.changeTab,
  });
  @override
  ConsumerState<JobBottomSheet> createState() => _JobCardState();
}

class _JobCardState extends ConsumerState<JobBottomSheet> {
  bool _isWithdrawing = false;
  @override
  Widget build(BuildContext context) {
    final job = widget.job;
    final variant = widget.variant;
    final changeTab = widget.changeTab;
    final application = widget.application;
    final user = ref.watch(authProvider).user;
    final iconPath = JobIconHelper.getCategoryIcon(
      category: job.category ?? "",
      className: job.subjects,
      gender: job.preferredTutorGender,
    );
    final serverApplied = user == null
        ? false
        : job.applications?.any((app) => app.userId == user.id) ?? false;

    final overrides = ref.watch(appliedJobsProvider);

    final isApplied = overrides.containsKey(job.id)
        ? overrides[job.id] == ApplicationState.applied
        : serverApplied;
    return ReusableBottomSheet(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: safe(job.title).isEmpty ? "-" : job.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 1.4,
                        color: Colors.black,
                      ),
                    ),
                    if (safe(job.tuitionType).isNotEmpty)
                      TextSpan(
                        text: " — ${job.tuitionType}",
                        style: const TextStyle(
                          color: AppColors.primary01,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              if (variant == JobCardVariant.application && application != null)
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/visual/status.svg",
                      height: 16,
                    ),
                    const SizedBox(width: 6),

                    Text("Status :"),
                    const SizedBox(width: 8),
                    Text(
                      StatusDataFormatter.getApplicationStatus(
                        applicationStatus: application?.status,
                        jobStatus: job.status,
                      ),
                      style: TextStyle(
                        color: StatusDataFormatter.getApplicationStatusColor(
                          applicationStatus: application?.status,
                          jobStatus: job.status,
                        ),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

              const SizedBox(width: 20),

              if (variant == JobCardVariant.postedJob)
                Row(
                  children: [
                    /// DETAILS
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/visual/status.svg",
                          height: 16,
                        ),
                        const SizedBox(width: 6),

                        Text("Status :"),
                        const SizedBox(width: 8),
                        Text(
                          job.status ?? "",
                          style: TextStyle(
                            color: StatusDataFormatter.getStatusColorGuardian(
                              application?.status,
                            ),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(width: 20),

                    GestureDetector(
                      onTap: () {
                        // TODO: handle click (open applications list, etc.)
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/navigations/confirmed.svg",
                              height: 16,
                              width: 16,
                              color: AppColors.primary01,
                            ),
                            const SizedBox(width: 4),
                            const Text("Applications"),
                            const SizedBox(width: 4),
                            Text(
                              "(${job.applications?.length ?? 0})",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    /// APPLY BUTTON
                  ],
                ),

              const SizedBox(height: 6),

              const SizedBox(height: 6),

              Text(
                "Job Id : ${safe(job.jobId)}    Posted Date : ${DateFormatter.formattedDate(job.createdAt.toString())}",
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 10),

              Center(child: SvgPicture.asset(iconPath, height: 100)),

              const SizedBox(height: 6),

              const SizedBox(height: 16),

              /// ================= SUBJECTS =================
              IconRow(
                icon: "assets/icons/visual/subject.svg",
                title: "Subjects",
                value: safe(job.subjects?.join(", ")),
              ),

              const SizedBox(height: 12),

              /// ================= DAYS + SALARY =================
              Row(
                children: [
                  Expanded(
                    child: IconRow(
                      icon: "assets/icons/visual/tutoringDays.svg",
                      title: "Tutoring Days",
                      value: safe(job.tutoringDays),
                    ),
                  ),
                  Expanded(
                    child: IconRow(
                      icon: "assets/icons/visual/salary.svg",
                      title: "Salary",
                      value: (job.salary != null && job.salary!.isNotEmpty)
                          ? "${job.salary} BDT"
                          : "-",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// ================= GENDER =================
              Row(
                children: [
                  Expanded(
                    child: IconRow(
                      icon: "assets/icons/visual/gender.svg",
                      title: "Student Gender",
                      value: safe(job.studentGender),
                    ),
                  ),
                  Expanded(
                    child: IconRow(
                      icon: job.preferredTutorGender == "male"
                          ? "assets/icons/visual/male.svg"
                          : job.preferredTutorGender == "female"
                          ? "assets/icons/visual/prefered-tutor.svg"
                          : "assets/icons/visual/gender.svg",
                      title: "Prefer Tutor",
                      value: safe(
                        job.preferredTutorGender == "male"
                            ? "Male"
                            : job.preferredTutorGender == "female"
                            ? "Female"
                            : "Other",
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: IconRow(
                      icon: "assets/icons/visual/number_of_students.svg",
                      title: "No. of Students",
                      value: safe(job.numberOfStudents),
                    ),
                  ),
                  Expanded(
                    child: IconRow(
                      icon: "assets/icons/visual/time.svg",
                      title: "Tutoring Time",
                      value: safe(job.tutoringTime),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// ================= LOCATION =================
              IconRow(
                icon: "assets/icons/visual/location2.svg",
                title: "Location",
                value: safe(
                  "${job.address ?? ""}, ${job.area?.join(", ") ?? "-"}-${job.city?.join(", ") ?? "-"}",
                ),
              ),
              const SizedBox(height: 12),

              /// ================= LOCATION =================
              IconRow(
                icon: "assets/icons/visual/requirements.svg",
                title: "Other Requirements",
                value: safe("${job.otherRequirements ?? ""} "),
              ),

              const SizedBox(height: 16),

              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  spacing: AppSpacing.md,
                  children: [
                    Expanded(
                      child: AppButton(
                        label: "Direction",
                        onPressed: () async {
                          final url = job.locationDirection;

                          if (url == null || url.isEmpty) {
                            debugPrint("URL is empty");
                            return;
                          }

                          final uri = Uri.parse(url);

                          try {
                            await launchUrl(
                              uri,
                              mode: LaunchMode
                                  .externalApplication, // 🔥 IMPORTANT
                            );
                          } catch (e) {
                            debugPrint("Launch failed: $e");
                          }
                        },
                        variant: AppButtonVariant.outlineGray,
                        height: 40,
                        width: 120,
                      ),
                    ),

                    /// APPLY BUTTON
                    if (variant != JobCardVariant.postedJob &&
                        job.status != "confirmed" &&
                        application?.status != "rejected" &&
                        application?.status != "confirmed" &&
                        application?.status != "appointed") ...[
                      Expanded(
                        child: AppButton(
                          label: isApplied ? "Undo Apply" : "Apply",
                          loading: _isWithdrawing,
                          iconPosition: isApplied
                              ? AppButtonIconPosition.left
                              : AppButtonIconPosition.right,
                          onPressed: _isWithdrawing
                              ? null
                              : () async {
                                  final user = ref.read(authProvider).user;

                                  if (user == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Please login first"),
                                      ),
                                    );
                                    return;
                                  }

                                  try {
                                    if (isApplied) {
                                      // 🔥 WITHDRAW FLOW

                                      final application = job.applications
                                          ?.where(
                                            (app) => app.userId == user?.id,
                                          )
                                          .cast<AppliedModel?>()
                                          .firstOrNull;
                                      if (application == null) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Application not found",
                                            ),
                                          ),
                                        );
                                        return;
                                      }
                                      setState(() => _isWithdrawing = true);
                                      final success = await ref
                                          .read(jobsProvider.notifier)
                                          .withdrawApplication(
                                            applicationId:
                                                application.applicationId!,
                                          );

                                      if (success) {
                                        ref
                                            .read(appliedJobsProvider.notifier)
                                            .withdraw(job.id);
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Withdraw successful",
                                            ),
                                          ),
                                        );
                                        setState(() => _isWithdrawing = false);
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text("Withdraw failed"),
                                          ),
                                        );
                                      }
                                    } else {
                                      // 🔥 APPLY FLOW

                                      await showApplyConfirmation(
                                        context: context,
                                        onApply: (dialogContext) async {
                                          final success = await ref
                                              .read(jobsProvider.notifier)
                                              .applyJob(
                                                jobId: job.id!,
                                                userId: user.id,
                                              );

                                          if (success) {
                                            ref
                                                .read(
                                                  appliedJobsProvider.notifier,
                                                )
                                                .apply(job.id);
                                            Navigator.pop(dialogContext);

                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "Applied successfully",
                                                ),
                                              ),
                                            );

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    MyApplicationPage(
                                                      changeTab: changeTab,
                                                    ),
                                              ),
                                            );
                                          }
                                        },
                                      );
                                    }
                                  } catch (e) {
                                    print("❌ ERROR: $e");

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Something went wrong"),
                                      ),
                                    );
                                  }
                                },
                          variant: AppButtonVariant.gradient,
                          height: 40,
                          width: 160,
                          icon: isApplied ? Icons.undo : Icons.arrow_forward,
                        ),
                      ),
                    ],
                    if (variant == JobCardVariant.postedJob) ...[
                      Expanded(
                        child: AppButton(
                          label: "Edit Job",
                          onPressed: () {
                            ref.read(postJobProvider.notifier).setEditData({
                              "_id": job.id,
                              "tuitionType": job.tuitionType,
                              "category": job.category,
                              "curriculum": job.curriculum,
                              "class": job.classes,
                              "subjects": job.subjects,
                              "tutoringDays": job.tutoringDays,
                              "tutoringTime": job.tutoringTime,
                              "salary": job.salary,
                              "studentGender": job.studentGender,
                              "preferredTutorGender": job.preferredTutorGender,
                              "numberOfStudents": job.numberOfStudents,
                              "studentsInstituteName": job.instituteName,
                              "otherRequirements": job.otherRequirements,
                              "city": job.city,
                              "area": job.area,
                              "address": job.address,
                            });

                            Navigator.pop(context); // 🔥 CLOSE SHEET FIRST

                            changeTab(1); // 🔥 SWITCH TAB
                          },
                          variant: AppButtonVariant.gradient,
                          height: 40,
                          width: 160,
                          icon: Icons.edit,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
