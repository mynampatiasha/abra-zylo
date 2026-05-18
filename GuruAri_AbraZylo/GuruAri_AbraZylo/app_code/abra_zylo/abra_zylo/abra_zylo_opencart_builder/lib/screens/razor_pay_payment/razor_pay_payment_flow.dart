import 'package:oc_demo/screens/razor_pay_payment/model/razor_pay_model.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class AbraRazorPay {
  AbraRazorPay._();

  static final instance = AbraRazorPay._();
  Razorpay razorpay = Razorpay();
  String merchantKeyValue = "";

  void initRazorPay(RazorPayModel? payModel,
      {required Function(PaymentFailureResponse response) onError,
      required Function(PaymentSuccessResponse response) onSuccess}) {
    Map<String, dynamic> razorInitData = {
      'key': payModel?.keyId ?? "",
      'amount': double.parse(payModel?.total ?? "0") * 100,
      'name': 'Abra Zylo',
      // 'description': 'Fine T-Shirt',
      // 'retry': {'enabled': true, 'max_count': 1},
      // 'send_sms_hash': true,
      // 'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      // 'external': {
      //   'wallets': ['paytm']
      // }
    };

    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, onError);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, onSuccess);
    razorpay.open(razorInitData);
  }

  // void handlePaymentErrorResponse(PaymentFailureResponse response){
  //   print("Payment Failed Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  // }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */
    print("Payment Successful Payment ID: ${response.paymentId}");
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    print("External Wallet Selected ${response.walletName}");
  }
}
