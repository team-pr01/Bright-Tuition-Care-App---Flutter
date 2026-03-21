

import 'package:btcclient/features/legal/data/models/imprtant_guideline.dart';

const ImportantGuidelinesData importantGuidelinesData =
    ImportantGuidelinesData(
  title: "Important Notes for Tutors",
  sections: [

    ImportantGuidelineSection(
      title: "Important Notes for Tutors",
      description: """
At Bright Tuition Care, we prioritize the safety and professionalism of our tutors. As a home tutor, being prepared and aware of potential risks is crucial to ensuring your safety during tutoring sessions. Anticipate possible scenarios and take proactive measures to protect yourself.
""",
    ),

    ImportantGuidelineSection(
      title: "Safety Guidelines for Home Tutors",
      points: [
        "Once a tuition job is confirmed, promptly contact the student or guardian by phone.",
        "For your first meeting, take a trusted family member or guardian along.",
        "Always inform someone you trust about your destination, including the student's name and address.",
        "Plan your route carefully and ensure you know the directions to the student’s home.",
        "Observe the environment closely for any potential safety concerns.",
        "Collect relevant information about the guardian and student beyond just compensation.",
        "Keep your family informed about your tutoring schedule and expected return time.",
        "If you encounter any uncomfortable or unsafe situation, discontinue tutoring immediately.",
        "Trust your instincts during conversations and meetings. If anything feels off, avoid the situation.",
      ],
      note: """
Special Note: Bright Tuition Care is a marketplace that facilitates tuition job postings requested by guardians or students. Although we carefully verify requests, we are not responsible for any incidents related to your tutoring services. Your personal safety is your responsibility.
""",
    ),

    ImportantGuidelineSection(
      title: "Tips for Tutors to Excel in Teaching",
      points: [
        "Passion is key to effective teaching, even if you lack experience.",
        "Communicate openly with parents, especially if the student is not responsive.",
        "Maintain consistency in your tutoring schedule.",
        "Build rapport with students to encourage engagement.",
        "Encourage active participation through reading and comprehension.",
        "Switch subjects or give short breaks when attention drops.",
      ],
    ),

    ImportantGuidelineSection(
      title: "Best Practices When Meeting Parents",
      points: [
        "First impressions matter — always smile and be approachable.",
        "Dress professionally and appropriately.",
        "Arrive on time for meetings and sessions.",
        "Maintain polite and respectful communication.",
      ],
    ),

    ImportantGuidelineSection(
      title: "How to Become a Successful Tutor",
      points: [
        "Know your students and create a comfortable learning environment.",
        "Be patient and allow students to learn at their own pace.",
        "Be punctual and prepared with materials.",
        "Be a good listener and understand student needs.",
        "Offer specific praise to encourage students.",
        "Make learning engaging and relatable.",
        "Teach students to become independent learners.",
        "Be honest—admit when you don’t know something and follow up later.",
      ],
    ),

  ],
);