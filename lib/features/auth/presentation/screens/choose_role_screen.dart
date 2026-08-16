import 'package:btcclient/core/widgets/navbar/common_appbar.dart';
import 'package:btcclient/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';

class ChooseRoleScreen extends StatelessWidget {
  const ChooseRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FC),

      appBar: CommonAppBar(title: "Choose Role", showNotification: false),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // =====================================================
              // TUTOR
              // =====================================================
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(role: "tutor"),
                    ),
                  );
                },
                child: Container(
                  height: 110,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // IMAGE
                      Container(
                        width: 78,
                        height: 78,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE8F3FA),
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Image.asset(
                            "assets/images/teacher.webp",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      // TEXT
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Tutor",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF333333),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Join as tutor and find tuition jobs",
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.35,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF929292),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // =====================================================
              // GUARDIAN / STUDENT
              // =====================================================
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(role: "guardian"),
                    ),
                  );
                },
                child: Container(
                  height: 110,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // TEXT
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Guardian or Student",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF333333),
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Get started as a Guardian/Student",
                                style: TextStyle(
                                  fontSize: 16,
                                  height: 1.35,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF929292),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      // IMAGE
                      Container(
                        width: 78,
                        height: 78,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE8F3FA),
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Image.asset(
                            "assets/images/guardians.webp",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
