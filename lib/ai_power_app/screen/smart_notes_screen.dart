import 'package:flutter/material.dart';
import 'package:learning_statemanejment/ai_power_app/helper/app_font.dart';

import '../service/ai_service.dart';
import '../widget/custom_text.dart';

class SmartNotesScreen extends StatefulWidget {
  @override
  State<SmartNotesScreen> createState() => _SmartNotesScreenState();
}

class _SmartNotesScreenState extends State<SmartNotesScreen> {
  final TextEditingController _controller = TextEditingController();
  String summary = "";
  List<String> keywords = [];
  bool loading = false;

  // void extractKeywords(String text) {
  //   final stopWords = {
  //     "the", "is", "and", "to", "a", "of", "in", "for", "on", "with", "as",
  //     "an", "by", "at", "from", "this", "that", "it", "are", "was"
  //   };
  //
  //   final words = text
  //       .toLowerCase()
  //       .replaceAll(RegExp(r'[^a-z\s]'), '')
  //       .split(' ')
  //       .where((word) =>
  //   word.length > 3 && !stopWords.contains(word))
  //       .toList();
  //
  //   final Map<String, int> frequency = {};
  //
  //   for (var word in words) {
  //     frequency[word] = (frequency[word] ?? 0) + 1;
  //   }
  //
  //   final sortedKeywords = frequency.entries.toList()
  //     ..sort((a, b) => b.value.compareTo(a.value));
  //
  //   keywords = sortedKeywords
  //       .take(5)
  //       .map((e) => e.key)
  //       .toList();
  // }


  Future<void> analyzeNote() async {
    if (_controller.text.isEmpty) return;

    setState(() => loading = true);

    //extractKeywords(_controller.text);
    keywords = await AiService.extractKeywordsAI(_controller.text);
    summary = await AiService.summarizeText(_controller.text);

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.auto_awesome, color: Colors.blue, size: 20),
            ),
            const SizedBox(width: 12),
            CustomText(
              text: "AI Smart Notes",
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.poppins,
              color: Colors.black87,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Write Notes Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
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
                        Icon(Icons.edit_note, color: Colors.blue, size: 20),
                        const SizedBox(width: 8),
                        CustomText(
                          text: "Write Your Notes",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: AppFonts.poppins,
                          color: Colors.black87,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _controller,
                      maxLines: 5,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: AppFonts.poppins,
                      ),
                      decoration: InputDecoration(
                        fillColor: Colors.grey[50],
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.blue, width: 2),
                        ),
                        hintText: "Type your notes here...",
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontFamily: AppFonts.poppins,
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: loading ? null : analyzeNote,
                        child: loading
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.psychology, size: 20),
                            const SizedBox(width: 8),
                            CustomText(
                              text: "Analyze with AI",
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              fontFamily: AppFonts.poppins,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Summary Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
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
                            color: Colors.purple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.summarize, color: Colors.purple, size: 18),
                        ),
                        const SizedBox(width: 10),
                        CustomText(
                          text: "Summary",
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          fontFamily: AppFonts.poppins,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    CustomText(
                      text: summary.isEmpty ? "No summary yet. Add your notes and analyze to see a summary." : summary,
                      color: summary.isEmpty ? Colors.grey[400]! : Colors.grey[700]!,
                      fontSize: 13,
                      maxLines: 50,
                      fontFamily: AppFonts.poppins,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Keywords Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
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
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.key, color: Colors.orange, size: 18),
                        ),
                        const SizedBox(width: 10),
                        CustomText(
                          text: "Keywords",
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          fontFamily: AppFonts.poppins,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    keywords.isEmpty
                        ? CustomText(
                      text: "No keywords yet. Analyze your notes to extract keywords.",
                      color: Colors.grey[400]!,
                      fontSize: 13,
                      maxLines: 20,
                      fontFamily: AppFonts.poppins,
                    )
                        : Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: keywords
                          .map(
                            (k) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.blue.withOpacity(0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.label, size: 14, color: Colors.blue),
                              const SizedBox(width: 4),
                              Text(
                                k,
                                style: TextStyle(
                                  color: Colors.blue[700],
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  fontFamily: AppFonts.poppins,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}