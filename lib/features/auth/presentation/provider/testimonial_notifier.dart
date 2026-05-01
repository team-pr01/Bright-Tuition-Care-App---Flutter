

import 'package:btcclient/features/auth/data/auth_repository.dart';
import 'package:btcclient/features/auth/data/models/testimonial_model.dart';
import 'package:btcclient/features/auth/presentation/provider/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final testimonialProvider =
    ChangeNotifierProvider<TestimonialNotifier>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return TestimonialNotifier(repo);
});

class TestimonialNotifier extends ChangeNotifier {
  final AuthRepository repository;

  TestimonialNotifier(this.repository);

  List<TestimonialModel> testimonials = [];
  bool isLoading = false;

  Future<void> fetchTestimonials() async {
    isLoading = true;
    notifyListeners();

    try {
      testimonials = await repository.getAllTestimonials();
    } catch (e) {
      print("Error: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}