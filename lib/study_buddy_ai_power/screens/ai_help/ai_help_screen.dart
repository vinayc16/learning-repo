import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:learning_statemanejment/ai_power_app/widget/custom_text.dart';
import 'package:share_plus/share_plus.dart';
import '../../services/auth_service.dart';
import '../settings/settings_screen.dart';

class AIHelpScreen extends StatefulWidget {
  const AIHelpScreen({super.key});

  @override
  State<AIHelpScreen> createState() => _AIHelpScreenState();
}

class _AIHelpScreenState extends State<AIHelpScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  final _authService = AuthService();
  Map<String, String> _userData = {};

  FlutterTts flutterTts = FlutterTts();
  bool _isSpeaking = false;
  bool _isPaused = false;

  static const String _geminiApiKey = 'AIzaSyCqswhyVT7ceN4Hs622FOXZEsali3SL4M4';
  late final GenerativeModel _gemini;

  @override
  void initState() {
    super.initState();
    _gemini = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: _geminiApiKey,
    );
    _loadUserData();
    _addWelcomeMessage();

    flutterTts.setStartHandler(() {
      setState(() {
        _isSpeaking = true;
        _isPaused = false;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        _isSpeaking = false;
        _isPaused = false;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        _isSpeaking = false;
        _isPaused = false;
      });
    });
  }

  Future<void> _loadUserData() async {
    final data = await _authService.getUserData();
    setState(() => _userData = data);
  }

  void _addWelcomeMessage() {
    setState(() {
      _messages.add(
        ChatMessage(
          text: "👋 Hi! I'm your AI study coach. I'm here to help you with:\n\n"
              "• Explaining difficult concepts\n"
              "• Solving practice problems\n"
              "• Study tips and techniques\n"
              "• Homework help\n"
              "• Exam preparation\n\n"
              "What would you like help with today?",
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: text,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
      _isTyping = true;
    });

    _controller.clear();
    _scrollToBottom();

    try {
      final prompt = '''
You are a helpful AI study coach assisting students. Your role is to:
- Explain concepts clearly and simply
- Help solve problems step-by-step
- Provide study tips and motivation
- Answer academic questions
- Be encouraging and supportive

Student question: $text

Provide a helpful, clear, and encouraging response.
''';

      final content = [Content.text(prompt)];
      final response = await _gemini.generateContent(content);

      // Clean the response text to remove markdown characters
      final cleanedText = response.text
          ?.replaceAll(RegExp(r'^#+\s*', multiLine: true), '')
          .replaceAll('*', '')
          .trim()
          ?? "I'm sorry, I couldn't generate a response.";

      setState(() {
        _messages.add(
          ChatMessage(
            text: cleanedText,
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
        _isTyping = false;
      });

      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.add(
          ChatMessage(
            text: "Sorry, I encountered an error. Please try again.",
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
        _isTyping = false;
      });
    }
  }

  Future<void> _pause() async {
    await flutterTts.pause();
    setState(() {
      _isPaused = true;
    });
  }

  Future<void> _resume(String text) async {
    // flutter_tts resumes automatically on Android
    await flutterTts.speak(text);
    setState(() {
      _isPaused = false;
    });
  }

  Future<void> _stop() async {
    await flutterTts.stop();
    setState(() {
      _isSpeaking = false;
      _isPaused = false;
    });
  }

  Future<void> _share(String message) async {
    SharePlus.instance.share(
      ShareParams(
          text: message,
          title: "Note Content"
      ),
    );
  }


  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
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
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF667EEA).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.psychology,
                color: Color(0xFF667EEA),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'AI Study Coach',
                    color: Color(0xFF2D3436),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                ),
                CustomText(
                  text: 'Online • Ready to help',
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () async {
                // await Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (_) => const SettingsScreen()),
                // );
                // _loadUserData();
              },
              child: InstaImageViewer(
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFF667EEA),
                  backgroundImage: _userData['profileImage']?.isNotEmpty == true
                      ? FileImage(File(_userData['profileImage']!))
                      : null,
                  child: _userData['profileImage']?.isEmpty ?? true
                      ? CustomText(
                          text:_userData['name']?.isNotEmpty == true
                              ? _userData['name']![0].toUpperCase()
                              : 'U',
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                        )
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Suggestion chips
          if (_messages.length == 1) ...[
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'Quick suggestions:',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildSuggestionChip('Explain photosynthesis'),
                      _buildSuggestionChip('Help with algebra'),
                      _buildSuggestionChip('Study tips for exams'),
                      _buildSuggestionChip('Improve focus'),
                    ],
                  ),
                ],
              ),
            ),
          ],

          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),

          // Typing indicator
          if (_isTyping)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildTypingDot(0),
                        const SizedBox(width: 4),
                        _buildTypingDot(1),
                        const SizedBox(width: 4),
                        _buildTypingDot(2),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Input field
          Container(
            padding: const EdgeInsets.all(16),
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
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Ask me anything...',
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      onSubmitted: _sendMessage,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Container(
                //   height: 35,
                //   width: 35,
                //   decoration: const BoxDecoration(
                //     gradient: LinearGradient(
                //       colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                //     ),
                //     shape: BoxShape.circle,
                //   ),
                //   child: IconButton(
                //     icon: const Icon(Icons.mic, color: Colors.white),
                //     onPressed: () => _sendMessage(_controller.text),
                //   ),
                // ),
                // const SizedBox(width: 4,),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () => _sendMessage(_controller.text),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String text) {
    return GestureDetector(
      onTap: () => _sendMessage(text),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF667EEA).withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF667EEA).withOpacity(0.3)),
        ),
        child: CustomText(
          text: text,
            color: Color(0xFF667EEA),
            fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final bool isWelcomeMessage = message.text.startsWith("👋 Hi!");

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF667EEA).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.psychology,
                color: Color(0xFF667EEA),
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isUser
                    ? const Color(0xFF667EEA)
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomText(
                    text:message.text,
                      color: message.isUser ? Colors.white : Colors.black87,
                      fontSize: 15,
                    maxLines: message.text.length,
                  ),
                  if (!message.isUser && !isWelcomeMessage)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.copy, size: 16),
                            // color: Colors.grey,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(text: message.text),
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Copied to clipboard'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                          // ▶️ Play (only when idle)
                          if (!_isSpeaking)
                            IconButton(
                              icon: const Icon(Icons.volume_up_outlined, size: 16),
                              onPressed:() => flutterTts.speak(message.text),
                            ),

                          // ⏸ Pause (only when speaking & not paused)
                          if (_isSpeaking && !_isPaused)
                            IconButton(
                              icon: const Icon(Icons.pause_circle, size: 16),
                              onPressed: _pause,
                            ),

                          // ▶️ Resume (only when paused)
                          if (_isPaused)
                            IconButton(
                              icon: const Icon(Icons.play_circle, size: 16),
                              onPressed: () => _resume(message.text),
                            ),

                          // ⏹ Stop (when speaking or paused)
                          if (_isSpeaking || _isPaused)
                            IconButton(
                              icon: const Icon(Icons.stop_circle, size: 16),
                              onPressed: _stop,
                            ),
                          IconButton(
                            icon: const Icon(Icons.share, size: 16),
                            onPressed: () => _share(message.text),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFF667EEA),
              backgroundImage: _userData['profileImage']?.isNotEmpty == true
                  ? FileImage(File(_userData['profileImage']!))
                  : null,
              child: _userData['profileImage']?.isEmpty ?? true
                  ? CustomText(
                      text:_userData['name']?.isNotEmpty == true
                          ? _userData['name']![0].toUpperCase()
                          : 'U',
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                    )
                  : null,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return TweenAnimationBuilder(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (index * 200)),
      builder: (context, double value, child) {
        return Opacity(
          opacity: (value * 2).clamp(0.3, 1.0),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey.shade600,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
      onEnd: () => setState(() {}),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
