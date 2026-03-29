import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/utils/category_icon_helper.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../data/models/job_model.dart';

class JobCard extends StatelessWidget {
  final JobModel job;
  final VoidCallback? onApply;
  final VoidCallback? onDetails;

  const JobCard({super.key, required this.job, this.onApply, this.onDetails});

  String safe(dynamic value) {
    if (value == null) return "-";
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final iconPath = JobIconHelper.getCategoryIcon(
      category: job.category ?? "",
      className: job.subjects,
      gender: job.preferredTutorGender,
    );

    print("ICON PATH => $iconPath");
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary01),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary02,
            blurRadius: 0.2,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ================= HEADER =================
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: RichText(
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
              ),

              /// RIGHT ILLUSTRATION (optional)
              ///
              SvgPicture.asset("$iconPath", height: 50),
            ],
          ),

          const SizedBox(height: 6),

          /// META
          Text(
            "Job Id : ${safe(job.jobId)}    Posted Date : ${_formatDate(job.createdAt)}",
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          ),

          const SizedBox(height: 16),

          /// ================= SUBJECTS =================
          _iconRow(
              context: context,
            icon: "assets/icons/visual/subject.svg",
            title: "Subjects",
            value: job.subjects?.join(", "),
          ),

          const SizedBox(height: 12),

          /// ================= DAYS + SALARY =================
          Row(
            children: [
              Expanded(
                child: _iconRow(
                    context: context,
                  icon: "assets/icons/visual/tutoringDays.svg",
                  title: "Tutoring Days",
                  value: job.tutoringDays,
                ),
              ),
              Expanded(
                child: _iconRow(
                    context: context,
                  icon: "assets/icons/visual/salary.svg",
                  title: "Salary",
                  value: job.salary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// ================= GENDER =================
          _iconRow(
              context: context,
            icon: job.preferredTutorGender == "male"
                ? "assets/icons/visual/male.svg"
                : job.preferredTutorGender == "female"
                ? "assets/icons/visual/prefered-tutor.svg"
                : "assets/icons/visual/gender.svg",
            title: "Prefer Tutor",
            value: job.preferredTutorGender,
          ),

          const SizedBox(height: 12),

          /// ================= LOCATION =================
          _iconRow(
              context: context,
            icon: "assets/icons/visual/location2.svg",
            title: "Location",
            value: "${job.address ?? ""}, ${job.area ?? ""}-${job.city ?? ""}",
          ),

          const SizedBox(height: 16),

          /// ================= FOOTER =================
          Row(
            children: [
              /// DETAILS
              GestureDetector(
                onTap: onDetails,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/operations/job-details.svg",
                      height: 16,
                    ),
                    const SizedBox(width: 6),
                    const Text("Details"),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: onDetails,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/visual/send.svg",
                      height: 16,
                      color: AppColors.neutrals02,
                    ),
                    const SizedBox(width: 6),
                    const Text("Share"),
                  ],
                ),
              ),

              const SizedBox(width: 20),

              /// SHARE
              SvgPicture.asset("assets/icons/job/share.svg", height: 16),

              const Spacer(),

              /// APPLY BUTTON
              AppButton(
                label: "Apply",
                onPressed: onApply,
                variant: AppButtonVariant.gradient,
                height: 40,
                width: 150, // important: don't make it full width in row
                icon: Icons.arrow_forward,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ================= REUSABLE ROW =================
  Widget _iconRow({
    required BuildContext context,
    required String icon,
    required String title,
    String? value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(icon, height: 18, color: AppColors.primary01),
        const SizedBox(width: 8),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 12, color: AppColors.neutrals03),
              ),
              const SizedBox(height: 2),
              Text(
                value ?? "-",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: AppColors.neutrals02,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "-";
    return "${date.day} ${_month(date.month)}, ${date.year}";
  }

  String _month(int m) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return months[m - 1];
  }
}
