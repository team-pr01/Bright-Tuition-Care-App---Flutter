import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/utils/category_icon_helper.dart';
import 'package:btcclient/core/utils/date_formatter.dart';
import 'package:btcclient/core/utils/safe.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/core/widgets/reusable_bottom_sheet/reusable_bottom_sheet.dart';
import 'package:btcclient/features/auth/presentation/provider/auth_notifier.dart';
import 'package:btcclient/features/jobs/data/models/application_model.dart';
import 'package:btcclient/features/jobs/data/models/job_model.dart';
import 'package:btcclient/features/jobs/presentation/provider/jobs_notifier.dart';
import 'package:btcclient/features/jobs/presentation/widgets/icon_row.dart';
import 'package:btcclient/features/tutor/presentation/tutor_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class JobBottomSheet extends ConsumerWidget {
  final JobModel job;

  const JobBottomSheet({super.key, required this.job});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final iconPath = JobIconHelper.getCategoryIcon(
      category: job.category ?? "",
      className: job.subjects,
      gender: job.preferredTutorGender,
    );
    final isApplied = user == null
        ? false
        : job.applications?.any((app) => app.userId == user.id) ?? false;
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
                      value: safe(job.salary),
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
                      title: "Tutoring Days",
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
                      value: safe(job.preferredTutorGender),
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

              const SizedBox(height: 16),

              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  spacing: AppSpacing.lg,
                  children: [
                    AppButton(
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
                            mode: LaunchMode.externalApplication, // 🔥 IMPORTANT
                          );
                        } catch (e) {
                          debugPrint("Launch failed: $e");
                        }
                      },
                      variant: AppButtonVariant.outlineGray,
                      height: 40,
                      width: 120,
                    ),
                      /// APPLY BUTTON
              AppButton(
                label: isApplied ? "Undo Apply" : "Apply",
                onPressed: () async {
                  final user = ref.read(authProvider).user;

                  if (user == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please login first")),
                    );
                    return;
                  }

                  try {
                    if (isApplied) {
                      // 🔥 WITHDRAW FLOW

                      final application = job.applications
                          ?.where((app) => app.userId == user?.id)
                          .cast<ApplicationModel?>()
                          .firstOrNull;
                      if (application == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Application not found"),
                          ),
                        );
                        return;
                      }

                      final success = await ref
                          .read(jobsProvider.notifier)
                          .withdrawApplication(
                            applicationId: application.applicationId!,
                          );

                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Withdraw successful")),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Withdraw failed")),
                        );
                      }
                    } else {
                      // 🔥 APPLY FLOW

                      final success = await ref
                          .read(jobsProvider.notifier)
                          .applyJob(jobId: job.id!, userId: user.id);

                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Applied successfully")),
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TutorDashboardScreen(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Failed to apply")),
                        );
                      }
                    }
                  } catch (e) {
                    print("❌ ERROR: $e");

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Something went wrong")),
                    );
                  }
                },
                variant: AppButtonVariant.gradient,
                height: 40,
                width: 160,
                icon: isApplied ? Icons.undo : Icons.arrow_forward,
              ),
            
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
