import 'package:flutter/material.dart';
import 'package:btcclient/features/auth/data/models/tutor_model.dart';
import 'package:btcclient/features/profile/presentation/widgets/shared/profile_info_row.dart';

class EducationItemCard extends StatefulWidget {
  final Education education;
  final VoidCallback? onEdit;

  const EducationItemCard({
    super.key,
    required this.education,
    this.onEdit,
  });

  @override
  State<EducationItemCard> createState() => EducationItemCardState();
}

class EducationItemCardState extends State<EducationItemCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final education = widget.education;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              setState(() {
                expanded = !expanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xffEDF4FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.school_outlined,
                      color: Color(0xff246BFD),
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          education.level.isEmpty
                              ? "Education"
                              : education.level,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          education.institute.isEmpty
                              ? "Institute not added"
                              : education.institute,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          education.passingYear!=null?
                               ""
                              : "Passing Year • ${education.passingYear}",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (widget.onEdit != null)
                    IconButton(
                      onPressed: widget.onEdit,
                      icon: const Icon(Icons.edit_outlined),
                    ),

                  AnimatedRotation(
                    turns: expanded ? .5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: const Icon(Icons.keyboard_arrow_down),
                  ),
                ],
              ),
            ),
          ),

          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
              child: Column(
                children: [
                  const Divider(),

                  const SizedBox(height: 12),

                  ProfileInfoRow(
                    label: "Level",
                    value: education.level,
                  ),

                  ProfileInfoRow(
                    label: "Institute",
                    value: education.institute,
                  ),

                  ProfileInfoRow(
                    label: "Board",
                    value: education.board,
                  ),

                  ProfileInfoRow(
                    label: "Curriculum",
                    value: education.curriculum,
                  ),

                  ProfileInfoRow(
                    label: "Department",
                    value: education.department,
                  ),

                  ProfileInfoRow(
                    label: "Semester",
                    value: education.semester,
                  ),

                  ProfileInfoRow(
                    label: "Result",
                    value: education.result,
                  ),

                  ProfileInfoRow(
                    label: "Passing Year",
                    value: education.passingYear,
                  ),

                  ProfileInfoRow(
                    label: "Current Institute",
                    value: education.institute,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}