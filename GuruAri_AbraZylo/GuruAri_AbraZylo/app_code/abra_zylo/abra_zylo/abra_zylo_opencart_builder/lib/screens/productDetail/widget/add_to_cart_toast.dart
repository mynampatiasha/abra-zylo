import 'package:flutter/material.dart';

class CustomAddToCartToast {
  static void show(BuildContext context, String productName, String mrpStr, String specialStr) {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry? overlayEntry;

    double mrp = 0.0;
    double special = 0.0;
    
    // Simple parsing to extract the numbers from strings like "₹1,589.00"
    final cleanMrpStr = mrpStr.replaceAll(',', '');
    final cleanSpecialStr = specialStr.replaceAll(',', '');
    
    final exp = RegExp(r'[0-9]+(?:\.[0-9]+)?');
    final mrpMatch = exp.firstMatch(cleanMrpStr);
    if (mrpMatch != null) {
      mrp = double.tryParse(mrpMatch.group(0) ?? '0') ?? 0;
    }
    final specialMatch = exp.firstMatch(cleanSpecialStr);
    if (specialMatch != null) {
      special = double.tryParse(specialMatch.group(0) ?? '0') ?? 0;
    }

    double saved = 0.0;
    int pct = 0;
    if (mrp > 0 && special > 0 && mrp > special) {
      saved = mrp - special;
      pct = ((saved / mrp) * 100).round();
    }

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 20,
        left: 14,
        right: 14,
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 450),
            curve: Curves.easeOutBack,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, -20 * (1 - value)),
                child: Opacity(
                  opacity: value.clamp(0.0, 1.0),
                  child: child,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.only(left: 14, right: 16, top: 16, bottom: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF5232a8), Color(0xFF6c46c2)],
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x8C5232A8),
                    blurRadius: 28,
                    spreadRadius: -14,
                    offset: Offset(0, 14),
                  )
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.elasticOut,
                    builder: (context, scale, child) {
                      return Transform.scale(
                        scale: scale,
                        child: child,
                      );
                    },
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(
                        color: Colors.white24,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Added to your cart!",
                          style: TextStyle(
                            fontFamily: 'Baloo 2',
                            fontWeight: FontWeight.w700,
                            fontSize: 14.5,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          productName,
                          style: const TextStyle(
                            fontFamily: 'Karla',
                            fontSize: 12.5,
                            color: Color(0xFFe9defc),
                            height: 1.4,
                          ),
                        ),
                        if (saved > 0)
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white12,
                              border: Border.all(color: Colors.white30),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFffd75e),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: const Text(
                                    "YOU SAVED",
                                    style: TextStyle(
                                      fontFamily: 'Karla',
                                      fontWeight: FontWeight.w800,
                                      fontSize: 10.5,
                                      color: Color(0xFF5c3d00),
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "₹${saved.toStringAsFixed(2)} ($pct%)",
                                  style: const TextStyle(
                                    fontFamily: 'Baloo 2',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12.5,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      overlayEntry?.remove();
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.white70,
                      size: 20,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );

    overlayState.insert(overlayEntry!);

    Future.delayed(const Duration(milliseconds: 4500), () {
      if (overlayEntry != null && overlayEntry!.mounted) {
        overlayEntry!.remove();
      }
    });
  }
}
