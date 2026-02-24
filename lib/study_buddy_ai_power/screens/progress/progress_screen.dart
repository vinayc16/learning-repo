import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:learning_statemanejment/ai_power_app/widget/custom_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/auth_service.dart';
import '../settings/new_setting_screen.dart';
import '../settings/settings_screen.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final _authService = AuthService();
  Map<String, String> _userData = {};
  Map<String, int> _stats = {
    'totalNotes': 0,
    'summaries': 0,
    'flashcards': 0,
    'quizzes': 0,
  };
  List<Map<String, dynamic>> _recentActivity = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadStats();
  }

  Future<void> _loadUserData() async {
    final data = await _authService.getUserData();
    setState(() => _userData = data);
  }

  Future<void> _loadStats() async {
    setState(() => _isLoading = true);
    
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    
    int totalNotes = 0;
    int summaries = 0;
    int flashcards = 0;
    int quizzes = 0;
    List<Map<String, dynamic>> activity = [];
    
    for (String key in keys) {
      if (key.startsWith('study_notes_')) {
        final noteString = prefs.getString(key);
        if (noteString != null) {
          try {
            final note = jsonDecode(noteString);
            totalNotes++;
            
            switch (note['type']) {
              case 'Summary':
                summaries++;
                break;
              case 'Flashcards':
                flashcards++;
                break;
              case 'Quiz':
                quizzes++;
                break;
            }
            
            activity.add({
              'type': note['type'],
              'timestamp': DateTime.parse(note['timestamp']),
            });
          } catch (e) {
            print('Error loading note: $e');
          }
        }
      }
    }
    
    // Sort activity by date
    activity.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
    
    setState(() {
      _stats = {
        'totalNotes': totalNotes,
        'summaries': summaries,
        'flashcards': flashcards,
        'quizzes': quizzes,
      };
      _recentActivity = activity.take(10).toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const CustomText(
          text: 'My Progress',
            color: Color(0xFF2D3436),
            fontWeight: FontWeight.bold,
            fontSize: 16,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _userData['name'] ?? 'User',
                      style: const TextStyle(
                        color: Color(0xFF2D3436),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      _userData['email'] ?? '',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    );
                    _loadUserData();
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(0xFF667EEA),
                    backgroundImage: _userData['profileImage']?.isNotEmpty == true
                        ? FileImage(File(_userData['profileImage']!))
                        : null,
                    child: _userData['profileImage']?.isEmpty ?? true
                        ? Text(
                            _userData['name']?.isNotEmpty == true
                                ? _userData['name']![0].toUpperCase()
                                : 'U',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          )
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667EEA)),
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadStats,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF667EEA).withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: _stats['totalNotes'] == 0
                                      ? "🙁 Oops, No Progress!"
                                      : "🎯 Great Progress!",
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                ),
                                const SizedBox(height: 8),
                                CustomText(
                                  text: _stats['totalNotes'] == 0
                                      ? "Oops, You haven't created any study materials yet!"
                                      : "You've created ${_stats['totalNotes']} study materials",
                                    fontSize: 12,
                                    color: Colors.white,
                                    maxLines: 5,
                                    fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: const Icon(
                              Icons.trending_up,
                              color: Colors.white,
                              size: 35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Stats Grid
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildStatCard(
                          'Summaries',
                          _stats['summaries']!,
                          Icons.summarize,
                          const Color(0xFF667EEA),
                        ),
                        const SizedBox(width: 8),
                        _buildStatCard(
                          'Flashcards',
                          _stats['flashcards']!,
                          Icons.style,
                          const Color(0xFFE84393),
                        ),
                        const SizedBox(width: 8),
                        _buildStatCard(
                          'Quizzes',
                          _stats['quizzes']!,
                          Icons.quiz,
                          const Color(0xFFFF6B6B),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildTotalNotesCard(_stats['totalNotes'].toString()),
                    const SizedBox(height: 24),
                    
                    // Chart Section
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.bar_chart_outlined, color: Color(0xFF667EEA)),
                              SizedBox(width: 8),
                              CustomText(
                                text: 'Study Materials Overview',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2D3436),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          
                          // Simple Bar Chart Visualization
                          _buildPieChartSection(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Recent Activity
                    const CustomText(
                      text: 'Recent Activity',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3436),
                    ),
                    const SizedBox(height: 16),
                    
                    if (_recentActivity.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.analytics_outlined,
                                size: 60,
                                color: Colors.grey.shade300,
                              ),
                              const SizedBox(height: 16),
                              CustomText(
                                text: 'No activity yet',
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ...List.generate(
                        _recentActivity.length,
                        (index) => _buildActivityItem(_recentActivity[index]),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
  
  
  Widget _buildTotalNotesCard(String value) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(8.0),
          bottomRight: Radius.circular(8.0),
        ),
        border: Border(
          left: BorderSide(
            color: Color(0xFF667EEA),
            width: 3,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          spacing: 4,
          children: [
            Icon(Icons.library_books, color: const Color(0xFF667EEA),size: 18,),
            CustomText(
                text: "You've created total $value study materials.",
              fontWeight: FontWeight.w600,
              color: Colors.grey,
              fontSize: 11,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, int value, IconData icon, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 4),
          CustomText(
            text: value.toString(),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          CustomText(
            text: label,
            fontSize: 10,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    final type = activity['type'] as String;
    final timestamp = activity['timestamp'] as DateTime;
    
    IconData icon;
    Color color;
    
    switch (type) {
      case 'Summary':
        icon = Icons.summarize;
        color = const Color(0xFF667EEA);
        break;
      case 'Flashcards':
        icon = Icons.style;
        color = const Color(0xFFE84393);
        break;
      case 'Quiz':
        icon = Icons.quiz;
        color = const Color(0xFFFF6B6B);
        break;
      default:
        icon = Icons.description;
        color = Colors.grey;
    }
    
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    String timeAgo;
    
    if (difference.inMinutes < 1) {
      timeAgo = 'Just now';
    } else if (difference.inHours < 1) {
      timeAgo = '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      timeAgo = '${difference.inHours}h ago';
    } else {
      timeAgo = '${difference.inDays}d ago';
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              spacing: 25,
              children: [
                CustomText(
                  text: 'Created $type',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3436),
                ),
                CustomText(
                  text: timeAgo,
                    fontSize: 12,
                    color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
          Icon(Icons.check_circle, color: color, size: 20),
        ],
      ),
    );
  }

  Widget _buildPieChartSection() {
    final int total = _stats['summaries']! + _stats['flashcards']! + _stats['quizzes']!;

    return Column(
      children: [
        SizedBox(
          height: 210,
          child: total == 0
              ? const Center(child: CustomText(text: "No data available", color: Colors.grey))
              : Stack(
            alignment: Alignment.center,
            children: [
              // PieChart
              PieChart(
                PieChartData(
                  sectionsSpace: 4,
                  centerSpaceRadius: 60,
                  sections: [
                    _buildPieSection(
                      value: _stats['summaries']!.toDouble(),
                      color: const Color(0xFF667EEA),
                      title: 'Sum.',
                    ),
                    _buildPieSection(
                      value: _stats['flashcards']!.toDouble(),
                      color: const Color(0xFFE84393),
                      title: 'Flash.',
                    ),
                    _buildPieSection(
                      value: _stats['quizzes']!.toDouble(),
                      color: const Color(0xFFFF6B6B),
                      title: 'Quiz',
                    ),
                  ],
                ),
              ),
              // Text Between Chart
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CustomText(
                    text: "Study Buddy",
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                  CustomText(
                    text: "Total material",
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF667EEA),
                  ),
                  const SizedBox(height: 4),
                  CustomText(
                    text: total.toString(),
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF2D3436),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Legends
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildLegend('Summaries', const Color(0xFF667EEA)),
            _buildLegend('Flashcards', const Color(0xFFE84393)),
            _buildLegend('Quizzes', const Color(0xFFFF6B6B)),
          ],
        ),
      ],
    );
  }

  PieChartSectionData _buildPieSection({
    required double value,
    required Color color,
    required String title,
  }) {
    return PieChartSectionData(
      color: color,
      value: value,
      title: value > 0 ? '${value.toInt()}' : '',
      radius: 50,
      titleStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        CustomText(text: label, fontSize: 11, fontWeight: FontWeight.w600),
      ],
    );
  }

  Widget _buildBarRow(String label, int value, Color color, double maxValue) {
    final percentage = maxValue > 0 ? (value / maxValue) : 0.0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3436),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                value.toString(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 12,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
              height: 12,
              width: MediaQuery.of(context).size.width * 0.7 * percentage,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withOpacity(0.7)],
                ),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
