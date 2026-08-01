import 'package:flutter/material.dart';

class ProfileDetailScreen extends StatelessWidget {
  final String title;
  final Widget content;

  const ProfileDetailScreen({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfffdf9), // --paper
      appBar: AppBar(
        backgroundColor: const Color(0xFFc8abec), // --lavender
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF5232a8), size: 19),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Baloo 2',
            fontWeight: FontWeight.w700,
            fontSize: 19,
            color: Color(0xFF5232a8), // --violet-900
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Brand strip
          Container(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFece7f3))),
            ),
            margin: const EdgeInsets.only(bottom: 18),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFc8abec), Color(0xFF5232a8)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x805232a8),
                        blurRadius: 14,
                        offset: Offset(0, 6),
                        spreadRadius: -6,
                      )
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 19),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Abra Zylo',
                  style: TextStyle(
                    fontFamily: 'Baloo 2',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Color(0xFF5232a8),
                    letterSpacing: 0.16,
                  ),
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 0),
              child: content,
            ),
          ),
        ],
      ),
    );
  }
}
