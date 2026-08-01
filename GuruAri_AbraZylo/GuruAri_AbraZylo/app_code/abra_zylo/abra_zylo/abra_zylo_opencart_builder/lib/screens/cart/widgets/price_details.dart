import 'package:flutter/material.dart';
import 'package:oc_demo/models/cart/cart_model.dart';
import '../../../common_widgets/widget_space.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/app_string_constant.dart';
import '../../../helper/app_localizations.dart';

class PriceDetails extends StatelessWidget {
  const PriceDetails({
    this.totals,
    super.key,
    this.localizations,
  });

  final List<Totals>? totals;
  final AppLocalizations? localizations;

  @override
  Widget build(BuildContext context) {
    if (totals == null || totals!.isEmpty) return const SizedBox();
    
    // Find final total to highlight
    final totalItem = totals!.lastWhere((element) => element.title?.toLowerCase() == 'total', orElse: () => totals!.last);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Price Summary",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Divider(color: Colors.grey.shade200),
            const SizedBox(height: 12),
            ...List.generate(totals!.length, (index) {
              final item = totals![index];
              if (item == totalItem) return const SizedBox(); // Skip total for now, add it at the bottom
              
              bool isShipping = item.title?.toLowerCase().contains('shipping') ?? false;
              bool isFree = item.text?.toLowerCase() == 'free' || item.text == '₹0.00' || item.text == '0' || item.text == '₹0';
              
              String title = item.title ?? '';
              if (title.toLowerCase() == 'sub-total') title = 'Total MRP';
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      isFree ? 'FREE' : (item.text ?? ''),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isFree ? FontWeight.w700 : FontWeight.w600,
                        color: isFree ? Colors.green : (title.toLowerCase().contains('discount') ? Colors.green : Colors.black87),
                      ),
                    ),
                  ],
                ),
              );
            }),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(
                color: Colors.grey.shade300,
                height: 1,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Final Payable Amount:",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  totalItem.text ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            Builder(
              builder: (context) {
                // Try to find a discount or coupon row
                final discountItem = totals!.where((element) => 
                  element.title?.toLowerCase().contains('discount') == true ||
                  element.title?.toLowerCase().contains('coupon') == true
                ).firstOrNull;
                
                if (discountItem != null && discountItem.text != null && discountItem.text!.isNotEmpty) {
                  return Container(
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade100),
                    ),
                    child: Center(
                      child: Text(
                        "You will save ${discountItem.text?.replaceAll('-', '')} on this order",
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox();
              }
            )
          ],
        ),
      ),
    );
  }
}
