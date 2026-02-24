import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:learning_statemanejment/ai_power_app/widget/custom_text.dart';

class FlashcardViewerScreen extends StatefulWidget {
  final String flashcardContent;

  const FlashcardViewerScreen({super.key, required this.flashcardContent});

  @override
  State<FlashcardViewerScreen> createState() => _FlashcardViewerScreenState();
}

class _FlashcardViewerScreenState extends State<FlashcardViewerScreen>
    with TickerProviderStateMixin {
  List<Flashcard> _flashcards = [];
  int _currentIndex = 0;
  bool _isFlipped = false;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _parseFlashcards();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
  }

  void _parseFlashcards() {
    final sections = widget.flashcardContent.split('---');
    List<Flashcard> cards = [];

    for (var section in sections) {
      section = section.trim();
      if (section.isEmpty) continue;

      try {
        final frontMatch = RegExp(r'Front:\s*(.+?)(?=\nBack:)', dotAll: true).firstMatch(section);
        final backMatch = RegExp(r'Back:\s*(.+)', dotAll: true).firstMatch(section);

        if (frontMatch != null && backMatch != null) {
          final front = frontMatch.group(1)?.trim() ?? '';
          final back = backMatch.group(1)?.trim() ?? '';

          if (front.isNotEmpty && back.isNotEmpty) {
            cards.add(Flashcard(front: front, back: back));
          }
        }
      } catch (e) {
        print('Error parsing flashcard: $e');
      }
    }

    setState(() {
      _flashcards = cards;
    });
  }

  void _flipCard() {
    if (_flipController.isAnimating) return;

    if (_isFlipped) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
    setState(() {
      _isFlipped = !_isFlipped;
    });
  }

  void _nextCard() {
    if (_currentIndex < _flashcards.length - 1) {
      setState(() {
        _currentIndex++;
        if (_isFlipped) {
          _isFlipped = false;
          _flipController.reset();
        }
      });
    }
  }

  void _previousCard() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        if (_isFlipped) {
          _isFlipped = false;
          _flipController.reset();
        }
      });
    }
  }

  String _highlightContent(String text) {
    // This function returns the text as-is. We'll use RichText to highlight bold text
    return text;
  }

  Widget _buildHighlightedText(String text) {
    final List<TextSpan> spans = [];
    final boldPattern = RegExp(r'\*\*(.+?)\*\*');
    int lastIndex = 0;

    for (final match in boldPattern.allMatches(text)) {
      // Add text before bold
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: text.substring(lastIndex, match.start),
          style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
        ));
      }

      // Add bold highlighted text
      spans.add(TextSpan(
        text: match.group(1),
        style: const TextStyle(
          fontSize: 16,
          height: 1.6,
          fontWeight: FontWeight.bold,
          color: Color(0xFF667EEA),
          backgroundColor: Color(0xFFEEF2FF),
        ),
      ));

      lastIndex = match.end;
    }

    // Add remaining text
    if (lastIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastIndex),
        style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
      ));
    }

    return RichText(text: TextSpan(children: spans));
  }

  @override
  Widget build(BuildContext context) {
    if (_flashcards.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const CustomText(text: 'Flashcards',fontWeight: FontWeight.bold,fontSize: 14,),
        ),
        body: const Center(
          child: CustomText(text: 'No flashcards available'),
        ),
      );
    }

    final currentCard = _flashcards[_currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF2D3436)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              text: 'Flashcards',
                color: Color(0xFF2D3436),
                fontWeight: FontWeight.w600,
                fontSize: 16,
            ),
            CustomText(
              text: '${_currentIndex + 1} of ${_flashcards.length}',
                color: Colors.grey.shade600,
                fontSize: 12,
                fontWeight: FontWeight.w500,
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF667EEA).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.style,
                  color: Color(0xFF667EEA),
                  size: 16,
                ),
                const SizedBox(width: 4),
                CustomText(
                  text:'${_flashcards.length}',
                    color: Color(0xFF667EEA),
                    fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Bar
          LinearProgressIndicator(
            value: (_currentIndex + 1) / _flashcards.length,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFE84393)),
          ),

          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Instruction
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE84393).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.touch_app,
                        color: Color(0xFFE84393),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      CustomText(
                        text: 'Tap card to flip',
                          color: Colors.grey.shade500,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Flashcard
                Expanded(
                  child: GestureDetector(
                    onTap: _flipCard,
                    child: AnimatedBuilder(
                      animation: _flipAnimation,
                      builder: (context, child) {
                        final angle = _flipAnimation.value * math.pi;
                        final transform = Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(angle);

                        return Transform(
                          transform: transform,
                          alignment: Alignment.center,
                          child: angle >= math.pi / 2
                              ? Transform(
                                  transform: Matrix4.identity()..rotateY(math.pi),
                                  alignment: Alignment.center,
                                  child: _buildCardBack(currentCard.back),
                                )
                              : _buildCardFront(currentCard.front),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Navigation Dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    math.min(_flashcards.length, 10),
                    (index) {
                      final dotIndex = _currentIndex < 10
                          ? index
                          : (_currentIndex - 9) + index;
                      
                      if (dotIndex >= _flashcards.length) return const SizedBox.shrink();
                      
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: dotIndex == _currentIndex ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: dotIndex == _currentIndex
                              ? const Color(0xFFE84393)
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // Bottom Navigation
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
                // Previous Button
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _currentIndex > 0 ? _previousCard : null,
                    icon: const Icon(Icons.arrow_back),
                    label: const CustomText(text: 'Previous',fontWeight: FontWeight.w600,color: Colors.grey,),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Color(0xFFE84393)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Flip Button
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE84393), Color(0xFFFF6B6B)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: _flipCard,
                    icon: const Icon(Icons.flip, color: Colors.white),
                    iconSize: 28,
                    padding: const EdgeInsets.all(12),
                  ),
                ),
                const SizedBox(width: 12),

                // Next Button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _currentIndex < _flashcards.length - 1
                        ? _nextCard
                        : null,
                    icon: const Icon(Icons.arrow_forward, color: Colors.white),
                    label: const CustomText(
                      text: 'Next',
                     fontWeight: FontWeight.w600,
                     color: Colors.white,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE84393),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardFront(String content) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE84393), Color(0xFFFF6B6B)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE84393).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.loyalty, color: Colors.white, size: 16),
                SizedBox(width: 8),
                CustomText(
                  text: 'QUESTION',
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: _buildHighlightedTextWhite(content),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Icon(
            Icons.touch_app,
            color: Colors.white54,
            size: 32,
          ),
        ],
      ),
    );
  }

  Widget _buildCardBack(String content) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE84393), width: 3),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE84393).withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFE84393).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lightbulb, color: Color(0xFFE84393), size: 16),
                SizedBox(width: 8),
                CustomText(
                  text: 'ANSWER',
                    color: Color(0xFFE84393),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: _buildHighlightedText(content),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Icon(
            Icons.check_circle,
            color: const Color(0xFFE84393).withOpacity(0.3),
            size: 32,
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightedTextWhite(String text) {
    final List<TextSpan> spans = [];
    final boldPattern = RegExp(r'\*\*(.+?)\*\*');
    int lastIndex = 0;

    for (final match in boldPattern.allMatches(text)) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: text.substring(lastIndex, match.start),
          style: const TextStyle(fontSize: 20, height: 1.6, color: Colors.white),
        ));
      }

      spans.add(TextSpan(
        text: match.group(1),
        style: const TextStyle(
          fontSize: 22,
          height: 1.6,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              blurRadius: 4,
              color: Colors.black26,
            ),
          ],
        ),
      ));

      lastIndex = match.end;
    }

    if (lastIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastIndex),
        style: const TextStyle(fontSize: 20, height: 1.6, color: Colors.white),
      ));
    }

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(children: spans),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }
}

class Flashcard {
  final String front;
  final String back;

  Flashcard({required this.front, required this.back});
}
