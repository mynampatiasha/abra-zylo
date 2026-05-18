import 'package:flutter/material.dart';

class LoaderUtil {
  static Widget showCoverLoader() {
    return Stack(
      children: const <Widget>[
        Opacity(
          opacity: 0.1,
          child: ModalBarrier(dismissible: false, color: Colors.white),
        ),
        Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
