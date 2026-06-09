import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants/app_constants.dart';
import '../../../config/theme.dart';

class ProductDeliveryEstimateWidget extends StatelessWidget {
  const ProductDeliveryEstimateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate delivery date (Today + 5 days to 6 days)
    DateTime today = DateTime.now();
    DateTime minDelivery = today.add(const Duration(days: 5));
    DateTime maxDelivery = today.add(const Duration(days: 6));
    
    String formattedMin = DateFormat('MMM dd').format(minDelivery);
    String formattedMax = DateFormat('MMM dd').format(maxDelivery);
    String deliveryText = "Estimated Delivery: $formattedMin - $formattedMax";

    return Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.size16, vertical: AppSizes.size12),
      child: Row(
        children: [
          Icon(Icons.local_shipping_outlined, color: AppColors.green, size: 24),
          const SizedBox(width: AppSizes.size12),
          Expanded(
            child: Text(
              deliveryText,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.green,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
