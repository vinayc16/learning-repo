import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:learning_statemanejment/ai_power_app/widget/custom_text.dart';
import 'package:learning_statemanejment/study_buddy_ai_power/widget/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../screen/category_screen.dart';
import '../../services/auth_service.dart';
import '../../services/permission_service.dart';
import '../../widget/extract_text.dart';
import '../settings/new_setting_screen.dart';
import '../settings/settings_screen.dart';
import '../auth/login_screen.dart';

class StudyBuddyHomeScreen extends StatefulWidget {
  const StudyBuddyHomeScreen({super.key});

  @override
  State<StudyBuddyHomeScreen> createState() => _StudyBuddyHomeScreenState();
}

class _StudyBuddyHomeScreenState extends State<StudyBuddyHomeScreen> with SingleTickerProviderStateMixin {
  String? _extractedText;
  bool _isProcessing = false;
  bool _isGenerating = false;
  String? _uploadedImagePath;
  Map<String, String> _userData = {};

  final TextRecognizer _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  final ImagePicker _picker = ImagePicker();
  final _authService = AuthService();
  final _permissionService = PermissionService();

  //static const String _geminiApiKey = 'YOUR_API_KEY_HERE';

  ///late final GenerativeModel _gemini;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // _gemini = GenerativeModel(
    //   model: 'gemini-1.5-flash',
    //   apiKey: _geminiApiKey,
    // );
    _loadUserData();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  Future<void> _loadUserData() async {
    final data = await _authService.getUserData();
    setState(() => _userData = data);
  }

