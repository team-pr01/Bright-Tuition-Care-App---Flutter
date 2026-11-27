import 'models/legal_document.dart';

const LegalDocument termsDocument = LegalDocument(
  title: "Acceptance of Terms of Use",
  sections: [
    LegalSection(
      title: "Acceptance of Terms of Use",
      description: """Welcome to Bright Tuition Care. Before using the Bright Tuition Care platform (website, mobile app or related services), you must read and agree to these Terms of Use. Your continued use of the platform indicates that you fully understand and accept all provisions outlined herein.

We reserve the right to modify, update or replace these Terms of Use at any time. Any changes will be posted under the “Terms & Conditions” section of our platform. The revised terms will take effect immediately upon publication.""",
      content: [
        "To ensure transparency, we will inform users of any updates through:",
      ],
      points: [
        "Our official social media pages",
        "Email notifications to registered users",
        "The “Notice Board” in the user’s account dashboard",
      ],
      note: "After updates are published, you will be required to review and agree to the revised Terms of Use before continuing to use the Bright Tuition Care platform. If you do not agree with the updated terms, you must discontinue use of our services immediately.",
    ),

    LegalSection(
      title: "1. Role of Bright Tuition Care",
      points: [
        "Bright Tuition Care is a tutor–guardian matching marketplace",
        "We verify tutor profiles to the best of our ability but we do not control their teaching quality, behavior or results",
        "All tuition arrangements are private agreements between tutors and guardians/students.",
        "We are not responsible for any disputes, misconduct or outcomes from tuition engagements.",
        "Use the platform at your own risk.",
      ],
    ),

    LegalSection(
      title: "2. Membership Eligibility",
      content: [
        "Requirements:",
      ],
      points: [
        "Must be 18 years or older to register",
        "Minors (under 18) may only use the platform through a guardian’s account.",
      ],
      subsections: [
        LegalSubsection(
          title: "Users must:",
          points: [
            "Provide accurate, current and complete information.",
            "Keep your account login details secure.",
            "Update your information when necessary.",
            "Accept responsibility for all activities conducted under your account.",
          ],
        ),
      ],
    ),

    LegalSection(
      title: "3. For Tutors",
      subsections: [
        LegalSubsection(
          title: "3.1 General Responsibilities",
          points: [
            "Respond promptly to tuition offers and act professionally.",
            "Share proof of qualifications if requested by guardians/students.",
            "Complete the agreed tutoring service as per confirmed details.",
            "Maintain respectful and ethical conduct at all times.",
          ],
        ),
        LegalSubsection(
          title: "3.2 Charges & Payments",
          description: "Bright Tuition Care does not charge any fee for creating a tutor account initially. However, two types of charges may apply to tutors:",
          content: [
            "Verification Fee (One-time):",
            "A one-time, non-refundable fee of BDT 500 is required for the tutor verification process. If a tutor changes their current address after verification, they must request to verification new present address free of charge.",
            "Platform Charge (Per Job):",
          ],
          points: [
            "For each confirmed tuition job (Home Tutoring, Online Tutoring, Package Tutoring, Group Tutoring), a one-time service fee of 60% of the tutor’s first month’s salary is charged. This amount must be paid within 10 days of confirmation.",
            "Short-term tuition jobs (2–3 months) will have the service charge percentage determined through mutual negotiation.",
            "Verified tutors may pay the platform charge after receiving the first month’s payment.",
            "For online tutoring, the service charge remains 60%. The full first month’s salary is collected in advance from the guardian/student. After the first month ends, the service charge is deducted and the remaining amount is transferred to the tutor.",
            "From the second month onward, the guardian/student will pay the tutor directly in advance within the first week of each month.",
          ],
        ),
        LegalSubsection(
          title: "3.3 Refunds for Tutors",
          description: "At Bright Tuition Care, we maintain a clear and fair refund policy for our tutors. If a tutor loses a tuition job for a valid reason, they may apply for a partial refund of the paid service charge under the following conditions:",
          points: [
            "If the tuition job is cancelled due to any valid reason.",
            "Refund Amount: 30% of the paid 60% service charge if cancelled within first month.",
            "The tutor must inform our team within 24 hours of cancelling the tuition job by calling 09617-785588",
            "If the cancellation is due to the tutor’s fault, no refund will be issued.",
          ],
        ),
      ],
    ),

    LegalSection(
      title: "4. For Guardians/Students",
      subsections: [
        LegalSubsection(
          title: "4.1 Guardians and Students (Requesting Service)",
          points: [
            "You must be legally eligible to request tutoring services on Bright Tuition Care. All service requests must include clear and accurate descriptions and be posted in the appropriate category.",
            "Bright Tuition Care verifies tutor profiles for authenticity; however, we are not liable for any illegal or anti-social behavior (such as theft, threats, abuse, harassment or other misconduct) committed by tutors. Guardians and students are advised to obtain copies of tutors educational qualifications for their own records.",
            "Bright Tuition Care is not responsible for disputes or results.",
            "Bright Tuition Care does not take responsibility for any behavioral issues caused by hired tutors. The continuation or discontinuation of tuition services is solely at the discretion of the tutor.",
            "Registering as a guardian or student and posting tutor requests on Bright Tuition Care is free of charge. Providing detailed information in your tutor request helps attract suitable tutors. All requests are verified by our consultants before being published on the job board.",
            "Tutors cannot guarantee specific academic results. Therefore, achieving or not achieving certain grades does not justify refund claims.",
            "Bright Tuition Care is not responsible for disputes, disagreements or miscommunications between guardians, students and tutors. However, we encourage both parties to seek our feedback and support for amicable resolutions.",
            "Students are expected to behave respectfully and responsibly in accordance with general educational norms.",
            "Guardians and students should exercise due diligence and careful judgment when hiring tutors to minimize risks. Bright Tuition Care is not liable for unforeseen incidents including but not limited to physical injury, harassment or mental distress.",
            "Tutoring services for guardians or students residing abroad are available only if there is a local relative in Bangladesh who can facilitate payments and coordination.",
          ],
        ),
        LegalSubsection(
          title: "4.2 Payments",
          points: [
            "Free to hire through Bright Tuition Care",
            "For physical tutoring (Home, Group, Package) — pay the tutor directly.",
            "For online tutoring — 100% advance payment to Bright Tuition Care for the first month.",
            "Overseas guardians/students must have a local relative in Bangladesh to handle the first month’s payment.",
          ],
        ),
        LegalSubsection(
          title: "4.3 Disclaimer",
          points: [
            "Bright Tuition Care is not responsible for grades, learning outcomes or tutor behavior.",
            "Any misconduct, criminal acts or disputes are solely between tutor and guardian/student.",
          ],
        ),
      ],
    ),

    LegalSection(
      title: "5. Ban Policy",
      description: "We may temporarily or permanently ban users (tutors or guardians/students) for the following reasons:",
      subsections: [
        LegalSubsection(
          title: "Tutors can be banned for:",
          points: [
            "Failure to cooperate consistently with the platform",
            "Misconduct or inappropriate behavior toward female students or guardians",
            "Violating platform rules or providing false information",
            "Engaging in harmful, unethical or disruptive activities involving the platform, students or guardians",
            "Causing disputes after signing the confirmation letter",
          ],
        ),
        LegalSubsection(
          title: "Guardians/Students can be banned for:",
          points: [
            "Failure to cooperate consistently with the platform",
            "Misconduct toward tutors, especially female tutors",
            "Engaging in harmful, unethical or disruptive activities with the platform or tutors",
            "Causing disputes after signing the confirmation letter",
          ],
        ),
      ],
      note: "Banned users cannot post or apply for tuition jobs until the ban is lifted.",
    ),

    LegalSection(
      title: "6. Information & Privacy",
      description: "When you create an account, post a request or share any details on Bright Tuition Care, you must provide true, correct and up-to-date information.",
      points: [
        "Users must provide truthful and lawful information.",
        "You grant Bright Tuition Care the right to use your information as per Privacy Policy.",
        "You may request account deletion.",
        "The use of bots or any form of automated access is strictly prohibited.",
        "We may suspend accounts for violations.",
      ],
      note: "If you post something on our platform, you give us permission to use it (within our Privacy Policy) so we can operate and improve our services. We may suspend or close your account if you break these rules or interfere with other users. Using bots or automated tools to access our platform without permission is not allowed.",
    ),

    LegalSection(
      title: "7. App Permissions",
      description: "The Bright Tuition Care app requires certain permissions on Android/IOS devices to operate effectively. These permissions allow the app to access specific system features and securely store user data. Storing personal information helps us deliver a customized and improved app experience tailored to each user’s needs.",
    ),

    LegalSection(
      title: "8. Notifications",
      description: "Bright Tuition Care may contact you via phone calls, emails, SMS and push notifications for job alerts, updates and service-related information.",
    ),

    LegalSection(
      title: "9. Breach of Terms",
      description: "We may suspend or terminate your account if you:",
      points: [
        "Breach these Terms.",
        "Provide unverifiable or false information.",
        "Engage in actions that may cause harm, financial loss or legal issues.",
      ],
    ),

    LegalSection(
      title: "10. Liability Limitations",
      description: "Bright Tuition Care is not liable for:",
      points: [
        "Loss of income, opportunities or damages from tutor–student engagements.",
        "Interruptions or technical errors in our platform.",
      ],
    ),

    LegalSection(
      title: "11. Copyright & Intellectual Property",
      description: "All content on Bright Tuition Care is protected by copyright laws. Reproduction, resale or exploitation is prohibited without permission. Repeat copyright violations may lead to account termination.",
    ),

    LegalSection(
      title: "12. General Provisions",
      points: [
        "Bright Tuition Care does not guarantee uninterrupted or error-free service.",
        "Use of the platform for illegal, harmful or fraudulent activities is strictly prohibited.",
        "We reserve the right to refuse service to anyone for valid reasons.",
      ],
    ),
  ],
);