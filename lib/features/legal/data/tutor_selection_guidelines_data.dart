import 'package:btcclient/features/legal/data/models/imprtant_guideline.dart';

const ImportantGuidelinesData tutorSelectionGuidelinesData =
    ImportantGuidelinesData(
  title: "Important Guidelines for Tutor Selection",
  sections: [

    /// Introduction
    ImportantGuidelineSection(
      title: "Introduction",
      description: """
Bright Tuition Care is a reliable platform that connects guardians and students with tutors who meet their specific requirements.

Our processes for tutor shortlisting, appointment and confirmation are conducted systematically to maintain high-quality standards.

While we verify tutor information related to tuition opportunities, we encourage users to independently review tutor profiles if they have any concerns.

Bright Tuition Care is not liable for any behavioral issues or incidents involving selected tutors.
""",
    ),

    /// Before Selecting a Tutor
    ImportantGuidelineSection(
      title: "Before Selecting a Tutor",
      description: """
Initiate a conversation with the appointed tutor via phone to discuss your requirements in detail.
""",
    ),

    /// Review Tutor Profiles
    ImportantGuidelineSection(
      title: "Review Tutor Profiles",
      points: [
        "After selecting tutors that match your requirements, carefully review their profiles to ensure they meet your expectations.",
        "This step helps confirm that your shortlisted tutors align with your learning objectives.",
      ],
    ),

    /// Communicate with the Tutor
    ImportantGuidelineSection(
      title: "Communicate with the Tutor",
      points: [
        "Initiate a conversation with the appointed tutor via phone to discuss your requirements in detail.",
        "For home tutoring, meetings can be arranged at your home or a mutually convenient location.",
        "For online, group or package tutoring, connect through video calls to discuss your needs and expectations clearly.",
      ],
    ),

    /// Review Suitability
    ImportantGuidelineSection(
      title: "Review the Tutor's Suitability",
      points: [
        "Assess the tutor’s knowledge, communication style and suitability for your required subject during your interaction.",
        "If you have any questions or require assistance, feel free to reach out to our support team at 09617-785588.",
      ],
      note: "Note: Communicate respectfully to ensure a positive interaction and an effective assessment of the tutor.",
    ),

    /// After Selecting a Tutor
    ImportantGuidelineSection(
      title: "After Selecting a Tutor",
      description: """
While Bright Tuition Care verifies tutor profiles for authenticity, you may also request a photocopy of the tutor’s most recent educational qualification documents for your records. Keeping this documentation is recommended for as long as the tutor continues to teach your child.

Thank you for choosing Bright Tuition Care — where your child’s learning is supported with quality, safety and professionalism.

We wish you a successful and rewarding tutoring experience.
""",
    ),

  ],
);