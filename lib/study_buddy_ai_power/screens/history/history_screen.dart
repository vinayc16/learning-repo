import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../../../ai_power_app/widget/custom_text.dart';
import '../../screen/category_screen.dart';
import '../flashcards/flashcard_viewer_screen.dart';
import '../quiz/play_quiz_screen.dart';
import '../settings/new_setting_screen.dart';
import '../settings/settings_screen.dart';
import '../../services/auth_service.dart';
import 'dart:io';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> _notes = [];
  bool _isLoading = true;
  final _authService = AuthService();
  Map<String, String> _userData = {};
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadNotes();
  }

  Future<void> _loadUserData() async {
    final data = await _authService.getUserData();
    setState(() => _userData = data);
  }

  Future<void> _loadNotes() async {
    setState(() => _isLoading = true);
    
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    
    List<Map<String, dynamic>> notes = [];
    
    for (String key in keys) {
      if (key.startsWith('study_notes_')) {
        final noteString = prefs.getString(key);
        if (noteString != null) {
          try {
            final note = jsonDecode(noteString);
            note['id'] = key;
            notes.add(note);
          } catch (e) {
            print('Error loading note: $e');
          }
        }
      }
    }
    
    // Sort by timestamp (newest first)
    notes.sort((a, b) {
      final aTime = DateTime.parse(a['timestamp']);
      final bTime = DateTime.parse(b['timestamp']);
      return bTime.compareTo(aTime);
    });
    
    setState(() {
      _notes = notes;
      _isLoading = false;
    });
  }

  Future<void> _deleteNote(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(id);
    _loadNotes();
  }

  List<Map<String, dynamic>> get filteredNotes {
    if (_selectedFilter == 'All') return _notes;
    return _notes.where((note) => note['type'] == _selectedFilter).toList();
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
          text: 'Study History',
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
                    CustomText(
                      text: "Welcome back, ${_userData['name'] ?? 'User'}",
                      color: const Color(0xFF2D3436),
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                    CustomText(
                      text: _userData['email'] ?? '',
                      color: Colors.grey.shade600,
                      fontSize: 10,
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () async {
                    await Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
                    _loadUserData();
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(0xFF667EEA),
                    backgroundImage: _userData['profileImage']?.isNotEmpty == true ? FileImage(File(_userData['profileImage']!)) : null,
                    child: _userData['profileImage']?.isEmpty ?? true
                        ? Text(_userData['name']?.isNotEmpty == true ? _userData['name']![0].toUpperCase() : 'U',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18))
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Summary'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Flashcards'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Quiz'),
                ],
              ),
            ),
          ),
          
          // Content
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667EEA)),
                    ),
                  )
                : filteredNotes.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.history,
                              size: 80,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No study materials yet',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Start scanning notes to build your library',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadNotes,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredNotes.length,
                          itemBuilder: (context, index) {
                            final note = filteredNotes[index];
                            return _buildNoteCard(note);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF667EEA) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: CustomText(
          text: label,
            color: isSelected ? Colors.white : Colors.grey.shade700,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildNoteCard(Map<String, dynamic> note) {
    final type = note['type'] as String;
    final content = note['content'] as String;
    final timestamp = DateTime.parse(note['timestamp']);
    final id = note['id'] as String;

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

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: type,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3436),
                    ),
                    CustomText(
                      text: DateFormat('MMM dd, yyyy • hh:mm a').format(timestamp),
                        fontSize: 12,
                        color: Colors.grey.shade600,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const CustomText(text: 'Delete Note'),
                      content: const CustomText(
                          text: 'Are you sure you want to delete this note?',
                        maxLines: 5,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const CustomText(text: 'Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _deleteNote(id);
                          },
                          child: CustomText(text: 'Delete',color: Colors.red.shade600),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            constraints: const BoxConstraints(maxHeight: 100),
            child: SingleChildScrollView(
              child: CustomText(
                text: content,
                fontSize: 12,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Play button for Quiz and Flashcards
              if (type == 'Quiz' || type == 'Flashcards')
                ElevatedButton.icon(
                  onPressed: () {
                    if (type == 'Quiz') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PlayQuizScreen(quizContent: content),
                        ),
                      );
                    } else if (type == 'Flashcards') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FlashcardViewerScreen(flashcardContent: content),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.play_arrow, color: Colors.white),
                  label: CustomText(
                    text:type == 'Quiz' ? ' Play Quiz' : 'View Cards',
                   color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              if (type == 'Quiz' || type == 'Flashcards') const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FullContentScreen(title: type, content: content, color: color),
                    ),
                  );
                },
                icon: const Icon(Icons.visibility,color: Colors.grey,),
                label: const CustomText(text: 'View Full',fontWeight: FontWeight.w600,color: Colors.grey,),
              ),
            ],
          ),
          // Align(
          //   alignment: Alignment.centerRight,
          //   child: TextButton.icon(
          //     onPressed: () {
          //       _showFullContentDialog(type, content, color);
          //     },
          //     icon: const Icon(Icons.visibility, size: 18),
          //     label: const Text('View Full'),
          //   ),
          // ),
        ],
      ),
    );
  }

  void _showFullContentDialog(String title, String content, Color color) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: const Color(0xFFF8F9FD),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3436)),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF2D3436),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(24),
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
              child: SelectableText(
                content,
                style: const TextStyle(fontSize: 16, height: 1.8),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
