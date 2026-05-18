import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:oc_demo/common_widgets/alert_message.dart';
import 'package:oc_demo/common_widgets/loader.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/helper/app_shared_pref.dart';
import 'package:oc_demo/network_manager/api_client.dart';

class LoginQrScan extends StatefulWidget {
  const LoginQrScan({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginQrScanState();
}

class _LoginQrScanState extends State<LoginQrScan> {
  Barcode? result;

  bool isFlashEnabled = false;
  bool isLoading = false;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        _buildQrView(context),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: Container(
            color: AppColors.background,
            margin: const EdgeInsets.symmetric(horizontal: AppSizes.size4),
            padding: const EdgeInsets.all(AppSizes.size16),
            child: Text(
              "Go to ${ApiConstant.baseUrl} on your computer and scan the Qr code",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
        if (isLoading)
          const Center(
            child: Loader(),
          )
      ],
    ));
  }

  Widget _buildQrView(BuildContext context) {
    return /*MobileScanner(
        allowDuplicates: false,
        controller: MobileScannerController(torchEnabled: isFlashEnabled),
        onDetect: (barcode, args) {
          if (barcode.rawValue == null) {
            debugPrint('Failed to scan Barcode');
          } else {
            final String code = barcode.rawValue!;
            startQrLogin(code);
          }
        });*/
        MobileScanner(
            controller: MobileScannerController(torchEnabled: isFlashEnabled),
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              final Uint8List? image = capture.image;
              for (final barcode in barcodes) {
                if (barcode.rawValue?.isEmpty == true) {
                  debugPrint('Failed to scan Barcode');
                } else {
                  final String code = barcode.rawValue!;
                  startQrLogin(code);
                }
              }
            });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void startQrLogin(String result) async {
    setState(() {
      isLoading = true;
    });
    var model =
        await ApiClient().loginWithQr(result, await AppSharedPref.getWkToken());
    if (model.error == 0) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        isLoading = false;
      });
      AlertMessage.showError(model.message ?? "", context);
    }
  }
}
