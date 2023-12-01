import 'package:flutter/material.dart';

class AuthenticationRequiredErrorSnackBar extends SnackBar {
  const AuthenticationRequiredErrorSnackBar({Key? key})
      : super(
          key: key,
          content: const _AuthenticationRequiredErrorSnackBarMessage(),
        );
}

class _AuthenticationRequiredErrorSnackBarMessage extends StatelessWidget {
  const _AuthenticationRequiredErrorSnackBarMessage();

  @override
  Widget build(BuildContext context) {
    return const Text('authentication is requried error message');
  }
}
