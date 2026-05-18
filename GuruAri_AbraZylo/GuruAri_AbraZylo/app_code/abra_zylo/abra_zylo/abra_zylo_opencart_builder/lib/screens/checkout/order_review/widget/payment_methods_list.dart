import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_constants.dart';

import '../../../../helper/app_shared_pref.dart';
import '../../../../models/checkout/checkout_payment_method_model.dart';

class PaymentMethodsList extends StatefulWidget {
  const PaymentMethodsList(this.methods, {this.onPaymentMethodChange, Key? key})
      : super(key: key);
  final VoidCallback? onPaymentMethodChange;
  final List<PaymentMethod> methods;

  @override
  _PaymentMethodsListState createState() => _PaymentMethodsListState();
}

class _PaymentMethodsListState extends State<PaymentMethodsList> {
  late String? _selectedPayment = "";

  @override
  void initState() {
    if (widget.methods.isNotEmpty) {
      _selectedPayment = widget.methods[0].code;
    }
    AppSharedPref.setSelectedPaymentId(_selectedPayment ?? "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (ctx, index) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RadioListTile<String?>(
              contentPadding: const EdgeInsets.all(0),
              title: Text("${widget.methods[index].title}",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontSize: AppSizes.size16)),
              value: widget.methods[index].code,
              groupValue: _selectedPayment,
              onChanged: (value) async {
                await AppSharedPref.setSelectedPaymentId(value ?? "");
                setState(() {
                  _selectedPayment = value;
                  if (widget.onPaymentMethodChange != null) {
                    widget.onPaymentMethodChange!();
                  }
                });
              }),
        ],
      ),
      itemCount: widget.methods.length,
    );
  }
}
