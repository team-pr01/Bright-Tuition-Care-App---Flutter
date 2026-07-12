import 'package:flutter/material.dart';

class ProfileTabModel {

  final String title;

  final String subtitle;

  final IconData icon;

  final bool isCompleted;

  ProfileTabModel({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.isCompleted = false,
  });
}