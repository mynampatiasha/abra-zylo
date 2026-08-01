import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:oc_demo/helper/push_notifications_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:confetti/confetti.dart';

import '../../../../common_widgets/Tabbar/bottom_tabbar.dart';
import '../../../../common_widgets/alert_message.dart';
import '../../../../common_widgets/app_bar.dart';
import '../../../../constants/app_constants.dart';
import '../../../../constants/app_string_constant.dart';
import '../../../../helper/app_localizations.dart';

class OrderComplete extends StatefulWidget {
  const OrderComplete(this.data, this.orderId, {Key? key}) : super(key: key);

  final String? data, orderId;

  @override
  State<OrderComplete> createState() => _OrderCompleteState();
}

class _OrderCompleteState extends State<OrderComplete> with TickerProviderStateMixin {
  AppLocalizations? localizations;
  late ConfettiController _confettiController;
  
  // Animation controllers
  late AnimationController _cardController;
  late AnimationController _stampController;
  late AnimationController _pulseController1;
  late AnimationController _pulseController2;
  
  // Animations
  late Animation<double> _cardOpacity;
  late Animation<Offset> _cardOffset;
  late Animation<double> _stampScale;
  late Animation<double> _stampRotation;
  late Animation<double> _pulseScale1;
  late Animation<double> _pulseOpacity1;
  late Animation<double> _pulseScale2;
  late Animation<double> _pulseOpacity2;

