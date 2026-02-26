import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MockExamApp());
}

class MockExamApp extends StatelessWidget {
  const MockExamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF6F8F7),
        primaryColor: const Color(0xFF13EC6D),
        textTheme: GoogleFonts.interTextTheme(),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF102218),
        primaryColor: const Color(0xFF13EC6D),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      ),
      home: const JoinEliteScreen(),
    );
  }
}

class JoinEliteScreen extends StatelessWidget {
  const JoinEliteScreen({super.key});

  static const Color primaryGreen = Color(0xFF13EC6D);
  static const Color accentDark = Color(0xFF0D1B13);

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        leading: Icon(Icons.arrow_back, color: isDark ? Colors.white : accentDark),
        centerTitle: true,
        title: Text(
          "Join the Elite",
          style: TextStyle(
            color: isDark ? Colors.white : accentDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.info_outline, color: isDark ? Colors.white : accentDark),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: primaryGreen.withOpacity(0.1), height: 1),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroSection(),
            _buildBenefitsSection(isDark),
            _buildTestimonialSection(isDark),
            _buildCTASection(isDark),
            const SizedBox(height: 100), // Space for bottom nav
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(isDark),
      extendBody: true,
    );
  }

  Widget _buildHeroSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 320,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: NetworkImage("https://images.unsplash.com/photo-1523240795612-9a054b0db644?q=80&w=2070&auto=format&fit=crop"),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              accentDark.withOpacity(0.2),
              accentDark.withOpacity(0.9),
            ],
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: primaryGreen,
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Text(
                "PREMIUM ACCESS",
                style: TextStyle(
                  color: accentDark,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Unlock Your Potential",
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.w800,
                height: 1.1,
              ),
            ),
            const Text(
              "Join 50,000+ top achievers worldwide.",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitsSection(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          _benefitCard(
            isDark,
            Icons.quiz_outlined,
            "Unlimited Mock Tests",
            "Access over 1,000+ real-world exam simulations across all subjects.",
          ),
          _benefitCard(
            isDark,
            Icons.insights,
            "Detailed Analytics",
            "Identify your weak spots with AI-driven performance reports and heatmaps.",
          ),
          _benefitCard(
            isDark,
            Icons.school_outlined,
            "Expert Guidance",
            "Get 24/7 priority support and strategies from top-tier educators.",
          ),
        ],
      ),
    );
  }

  Widget _benefitCard(bool isDark, IconData icon, String title, String desc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryGreen.withOpacity(0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: primaryGreen.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: primaryGreen, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialSection(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: primaryGreen.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primaryGreen.withOpacity(0.2)),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -10,
              top: -10,
              child: Icon(Icons.format_quote, size: 80, color: primaryGreen.withOpacity(0.1)),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: List.generate(
                    5,
                        (index) => const Icon(Icons.star, color: primaryGreen, size: 16),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "\"This platform changed my study game completely. I went from failing mock exams to scoring in the 98th percentile!\"",
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=32"),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Sarah Jenkins", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        Text(
                          "Medical Student, Harvard",
                          style: TextStyle(fontSize: 10, color: isDark ? Colors.white60 : Colors.black54),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCTASection(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
              foregroundColor: accentDark,
              minimumSize: const Size(double.infinity, 60),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Start Your 7-Day Free Trial", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 20),
              ],
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: isDark ? Colors.white : accentDark,
              minimumSize: const Size(double.infinity, 60),
              side: BorderSide(color: isDark ? Colors.white24 : accentDark, width: 2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text("View Enterprise Pricing", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              "By joining, you agree to our Terms of Service and Privacy Policy. No credit card required for trial.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF102218) : const Color(0xFFF6F8F7),
        border: Border(top: BorderSide(color: primaryGreen.withOpacity(0.1))),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.home_outlined, "Home", false, isDark),
              _navItem(Icons.assignment_outlined, "Tests", false, isDark),
              _navItem(Icons.add_circle, "Enroll", true, isDark),
              _navItem(Icons.person_outline, "Profile", false, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool isActive, bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isActive ? primaryGreen : Colors.grey,
          size: isActive ? 30 : 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? (isDark ? primaryGreen : accentDark) : Colors.grey,
            fontSize: 10,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}