import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:learning_statemanejment/study_buddy_ai_power/utils/apploader.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ai_power_app/widget/custom_text.dart';
import '../screens/quiz/play_quiz_screen.dart';
import '../screens/flashcards/flashcard_viewer_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class GenerateMaterialsScreen extends StatefulWidget {
  final String? imagePath;
  final String? extractedText;

  const GenerateMaterialsScreen({
    super.key,
    this.imagePath,
    this.extractedText,
  });

  @override
  State<GenerateMaterialsScreen> createState() => _GenerateMaterialsScreenState();
}

class _GenerateMaterialsScreenState extends State<GenerateMaterialsScreen> {
  bool summarySelected = true;
  bool flashcardsSelected = false;
  bool quizSelected = false;
  bool isGenerating = false;

  static const String _geminiApiKey = 'AIzaSyCqswhyVT7ceN4Hs622FOXZEsali3SL4M4';
  late final GenerativeModel _gemini;

  @override
  void initState() {
    super.initState();
    _gemini = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: _geminiApiKey,
    );
  }

  Future<void> _generateMaterials() async {
    if (widget.extractedText == null || widget.extractedText!.isEmpty) {
      Fluttertoast.showToast(msg: "No text available to generate materials");
      return;
    }

    if (!summarySelected && !flashcardsSelected && !quizSelected) {
      Fluttertoast.showToast(msg: "Please select at least one option");
      return;
    }

    setState(() => isGenerating = true);

    try {
      List<Map<String, String>> results = [];

      if (summarySelected) {
        final summary = await _generateSummary();
        if (summary != null) {
          results.add({'type': 'Summary', 'content': summary});
          await _saveNote('Summary', summary);
        }
      }

      if (flashcardsSelected) {
        final flashcards = await _generateFlashcards();
        if (flashcards != null) {
          results.add({'type': 'Flashcards', 'content': flashcards});
          await _saveNote('Flashcards', flashcards);
        }
      }

      if (quizSelected) {
        final quiz = await _generateQuiz();
        if (quiz != null) {
          results.add({'type': 'Quiz', 'content': quiz});
          await _saveNote('Quiz', quiz);
        }
      }

      setState(() => isGenerating = false);

      if (!mounted) return;

      // Navigate to results page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => GeneratedResultsScreen(results: results),
        ),
      );
    } catch (e) {
      setState(() => isGenerating = false);
      Fluttertoast.showToast(msg: "Error generating materials: $e");
    }
  }

  Future<String?> _generateSummary() async {
    final prompt = '''
You are an excellent study assistant.
Create a concise, clear summary of the following notes using bullet points and important terms in **bold**.
Keep it under 300 words.

Notes:
${widget.extractedText}
''';
    return await _callGemini(prompt);
  }

  Future<String?> _generateFlashcards() async {
    final prompt = '''
Create 8-12 high-quality Anki-style flashcards from these notes.
Format each card exactly like this:

Front: question or term
Back: answer or definition

Separate cards with --- 

Notes:
${widget.extractedText}
''';
    return await _callGemini(prompt);
  }

  Future<String?> _generateQuiz() async {
    final prompt = '''
Create a 10-question multiple-choice quiz based on these notes.
Format:

Question 1: ............?
A) ...
B) ...
C) ...
D) ...

Correct answer: B

Separate questions with ---

Notes:
${widget.extractedText}
''';
    return await _callGemini(prompt);
  }

  Future<String?> _callGemini(String prompt) async {
    try {
      // Prepare the content for Gemini API
      final content = [Content.text(prompt)];

      // Make the API call and wait for the response
      final response = await _gemini.generateContent(content);

      // If the response is not null, clean and return the text
      final cleanedText = response.text
          ?.replaceAll(RegExp(r'^#+\s*', multiLine: true), '') // Remove markdown headings
          .replaceAll('*', '') // Remove asterisks
          .trim()
          ?? "I'm sorry, I couldn't generate a response."; // Default text if response is null

      return cleanedText;
    } catch (e) {
      // Show error toast if anything goes wrong
      Fluttertoast.showToast(msg: "Gemini error: $e", toastLength: Toast.LENGTH_LONG);
      return null;
    }
  }

  Future<void> _saveNote(String type, String content) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'study_notes_${DateTime.now().millisecondsSinceEpoch}';
    final data = {'type': type, 'content': content, 'timestamp': DateTime.now().toIso8601String()};
    await prefs.setString(key, jsonEncode(data));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F8),
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Color(0xFF111418)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const CustomText(
          text: 'Generate Materials',
         color: Color(0xFF111418), fontSize: 14, fontWeight: FontWeight.bold,
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF137FEC).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const CustomText(
              text: 'Step 2/2',
              color: Color(0xFF137FEC), fontSize: 12, fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(10),
            children: [
              _buildDocumentPreview(),
              const SizedBox(height: 12),
              const CustomText(
               text: 'Choose AI Magic',
               fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111418),
              ),
              const CustomText(
                text: 'Select one or more formats for your study materials.',
                fontSize: 12, color: Color(0xFF617589),
                maxLines: 5,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(height: 12),
              _buildMagicOption(
                title: 'Generate Summary',
                description: 'A concise breakdown of key concepts and core themes extracted from your notes.',
                icon: Icons.auto_awesome,
                iconColor: Colors.blue,
                bgColor: const Color(0xFFEFF6FF),
                isSelected: summarySelected,
                onChanged: (val) => setState(() => summarySelected = val!),
              ),
              _buildMagicOption(
                title: 'Create Flashcards',
                description: 'Digital cards perfect for active recall and quick daily memorization sessions.',
                icon: Icons.style,
                iconColor: Colors.purple,
                bgColor: const Color(0xFFFAF5FF),
                isSelected: flashcardsSelected,
                onChanged: (val) => setState(() => flashcardsSelected = val!),
              ),
              _buildMagicOption(
                title: 'Build a Quiz',
                description: 'Test your knowledge with multiple-choice questions generated from your content.',
                icon: Icons.quiz,
                iconColor: Colors.orange,
                bgColor: const Color(0xFFFFF7ED),
                isSelected: quizSelected,
                onChanged: (val) => setState(() => quizSelected = val!),
              ),
              const SizedBox(height: 120),
            ],
          ),
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildDocumentPreview() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.description, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CustomText(
                        text:widget.imagePath?.split('/').last ?? 'Scanned Document',
                       fontWeight: FontWeight.bold, fontSize: 16,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const CustomText(
                  text: 'SCANNED DOCUMENT',
                    color: Color(0xFF617589),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const CustomText(text: 'Retake',fontWeight: FontWeight.w600,),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF3F4F6),
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(width: 12),
          if (widget.imagePath != null)
            Container(
              width: 80,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade300,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: InstaImageViewer(
                  child: Image.file(
                    File(widget.imagePath!),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.image, size: 40, color: Colors.grey),
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMagicOption({
    required String title,
    required String description,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required bool isSelected,
    required ValueChanged<bool?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () => onChanged(!isSelected),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFF137FEC) : Colors.transparent,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: title,
                      fontWeight: FontWeight.bold, fontSize: 14,
                    ),
                    const SizedBox(height: 4),
                    CustomText(
                      text: description,
                      maxLines: description.length,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF617589), fontSize: 12,
                    ),
                  ],
                ),
              ),
              Checkbox(
                value: isSelected,
                onChanged: onChanged,
                shape: const CircleBorder(),
                activeColor: const Color(0xFF137FEC),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          border: Border(top: BorderSide(color: Colors.grey.shade100)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: isGenerating ? null : _generateMaterials,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF667EEA),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  shadowColor: const Color(0xFF667EEA).withOpacity(0.4),
                ),
                child: isGenerating
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: AppLoader(color: Colors.white)
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.auto_fix_high, color: Colors.white),
                          SizedBox(width: 8),
                          CustomText(
                            text: 'Generate Now',
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 12),
            CustomText(
              text: 'POWERED BY GOOGLE GEMINI',
                color: Colors.grey.shade500,
                fontSize: 10,
                fontWeight: FontWeight.bold,
            )
          ],
        ),
      ),
    );
  }
}