  final Color violet900 = const Color(0xFF2f1065);
  final Color violet700 = const Color(0xFF5b21b6);
  final Color violet600 = const Color(0xFF7c3aed);
  final Color violet100 = const Color(0xFFefe6ff);
  final Color gold = const Color(0xFFffb545);
  final Color mint = const Color(0xFF3ddc97);
  final Color paper = const Color(0xFFfffdf9);
  final Color ink = const Color(0xFF241a3d);
  final Color inkSoft = const Color(0xFF6b6280);
  final Color blob2Bg = const Color(0xFFd9fbe9);

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    
    // Card animation
    _cardController = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _cardOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _cardController, curve: Curves.easeOut));
    _cardOffset = Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(CurvedAnimation(parent: _cardController, curve: Curves.easeOutCubic));
    
    // Stamp animation
    _stampController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _stampScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.12), weight: 60),
      TweenSequenceItem(tween: Tween<double>(begin: 1.12, end: 1.0), weight: 40),
    ]).animate(CurvedAnimation(parent: _stampController, curve: Curves.easeInOut));
    
    _stampRotation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: -0.436, end: 0.07), weight: 60), // -25 deg to 4 deg
      TweenSequenceItem(tween: Tween<double>(begin: 0.07, end: 0.0), weight: 40),
    ]).animate(CurvedAnimation(parent: _stampController, curve: Curves.easeInOut));

    // Pulse animations
    _pulseController1 = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _pulseScale1 = Tween<double>(begin: 0.8, end: 1.9).animate(CurvedAnimation(parent: _pulseController1, curve: Curves.easeOut));
    _pulseOpacity1 = Tween<double>(begin: 0.7, end: 0.0).animate(CurvedAnimation(parent: _pulseController1, curve: Curves.easeOut));

    _pulseController2 = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _pulseScale2 = Tween<double>(begin: 0.8, end: 1.9).animate(CurvedAnimation(parent: _pulseController2, curve: Curves.easeOut));
    _pulseOpacity2 = Tween<double>(begin: 0.7, end: 0.0).animate(CurvedAnimation(parent: _pulseController2, curve: Curves.easeOut));

    // Staggered start
    Future.delayed(const Duration(milliseconds: 50), () {
      if(mounted) _cardController.forward();
    });
    Future.delayed(const Duration(milliseconds: 120), () {
      if(mounted) _stampController.forward();
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      if(mounted) _pulseController1.forward();
    });
    Future.delayed(const Duration(milliseconds: 680), () {
      if(mounted) _pulseController2.forward();
    });
    Future.delayed(const Duration(milliseconds: 550), () {
      if(mounted) _confettiController.play();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _cardController.dispose();
    _stampController.dispose();
    _pulseController1.dispose();
    _pulseController2.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    int? targetNumber = int.tryParse(widget.orderId?.replaceAll(RegExp(r'[^0-9]'), '') ?? '');
    
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => BottomTabbarWidget()),
          (route) => false,
        );
        return true;
      },
      child: Scaffold(
        backgroundColor: paper,
        body: Stack(
          children: [
            // Background Blobs
            Positioned(
              top: -120,
              left: -120,
              child: _buildBlob(violet100, 420),
            ),
            Positioned(
              bottom: -140,
              right: -100,
              child: _buildBlob(blob2Bg, 360),
            ),
            
            // Main Content
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: FadeTransition(
                      opacity: _cardOpacity,
                      child: SlideTransition(
                        position: _cardOffset,
                        child: Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(maxWidth: 460),
                          padding: const EdgeInsets.fromLTRB(36, 52, 36, 40),
                          decoration: BoxDecoration(
                            color: paper,
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF2F1065).withOpacity(0.28),
                                offset: const Offset(0, 30),
                                blurRadius: 60,
                                spreadRadius: -20,
                              ),
                              BoxShadow(
                                color: const Color(0xFF2F1065).withOpacity(0.18),
                                offset: const Offset(0, 10),
                                blurRadius: 20,
                                spreadRadius: -12,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildStampWrap(),
                              const SizedBox(height: 20),
                              Text(
                                "Order placed successfully!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  color: violet900,
                                  height: 1.15,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Thanks for shopping with us. We're getting everything ready and we'll email you the moment it ships.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: inkSoft,
                                  height: 1.55,
                                ),
                              ),
                              const SizedBox(height: 26),
                              
                              // HTML widget for extra data (optional based on the old UI)
                              if (widget.data != null && widget.data!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 26),
                                  child: Html(
                                    data: widget.data?.trim().replaceAll(r"\\n", "").replaceAll(r"\t", ""),
                                    style: {
                                      "body": Style(
                                        fontSize: FontSize(14.0),
                                        color: inkSoft,
                                        textAlign: TextAlign.center,
                                      ),
                                    },
                                    onAnchorTap: (link, _, ele) async {
                                      if (link != null && await canLaunch(link)) {
                                        launch(link);
                                      }
                                    },
                                  ),
                                ),

                              // Order Number Card
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: violet100,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      "ORDER NUMBER",
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1.1,
                                        color: violet700,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    if (targetNumber != null)
                                      TweenAnimationBuilder<double>(
                                        tween: Tween<double>(begin: 0, end: targetNumber.toDouble()),
                                        duration: const Duration(milliseconds: 1500),
                                        curve: Curves.easeOutCubic,
                                        builder: (context, value, child) {
                                          return Text(
                                            "#${value.toInt()}",
                                            style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.w800,
                                              color: violet900,
                                              letterSpacing: 0.6,
                                            ),
                                          );
                                        },
                                      )
                                    else
                                      Text(
                                        "#${widget.orderId}",
                                        style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w800,
                                          color: violet900,
                                          letterSpacing: 0.6,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 26),
                              
                              // Buttons
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [violet600, violet700],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      BoxShadow(
                                        color: violet600.withOpacity(0.6),
                                        offset: const Offset(0, 12),
                                        blurRadius: 22,
                                        spreadRadius: -10,
                                      )
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(builder: (context) => BottomTabbarWidget()),
                                        (route) => false,
                                      );
                                    },
                                    child: const Text(
                                      "Continue shopping",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // const SizedBox(height: 12),
                              // SizedBox(
                              //   width: double.infinity,
                              //   height: 50,
                              //   child: OutlinedButton(
                              //     style: OutlinedButton.styleFrom(
                              //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              //       side: const BorderSide(color: Color(0xFFe7e2f2), width: 1.5),
                              //       backgroundColor: Colors.transparent,
                              //     ),
                              //     onPressed: () {
                              //        Navigator.of(context).pushAndRemoveUntil(
                              //         MaterialPageRoute(builder: (context) => BottomTabbarWidget()),
                              //         (route) => false,
                              //       );
                              //     },
                              //     child: Text(
                              //       "View order history",
                              //       style: TextStyle(
                              //         color: inkSoft,
                              //         fontWeight: FontWeight.w700,
                              //         fontSize: 15,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            // Confetti Overlay
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: [violet600, gold, mint, const Color(0xFFff6b81), const Color(0xFF4fc3f7)],
                gravity: 0.2,
                emissionFrequency: 0.05,
                numberOfParticles: 50,
              ),
            ),
            
            // Top App Bar fallback back button
            Positioned(
              top: 40,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => BottomTabbarWidget()),
                    (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlob(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.45),
        shape: BoxShape.circle,
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
        child: Container(color: Colors.transparent),
      ),
    );
  }

  Widget _buildStampWrap() {
    return SizedBox(
      width: 112,
      height: 112,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Pulse 1
          FadeTransition(
            opacity: _pulseOpacity1,
            child: ScaleTransition(
              scale: _pulseScale1,
              child: Container(
                width: 112,
                height: 112,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: gold, width: 2),
                ),
              ),
            ),
          ),
          // Pulse 2
          FadeTransition(
            opacity: _pulseOpacity2,
            child: ScaleTransition(
              scale: _pulseScale2,
              child: Container(
                width: 112,
                height: 112,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: gold, width: 2),
                ),
              ),
            ),
          ),
          // Stamp Ring
          AnimatedBuilder(
            animation: _stampController,
            builder: (context, child) {
              return Transform.scale(
                scale: _stampScale.value,
                child: Transform.rotate(
                  angle: _stampRotation.value,
                  child: Container(
                    width: 112,
                    height: 112,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: violet700, width: 3),
                      gradient: LinearGradient(
                        colors: [violet600, violet900],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: violet700.withOpacity(0.55),
                          offset: const Offset(0, 16),
                          blurRadius: 30,
                          spreadRadius: -10,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 52,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
