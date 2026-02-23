import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:AnimatedSlide(
  offset: Offset.zero,
  duration: const Duration(milliseconds: 400),
  child:  Container(
        width: double.infinity,
        decoration: const BoxDecoration(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo-1.png', width: 192, height: 153),
          ],
        ),
      ),
    ));
  }
}
