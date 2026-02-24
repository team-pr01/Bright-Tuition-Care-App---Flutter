import 'package:btcclient/core/widgets/dev_reset_button.dart';
import 'package:btcclient/features/auth/provider/auth_notifier.dart';
import 'package:btcclient/features/guardian/presentation/guardian_dashboard_screen.dart';
import 'package:btcclient/features/tutor/presentation/tutor_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/theme.dart';
import 'core/routing/app_start_provider.dart';
import 'features/auth/presentation/welcome_screen.dart';

import 'features/splash/splash_screen.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startState = ref.watch(appStartProvider);
    final authState = ref.watch(authProvider);

    Widget screen = const SplashScreen();

    switch (startState) {
      case AppStartState.loading:
        screen = const SplashScreen();
        break;

      case AppStartState.welcome:
        screen = const WelcomeScreen();
        break;

      // case AppStartState.login:
      //   screen = const LoginScreen();
      //   break;

      // case AppStartState.register:
      //   screen = const RegisterScreen();
      //   break;

      case AppStartState.authenticated:
        if (authState.role == 'guardian') {
          screen = const GuardianDashboardScreen();
        } else {
          screen = const TutorDashboardScreen();
        }
        break;
    }

    return MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: AppTheme.light(),
 home: Stack(
  children: [
    AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.05, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: screen,
    ),
    const DevResetButton(),
  ],
),
);

  }
}
