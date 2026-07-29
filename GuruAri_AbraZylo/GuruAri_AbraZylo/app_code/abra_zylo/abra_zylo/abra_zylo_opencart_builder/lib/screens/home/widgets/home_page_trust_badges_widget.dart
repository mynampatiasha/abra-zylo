import 'package:flutter/material.dart';

class HomePageTrustBadgesWidget extends StatelessWidget {
  const HomePageTrustBadgesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildBadge(Icons.verified_outlined, "Premium\nQuality"),
          _buildDivider(),
          _buildBadge(Icons.local_offer_outlined, "Best\nPrices"),
          _buildDivider(),
          _buildBadge(Icons.local_shipping_outlined, "Fast & Safe\nDelivery"),
          _buildDivider(),
          _buildBadge(Icons.security_outlined, "Secure\nPayments"),
        ],
      ),
    );
  }

  Widget _buildBadge(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, size: 28, color: const Color(0xFF673AB7)),
        const SizedBox(height: 8),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey.shade200,
    );
  }
}
