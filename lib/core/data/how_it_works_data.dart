import 'package:btcclient/core/models/how_it_works_model.dart';
import 'package:flutter/material.dart';

/// ✅ TUTOR FLOW
final List<HowItWorksStep> tutorSteps = [
  HowItWorksStep(
    step: "Step 1",
    title: "Create Your Free Account",
    description: "Click the 'Become A Tutor' button & fill out all required information.",
    icon: Icons.person_add,
  ),
  HowItWorksStep(
    step: "Step 2",
    title: "Complete Your Profile Setup",
    description: "Complete your profile by including your personal, educational and tuition-related details along with any necessary documentation.",
    icon: Icons.edit,
  ),
  HowItWorksStep(
    step: "Step 3",
    title: "Apply To Your Preferred Jobs",
    description: "Check the job board regularly and apply for your preferred tuition jobs.",
    icon: Icons.work,
  ),
  HowItWorksStep(
    step: "Step 4",
    title: "Get Shortlisted by Guardians/Students",
    description: "Be shortlisted by guardians/students based on the information provided in your profile.",
    icon: Icons.group,
  ),
  HowItWorksStep(
    step: "Step 5",
    title: "Start Your Tutoring Journey",
    description: "Take trial classes to confirm your desired tuition job and teaching.",
    icon: Icons.play_circle,
  ),
];

/// ✅ GUARDIAN FLOW
final List<HowItWorksStep> guardianSteps = [
  HowItWorksStep(
    step: "Step 1",
    title: "Request A Tutor",
    description: "Fill out a simple form with your subject, class, location and preferred tutoring method. It takes less than 2 minutes!",
    icon: Icons.post_add,
  ),
  HowItWorksStep(
    step: "Step 2",
    title: "Receive the Best Tutor CVs",
    description: "Within 24 hours, you will get up to 3 CVs of the best tutors who applied your posted tuition job.",
    icon: Icons.search,
  ),
  HowItWorksStep(
    step: "Step 3",
    title: "Chose the Right One",
    description: "Browse tutor profiles, compare experience, read reviews and select the best tutor from the shortlist.",
    icon: Icons.check_circle,
  ),
  HowItWorksStep(
    step: "Step 4",
    title: "Get Started Learning",
    description: "Confirm your tutor by verifying their experience through trial classes and start learning.",
    icon: Icons.school,
  ),
];