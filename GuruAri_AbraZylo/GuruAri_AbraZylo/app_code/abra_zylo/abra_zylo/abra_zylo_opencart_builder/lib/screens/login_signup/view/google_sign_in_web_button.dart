// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
import 'package:google_sign_in_web/google_sign_in_web.dart';

/// Web-only Google Sign-In button using GIS renderButton API.
/// Only used when kIsWeb is true.
class GoogleSignInWebButton extends StatefulWidget {
  final void Function(GoogleSignInAccount user) onSuccess;

  const GoogleSignInWebButton({required this.onSuccess, Key? key})
      : super(key: key);

  @override
  State<GoogleSignInWebButton> createState() => _GoogleSignInWebButtonState();
}

class _GoogleSignInWebButtonState extends State<GoogleSignInWebButton> {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        '847585068690-74je0ce1r9j6gijli99f5njhm736a555.apps.googleusercontent.com',
    scopes: ['email', 'profile'],
  );

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      if (account != null) {
        widget.onSuccess(account);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Cast the registered platform instance to GoogleSignInPlugin to access renderButton
    final platform = GoogleSignInPlatform.instance;
    if (platform is GoogleSignInPlugin) {
      return SizedBox(
        width: double.infinity,
        child: Center(
          child: platform.renderButton(),
        ),
      );
    }
    // Fallback: should not happen on web
    return const SizedBox.shrink();
  }
}