  // --- REUSABLE BOTTOM SHEET ---
  void _showImagePickerSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                height: 5,
                width: 40,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.camera_alt_outlined, color: Colors.grey),
              title: CustomText(
                text: 'Take a photo',
                color: Colors.black54,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              onTap: () async {
                Navigator.of(context).pop();
                _pickAndProcessImage(fromCamera: true);
              },
            ),
            ListTile(
              leading: Icon(Icons.image_outlined, color: Colors.grey),
              title: CustomText(
                text: 'Choose from gallery',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
              onTap: () async {
                Navigator.of(context).pop();
                _pickAndProcessImage(fromCamera: false);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickAndProcessImage({bool fromCamera = false}) async {
    final permissionResult = fromCamera
        ? await _permissionService.checkAndRequestCameraPermission()
        : await _permissionService.checkAndRequestStoragePermission();

    if (!permissionResult['granted']) {
      _showPermissionError(permissionResult);
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final XFile? image = await _picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      );

      if (image == null) {
        setState(() => _isProcessing = false);
        return;
      }

      setState(() => _uploadedImagePath = image.path);

      final inputImage = InputImage.fromFilePath(image.path);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);

      setState(() {
        _extractedText = recognizedText.text.trim();
        _isProcessing = false;
      });

      Fluttertoast.showToast(msg: "Text extracted successfully!");
    } catch (e) {
      setState(() => _isProcessing = false);
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  void _showPermissionError(Map<String, dynamic> result) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['message']),
        action: SnackBarAction(
          label: 'Settings',
          onPressed: () => _permissionService.openAppSettings(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textRecognizer.close();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Column(
          /*mainAxisAlignment: MainAxisAlignment.start,*/
          crossAxisAlignment: CrossAxisAlignment.start,
         spacing: 2,
          children: [
            const CustomText(
              text: 'Study Buddy',
              color: Color(0xFF2D3436),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          if (kIsWeb)
            const CustomText(
              text: 'Beta version',
              color: Color(0xFF667EEA),
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ],
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
      body: ScaleTransition(
        scale: _scaleAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildUploadSection(),
              const SizedBox(height: 16),
              _buildAICoachCard(),
              const SizedBox(height: 16),
              if (_extractedText != null && !_isProcessing) ...[
                _buildExtractedTextSection(),
                const SizedBox(height: 24),
                _buildAIMagicSection(),
              ] else if (!_isProcessing) ...[
                const CustomText(text: "Study Materials", fontSize: 16, fontWeight: FontWeight.bold),
                const SizedBox(height: 8),
                _buildMaterialsGrid(),
              ],
              //const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF667EEA), Color(0xFF764BA2)]),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Welcome back 👋🏻, ${_userData['name']?.split(' ').first ?? 'User'}!',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          const SizedBox(height: 8),
          const CustomText(
            text: 'Scan your notes and let AI create study materials',
            fontSize: 12,
            maxLines: 2,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  Widget _buildUploadSection() {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        //border: Border.all(color: Colors.grey.shade300, width: 1),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      const CustomText(
                  text: 'Scan New Notes',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3436),
                ),
          const SizedBox(height: 3),
                const CustomText(
                  text: 'Instantly convert handwritten notes into study sets with AI',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                  maxLines: 5,
                ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _showImagePickerSheet,
            child: Container(
              height: 130,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: _uploadedImagePath != null
                  ? Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(File(_uploadedImagePath!), fit: BoxFit.contain),
                  ),
                  // Positioned(
                  //   top: 5,
                  //   right: 5,
                  //   child: GestureDetector(
                  //     onTap: () => setState(() {
                  //       _uploadedImagePath = null;
                  //       _extractedText = null;
                  //     }),
                  //     child: Container(
                  //       padding: const EdgeInsets.all(2),
                  //       decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  //       child: const Icon(Icons.close, color: Colors.white, size: 16),
                  //     ),
                  //   ),
                  // ),
                ],
              )
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.upload_file_outlined, size: 40, color: Colors.grey[500]),
                  const SizedBox(height: 8),
                  const CustomText(text: "Tap to upload image", color: Colors.grey, fontSize: 12,fontWeight: FontWeight.w500,),
                ],
              ),
            ),
          ),
          _uploadedImagePath != null? const SizedBox(height: 10): const SizedBox(),
          if (_uploadedImagePath != null)InkWell(
            onTap: () {
              setState(() {
                _uploadedImagePath = null;
                _extractedText = null;
              });
            },
            child: Row(
              spacing: 3,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
                CustomText(
                  text: "Remove image",
                  fontWeight: FontWeight.w500,
                  color: Colors.red.shade600,
                  fontSize: 14,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAICoachCard() {
    return GestureDetector(
      onTap: () => Fluttertoast.showToast(msg: "Go to AI Help tab to chat!"),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFFFFD166), Color(0xFFEF476F)]),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), borderRadius: BorderRadius.circular(30)),
              child: const Icon(Icons.psychology, color: Colors.white, size: 32),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: 'Need to talk?', color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  CustomText(text: 'Your AI coach is online and ready to listen 24/7.', color: Colors.white, fontSize: 12, maxLines: 2),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildExtractedTextSection() {
    // return Column(
    //   children: [
    //     Row(
    //       children: [
    //         const Icon(Icons.check_circle, color: Colors.green, size: 20),
    //         const SizedBox(width: 12),
    //         const Text('Text Captured!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3436))),
    //       ],
    //     ),
    //     const SizedBox(height: 10),
    //     ElevatedButton(
    //       onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ExtractText(extractedText: _extractedText ?? ""))),
    //       child: const Text("View & Extract Text"),
    //     ),
    //   ],
    // );
    return Container(
      decoration: BoxDecoration(
         color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            spreadRadius: 0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 8),
            const CustomText(text: "Text Captured!", fontWeight: FontWeight.bold),
            const Spacer(),
            CustomButton(
                text: "Review Text",
                width: 110,
                fontSize: 12,
                color: Color(0xFF6E65C6),
                fontWeight: FontWeight.w600,
                height: 30,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => ExtractText(extractedText: _extractedText!)));
                },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIMagicSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade100)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome, color: Color(0xFF667EEA),size: 28,),
              SizedBox(width: 8),
              CustomText(text: 'Choose AI Magic', fontSize: 16, fontWeight: FontWeight.bold),
            ],
          ),
          const SizedBox(height: 8),
          const CustomText(
              text: 'Select one or more formats for your study materials',
              fontSize: 12,
              maxLines: 3,
              color: Colors.grey),
          const SizedBox(height: 12),
          CustomButton(
            text: "✨ Choose Material",
            fontWeight: FontWeight.w600,
            height: 36,
            color: Color(0xFF6E65C6),
            fontSize: 12,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GenerateMaterialsScreen(
                    imagePath: _uploadedImagePath,
                    extractedText: _extractedText,
                  ),
                ),
              );
            },
          ),
          if (_isGenerating) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget _buildMaterialsGrid() {
    return Row(
      children: [
        _buildSmallMaterialCard(Icons.subject_rounded, 'Summary', 'Key points', Colors.amber),
        const SizedBox(width: 8),
        _buildSmallMaterialCard(Icons.style_rounded, 'Flashcards', 'Active recall and quick memorization', Colors.green),
        const SizedBox(width: 8),
        _buildSmallMaterialCard(Icons.quiz_rounded, 'Quiz', 'Test knowledge', Colors.pink),
      ],
    );
  }

  Widget _buildSmallMaterialCard(IconData icon, String title, String sub, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade100)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 16),
            ),
            const SizedBox(height: 6),
            CustomText(text: title, fontWeight: FontWeight.w800, fontSize: 11),
            CustomText(text: sub, color: Colors.grey, fontSize: 10, maxLines: 3),
          ],
        ),
      ),
    );
  }
}