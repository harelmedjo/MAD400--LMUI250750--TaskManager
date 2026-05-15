import 'package:flutter/material.dart';
import 'dart:ui';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const Color primary = Color(0xFF0A84FF); 
  static const Color accent = Color(0xFF64D2FF); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      backgroundColor: const Color.fromARGB(255, 23, 23, 236),

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: AppBar(
              elevation: 0,

              
              backgroundColor: const Color.fromARGB(255, 37, 37, 37).withOpacity(0.05),

              centerTitle: false,
              title: const Text(
                'Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ),
        ),
      ),

      body: Stack(
        children: [
          
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 117, 117, 117),
                  Color.fromARGB(255, 0, 6, 14),
                  Color(0xFF0B172A),
                  Color.fromARGB(255, 237, 237, 238),
                ],
              ),
            ),
          ),

          // ✨ UPDATED GLOW COLORS
          Positioned(
            top: -120,
            right: -80,
            child: _glow(280, primary.withOpacity(0.20)),
          ),

          Positioned(
            bottom: -120,
            left: -80,
            child: _glow(320, accent.withOpacity(0.16)),
          ),

          // 📄 CONTENT
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 130, 24, 140),
            child: Column(
              children: [
                // 👤 PROFILE CARD
                _glassCard(
                  child: Column(
                    children: [
                      Container(
                        width: 95,
                        height: 95,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,

                          // 🎨 UPDATED AVATAR GRADIENT
                          gradient: const LinearGradient(
                            colors: [primary, accent],
                          ),

                          boxShadow: [
                            BoxShadow(
                              color: primary.withOpacity(0.30),
                              blurRadius: 34,
                              spreadRadius: 2,
                            )
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'DMH',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      const Text(
                        'DANG NEDJO HAREL',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        'Student Matricule: LMUI250750',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.65),
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        'Landmark Metropolitan University',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.50),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 🧠 BIO CARD
                _glassCard(
                  title: 'Bio',
                  icon: Icons.info_outline_rounded,
                  child: const Text(
                    'I am a Level 400 Software Engineering student at Landmark Metropolitan University. I love building mobile applications and solving complex problems with code.',
                    style: TextStyle(
                      color: Colors.white70,
                      height: 1.6,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // 🎯 GOALS CARD
                _glassCard(
                  title: 'Top 3 Goals',
                  icon: Icons.auto_awesome_rounded,
                  child: Column(
                    children: const [
                      _GoalItem('Master Flutter and Dart and build apps'),
                      _GoalItem('Maintain a GPA above 3.8'),
                      _GoalItem('i want to graduate with high GPA'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🧊 GLASS CARD
  Widget _glassCard({
    String? title,
    IconData? icon,
    required Widget child,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),

            borderRadius: BorderRadius.circular(28),

            border: Border.all(
              color: Colors.white.withOpacity(0.10),
            ),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.45),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                Row(
                  children: [
                    Icon(icon, color: primary, size: 18),
                    const SizedBox(width: 10),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),

              if (title != null) const SizedBox(height: 14),

              child,
            ],
          ),
        ),
      ),
    );
  }

  // 🎇 GLOW
  Widget _glow(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 120, sigmaY: 120),
        child: const SizedBox(),
      ),
    );
  }
}

// 🎯 GOAL ITEM
class _GoalItem extends StatelessWidget {
  final String text;

  const _GoalItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_rounded,

            // ✅ UPDATED SUCCESS COLOR
            color: Color(0xFF32D74B),

            size: 18,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}