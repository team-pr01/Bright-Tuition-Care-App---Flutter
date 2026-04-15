import 'package:btcclient/core/widgets/navbar/common_appbar.dart';
import 'package:flutter/material.dart';

class GuardianJobApplication extends StatelessWidget {
  final jobId ;
  const GuardianJobApplication({super.key, required this.jobId});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const CommonAppBar(),

      body: Text(jobId),
    );
  }
}
