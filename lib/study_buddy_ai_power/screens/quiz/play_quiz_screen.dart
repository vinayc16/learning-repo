import 'package:flutter/material.dart';
import 'dart:math';

import 'package:learning_statemanejment/ai_power_app/widget/custom_text.dart';
import 'package:learning_statemanejment/study_buddy_ai_power/widget/custom_button.dart';

class PlayQuizScreen extends StatefulWidget {
  final String quizContent;

  const PlayQuizScreen({super.key, required this.quizContent});

  @override
  State<PlayQuizScreen> createState() => _PlayQuizScreenState();
}

class _PlayQuizScreenState extends State<PlayQuizScreen> with TickerProviderStateMixin {
  List<QuizQuestion> _questions = [];
  int _currentQuestionIndex = 0;
  Map<int, String> _selectedAnswers = {};
  bool _showResult = false;
  int _score = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _parseQuizContent();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  void _parseQuizContent() {
    final sections = widget.quizContent.split('---');
    List<QuizQuestion> questions = [];

    for (var section in sections) {
      section = section.trim();
      if (section.isEmpty) continue;

      try {
        // Extract question
        final questionMatch = RegExp(r'Question \d+:\s*(.+?)\n').firstMatch(section);
        if (questionMatch == null) continue;
        final question = questionMatch.group(1)?.trim() ?? '';

        // Extract options
        final optionA = RegExp(r'A\)\s*(.+)').firstMatch(section)?.group(1)?.trim() ?? '';
        final optionB = RegExp(r'B\)\s*(.+)').firstMatch(section)?.group(1)?.trim() ?? '';
        final optionC = RegExp(r'C\)\s*(.+)').firstMatch(section)?.group(1)?.trim() ?? '';
        final optionD = RegExp(r'D\)\s*(.+)').firstMatch(section)?.group(1)?.trim() ?? '';

        // Extract correct answer
        final correctMatch = RegExp(r'Correct answer:\s*([A-D])').firstMatch(section);
        final correctAnswer = correctMatch?.group(1) ?? 'A';

        if (question.isNotEmpty && optionA.isNotEmpty) {
          questions.add(QuizQuestion(
            question: question,
            options: [optionA, optionB, optionC, optionD],
            correctAnswer: correctAnswer,
          ));
        }
      } catch (e) {
        print('Error parsing question: $e');
      }
    }

    setState(() {
      _questions = questions;
    });
  }

