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
      // Look for razorpay first
      final razorpayIndex = widget.methods.indexWhere((element) => element.code?.toLowerCase().contains('razorpay') == true);
      if (razorpayIndex != -1) {
        _selectedPayment = widget.methods[razorpayIndex].code;
      } else {
        _selectedPayment = widget.methods[0].code;
      }
    }
    AppSharedPref.setSelectedPaymentId(_selectedPayment ?? "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (ctx, index) => GestureDetector(
        onTap: () async {
          await AppSharedPref.setSelectedPaymentId(widget.methods[index].code ?? "");
          setState(() {
            _selectedPayment = widget.methods[index].code;
            if (widget.onPaymentMethodChange != null) {
              widget.onPaymentMethodChange!();
            }
          });
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _selectedPayment == widget.methods[index].code 
                ? Theme.of(context).colorScheme.primary.withOpacity(0.05)
                : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _selectedPayment == widget.methods[index].code 
                  ? Theme.of(context).colorScheme.primary 
                  : Colors.grey.shade200,
              width: _selectedPayment == widget.methods[index].code ? 2 : 1,
            ),
            boxShadow: [
              if (_selectedPayment != widget.methods[index].code)
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _selectedPayment == widget.methods[index].code 
                          ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                          : Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.methods[index].title?.contains('Razorpay') == true 
                          ? Icons.account_balance_wallet_rounded
                          : Icons.local_shipping_rounded,
                      color: _selectedPayment == widget.methods[index].code 
                          ? Theme.of(context).colorScheme.primary 
                          : Colors.grey.shade600,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      widget.methods[index].title?.contains('Razorpay') == true
                          ? "Online Payment"
                          : "${widget.methods[index].title}",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: _selectedPayment == widget.methods[index].code 
                            ? FontWeight.bold 
                            : FontWeight.w600,
                      ),
                    ),
                  ),
                  Radio<String?>(
                    value: widget.methods[index].code,
                    groupValue: _selectedPayment,
                    activeColor: Theme.of(context).colorScheme.primary,
                    onChanged: (value) async {
                      await AppSharedPref.setSelectedPaymentId(value ?? "");
                      setState(() {
                        _selectedPayment = value;
                        if (widget.onPaymentMethodChange != null) {
                          widget.onPaymentMethodChange!();
                        }
                      });
                    },
                  ),
                ],
              ),
              if (widget.methods[index].title?.contains('Razorpay') == true && _selectedPayment == widget.methods[index].code) ...[
                const SizedBox(height: 16),
                Divider(color: Colors.grey.shade200),
                const SizedBox(height: 12),
                Text(
                  "Pay securely using any of these installed apps:",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 20,
                  runSpacing: 16,
                  children: [
                    _buildUpiAppMock("Google Pay", "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c7/Google_Pay_Logo_%282020%29.svg/1024px-Google_Pay_Logo_%282020%29.svg.png"),
                    _buildUpiAppMock("PhonePe", "https://download.logo.wine/logo/PhonePe/PhonePe-Logo.wine.png"),
                    _buildUpiAppMock("Paytm", "https://upload.wikimedia.org/wikipedia/commons/thumb/2/24/Paytm_Logo_%28standalone%29.svg/1200px-Paytm_Logo_%28standalone%29.svg.png"),
                    _buildUpiAppMock("Other Options", "https://cdn-icons-png.flaticon.com/512/6963/6963703.png"),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
      itemCount: widget.methods.length,
    ),
    );
  }

  Widget _buildUpiAppMock(String name, String imageUrl) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56,
          height: 56,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Image.network(
            imageUrl, 
            fit: BoxFit.contain, 
            errorBuilder: (context, error, stackTrace) => Icon(Icons.payment_rounded, color: Colors.grey.shade400, size: 28)
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
      ],
    );
  }
}