// Results Screen
class GeneratedResultsScreen extends StatelessWidget {
  final List<Map<String, String>> results;

  const GeneratedResultsScreen({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3436)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const CustomText(
          text: 'Generated Materials',
            color: Color(0xFF2D3436),
            fontWeight: FontWeight.bold,
        ),
      ),
      body: results.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  CustomText(
                    text: 'No materials generated',
                   fontSize: 18, color: Colors.grey.shade600,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final result = results[index];
                return _buildResultCard(
                  context,
                  type: result['type']!,
                  content: result['content']!,
                );
              },
            ),
    );
  }

  Widget _buildResultCard(BuildContext context, {required String type, required String content}) {
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
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 25),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomText(
                  text: type,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3436),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.open_in_full,size: 22,),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FullContentScreen(title: type, content: content, color: color),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            constraints: const BoxConstraints(maxHeight: 300),
            child: SingleChildScrollView(
              child: CustomText(
                text: content,
                fontSize: 12,
                maxLines: content.length,
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
                icon: const Icon(Icons.visibility,color: Colors.black54,),
                label: const CustomText(text: 'View Full',fontWeight: FontWeight.w600,color: Colors.black54,),
              ),
            ],
          ),
            ],
          ),

    );
  }
}

// Full Content Screen


// --- FULL CONTENT SCREEN WITH EDIT, SHARE, FONT & PDF ---
class FullContentScreen extends StatefulWidget {
  final String title;
  final String content;
  final Color color;