  void _selectAnswer(String answer) {
    setState(() {
      _selectedAnswers[_currentQuestionIndex] = answer;
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _animationController.reset();
      setState(() {
        _currentQuestionIndex++;
      });
      _animationController.forward();
    } else {
      _calculateScore();
      setState(() {
        _showResult = true;
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _animationController.reset();
      setState(() {
        _currentQuestionIndex--;
      });
      _animationController.forward();
    }
  }

  void _calculateScore() {
    int score = 0;
    for (int i = 0; i < _questions.length; i++) {
      final selected = _selectedAnswers[i];
      final correct = _questions[i].correctAnswer;
      if (selected == correct) {
        score++;
      }
    }
    setState(() {
      _score = score;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const CustomText(text: 'Quiz',fontWeight: FontWeight.w500,fontSize: 12,),
        ),
        body: const Center(
          child: CustomText(text: 'No questions available',fontWeight: FontWeight.w500,fontSize: 12,),
        ),
      );
    }

    if (_showResult) {
      return _buildResultScreen();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF2D3436)),
          onPressed: () => Navigator.pop(context),
        ),
        title: CustomText(
          text: 'Question ${_currentQuestionIndex + 1}/${_questions.length}',
            color: Color(0xFF2D3436),
            fontSize: 16,
            fontWeight: FontWeight.bold,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / _questions.length,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF667EEA)),
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Question Card
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF667EEA).withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.help_outline, color: Colors.white,size: 20,),
                              SizedBox(width: 8),
                              CustomText(
                                text: 'Question',
                                  color: Colors.white70,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          CustomText(
                            text:_questions[_currentQuestionIndex].question,
                              color: Colors.white,
                              fontSize: 12,
                              maxLines: _questions[_currentQuestionIndex].question.length,
                              fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Options
                    const CustomText(
                     text: 'Choose your answer:',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3436),
                    ),
                    const SizedBox(height: 16),

                    ...List.generate(
                      _questions[_currentQuestionIndex].options.length,
                      (index) {
                        final option = _questions[_currentQuestionIndex].options[index];
                        final optionLetter = String.fromCharCode(65 + index); // A, B, C, D
                        final isSelected = _selectedAnswers[_currentQuestionIndex] == optionLetter;

                        return _buildOptionCard(
                          optionLetter,
                          option,
                          isSelected,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Navigation Buttons
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (_currentQuestionIndex > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousQuestion,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: Color(0xFF667EEA)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const CustomText(text: 'Previous',fontWeight: FontWeight.w600,),
                      ),
                    ),
                  if (_currentQuestionIndex > 0) const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _selectedAnswers.containsKey(_currentQuestionIndex)
                          ? _nextQuestion
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF667EEA),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: CustomText(
                        text:_currentQuestionIndex == _questions.length - 1
                            ? 'Show Results'
                            : 'Next Question',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(String letter, String text, bool isSelected) {
    return GestureDetector(
      onTap: () => _selectAnswer(letter),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF667EEA) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF667EEA) : Colors.grey.shade300,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0xFF667EEA).withOpacity(0.3)
                  : Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : const Color(0xFF667EEA).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomText(
                  text: letter,
                    color: isSelected ? const Color(0xFF667EEA) : const Color(0xFF667EEA),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomText(
                text: text,
                  color: isSelected ? Colors.white : const Color(0xFF2D3436),
                  fontSize: 12,
                  maxLines: text.length,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Colors.white,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultScreen() {
    final percentage = (_score / _questions.length * 100).toInt();
    final isPassed = percentage >= 60;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    
                    // Trophy Icon
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 800),
                      builder: (context, double value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Container(
                            padding: const EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isPassed ? Colors.amber.shade100 : Colors.grey.shade200,
                            ),
                            child: Icon(
                              isPassed ? Icons.emoji_events : Icons.sentiment_neutral,
                              size: 80,
                              color: isPassed ? Colors.amber : Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // Result Title
                    CustomText(
                      text: isPassed ? '🎉 Congratulations!' : '📚 Keep Practicing!',
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3436),
                    ),
                    const SizedBox(height: 8),
                    CustomText(
                      text: isPassed ? 'You passed the quiz!' : 'You need more practice',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                    ),
                    const SizedBox(height: 32),

                    // Score Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Circular Progress with Score
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                height: 140,
                                width: 140,
                                child: CircularProgressIndicator(
                                  value: percentage / 100,
                                  strokeWidth: 12,
                                  backgroundColor: Colors.grey.shade100,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    isPassed ? const Color(0xFF667EEA) : Colors.redAccent,
                                  ),
                                  strokeCap: StrokeCap.round,
                                ),
                              ),
                              Column(
                                children: [
                                  CustomText(
                                    text: '$percentage%',
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF2D3436),
                                  ),
                                  CustomText(
                                    text: 'Score',
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Status Message using your CustomText
                          CustomText(
                            text: isPassed ? '🎉 You passed the quiz!' : "opp's You need more practice",
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2D3436),
                          ),
                          const SizedBox(height: 8),

                          // Detail Text
                          CustomText(
                            text: '$_score out of ${_questions.length} questions correct',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600,
                          ),

                          const SizedBox(height: 20),

                          // Feedback Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: (isPassed ? Colors.green : Colors.orange).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: CustomText(
                              text: isPassed ? "Excellent Job!" : "Keep Learning!",
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isPassed ? Colors.green.shade700 : Colors.orange.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Review Answers
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomText(
                            text: 'Review Answers',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3436),
                          ),
                          const SizedBox(height: 16),
                          ...List.generate(_questions.length, (index) {
                            final question = _questions[index];
                            final selected = _selectedAnswers[index];
                            final correct = question.correctAnswer;
                            final isCorrect = selected == correct;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isCorrect
                                    ? Colors.green.shade50.withOpacity(0.5)
                                    : Colors.red.shade50.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(12),
                                // border: Border.all(
                                //   color: isCorrect ? Colors.green : Colors.red,
                                //   width: 1,
                                // ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isCorrect ? Icons.check_circle : Icons.cancel,
                                    color: isCorrect ? Colors.green : Colors.red,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          text:'Q${index + 1}: ${question.question.substring(0, min(40, question.question.length))}...',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 10,
                                          maxLines: question.question.length,
                                        ),
                                        if (!isCorrect) ...[
                                          const SizedBox(height: 4),
                                          CustomText(
                                            text:'Correct: $correct',
                                              fontSize: 12,
                                              color: Colors.grey.shade700,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Buttons
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    text: "Close",
                    width: 150,
                    height: 45,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.red.shade700,
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 12),
                  CustomButton(
                    text: "Retry Quiz",
                    width: 150,
                    height: 45,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF667EEA),
                    onTap: () {
                      setState(() {
                        _currentQuestionIndex = 0;
                        _selectedAnswers.clear();
                        _showResult = false;
                        _score = 0;
                      });
                      _animationController.forward();
                    },),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final String correctAnswer;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });
}
