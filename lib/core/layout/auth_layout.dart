import 'package:btcclient/core/config/theme.dart';
import 'package:flutter/material.dart';

class AuthLayout extends StatelessWidget {
  final Widget child;
  final String? title;
  final String? subtitle;
  final bool showBack;

  const AuthLayout({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.primary01,
        // decoration: const BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.centerLeft,
        //     end: Alignment.centerRight,
        //     colors: [
        //       AppColors.primaryGradientStart,
        //       AppColors.primaryGradientEnd,
        //     ],
        //     stops: [0.0082, 1],
        //   ),
        // ),
        child: SafeArea(
          child: Column(
            children: [
              // =====================================================
              // TOP BAR
              // =====================================================
              SizedBox(
                height: 48,
                width: double.infinity,
                child: showBack
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 26,
                            ),
                            splashRadius: 22,
                          ),
                        ),
                      )
                    : null,
              ),

              // =====================================================
              // TITLE
              // =====================================================
              if (title != null)
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 250,
                  ),
                  child: Text(
                    title!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge!
                        .copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                  ),
                ),

              // =====================================================
              // SUBTITLE
              // =====================================================
              if (subtitle != null) ...[
                const SizedBox(height: 6),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 270,
                  ),
                  child: Text(
                    subtitle!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          height: 1.5,
                        ),
                  ),
                ),
              ],

              const SizedBox(height: 36),

              // =====================================================
              // CONTENT
              // =====================================================
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: const BoxDecoration(
                    color: AppColors.neutrals01,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: child,
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