  const FullContentScreen({
    super.key,
    required this.title,
    required this.content,
    required this.color,
  });

  @override
  State<FullContentScreen> createState() => _FullContentScreenState();
}

class _FullContentScreenState extends State<FullContentScreen> {
  double _currentFontSize = 14.0;

  // PDF
  Future<void> _generatePdf() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(widget.title, style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Divider(thickness: 1),
              pw.SizedBox(height: 15),
              pw.Text(widget.content, style: const pw.TextStyle(fontSize: 14)),
              pw.Spacer(),
              pw.Divider(thickness: 0.5),
              pw.Text("Generated by Study Buddy AI Power App", style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: '${widget.title}_StudyBuddy',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3436)),
          onPressed: () => Navigator.pop(context),
        ),
        title: CustomText(
          text: widget.title,
          color: const Color(0xFF2D3436),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          // ફોન્ટ ઘટાડવા માટે
          IconButton(
            icon: const Icon(Icons.remove_circle_outline, size: 20, color: Colors.grey),
            onPressed: () => setState(() => _currentFontSize = (_currentFontSize > 10) ? _currentFontSize - 2 : 10),
          ),
          // ફોન્ટ વધારવા માટે
          IconButton(
            icon: const Icon(Icons.add_circle_outline, size: 20, color: Colors.grey),
            onPressed: () => setState(() => _currentFontSize = (_currentFontSize < 32) ? _currentFontSize + 2 : 32),
          ),
          // PDF બટન
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, color: Colors.redAccent),
            onPressed: _generatePdf,
          ),
          // શેર બટન
          IconButton(
            icon: const Icon(Icons.share, color: Color(0xFF137FEC)),
            onPressed: () => Share.share("${widget.title}\n\n${widget.content}"),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          width: double.infinity,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: widget.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      widget.title == 'Summary' ? Icons.summarize : widget.title == 'Flashcards' ? Icons.style : Icons.quiz,
                      color: widget.color,
                      size: 25,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomText(
                      text: widget.title,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3436),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SelectableText(
                widget.content,
                style: TextStyle(
                  fontSize: _currentFontSize,
                  height: 1.8,
                  color: const Color(0xFF2D3436),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}