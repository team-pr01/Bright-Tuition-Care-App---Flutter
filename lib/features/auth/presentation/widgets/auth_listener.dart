import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/auth_notifier.dart';

class AuthListener extends ConsumerWidget {

  final Widget child;

  const AuthListener({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    ref.listen(authProvider, (previous, next) {

      // /// ERROR
      // if (next.error != null &&
      //     next.error != previous?.error) {

      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text(next.error!),
      //       backgroundColor: Colors.red,
      //     ),
      //   );

      // }

    });

    return child;

  }

}