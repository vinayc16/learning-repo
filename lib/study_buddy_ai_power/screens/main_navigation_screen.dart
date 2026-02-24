import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learning_statemanejment/study_buddy_ai_power/screens/settings/new_setting_screen.dart';
import '../../ai_power_app/widget/custom_text.dart';
import 'home/study_buddy_home_screen.dart';
import 'history/history_screen.dart';
import 'ai_help/ai_help_screen.dart';
import 'progress/progress_screen.dart';
import 'settings/settings_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const StudyBuddyHomeScreen(),
    const HistoryScreen(),
    const ProgressScreen(),
    const SettingsScreen(),
    const AIHelpScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color activeColor = Colors.red;

    return SizedBox(
      height: 80, // Height optimized
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Background Painter (Flat on top now)
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 80),
            painter: BottomNavCurvePainter(backgroundColor: Colors.white),
          ),

          // Center FAB - No curve space around it
          Positioned(
            bottom: 10, // Adjust vertical position
            child: GestureDetector(
              onTap: () => onTap(4),
              child: Column(
                spacing: 2,
                children: [
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Color(0xFF667EEA).withOpacity(0.3),
                      //     blurRadius: 8,
                      //     offset: const Offset(0, 4),
                      //   ),
                      // ],
                    ),
                    child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 28),
                  ),
                  CustomText(text: "Ai Help",fontSize: 10,fontWeight: FontWeight.bold,color: Colors.grey,)
                ],
              ),
            ),
          ),

          // Bottom Navigation Items
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home_outlined, Icons.home, "Home", 0),
                _buildNavItem(Icons.history_outlined, Icons.history, "History", 1),
                const SizedBox(width: 50), // Gap for FAB position
                _buildNavItem(Icons.analytics_outlined, Icons.analytics, "Progress", 2),
                _buildNavItem(Icons.settings_outlined, Icons.settings, "Settings", 3),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, IconData activeIcon, String label, int index) {
    bool isSelected = currentIndex == index;
    final Color activeColor = Color(0xFF667EEA);

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? activeIcon : icon,
            color: isSelected ? activeColor : Colors.grey.shade400,
            size: 24,
          ),
          const SizedBox(height: 2),
          CustomText(
            text: label,
            fontSize: 10,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? activeColor : Colors.grey.shade500,
          ),
        ],
      ),
    );
  }
}

// --- FLAT TOP PAINTER ---
class BottomNavCurvePainter extends CustomPainter {
  Color backgroundColor;
  BottomNavCurvePainter({this.backgroundColor = Colors.white});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    Path path = Path();

    // Starting from top-left, making a flat top (No Curve)
    path.moveTo(0, 15);
    path.lineTo(size.width, 15); // Straight line to top-right
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // Adding elevation shadow
    canvas.drawShadow(path, Colors.black.withOpacity(0.4), 10, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}