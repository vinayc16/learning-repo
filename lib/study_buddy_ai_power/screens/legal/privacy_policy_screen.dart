import 'package:flutter/material.dart';
import 'package:learning_statemanejment/ai_power_app/widget/custom_text.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: const Color(0xFF667EEA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const CustomText(
          text: 'Privacy Policy',
          fontSize: 16,
          color: Colors.white, fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              text: 'Privacy Policy',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF667EEA),
            ),
            const SizedBox(height: 4),
            CustomText(
              text: 'Last updated: February 5, 2026',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
            ),
            const SizedBox(height: 24),

            _buildSection(
              title: '1. Introduction',
              content: 'Welcome to Study Buddy. We respect your privacy and are committed to protecting your personal data. This privacy policy will inform you about how we handle your personal data when you use our mobile application.',
            ),

            _buildSection(
              title: '2. Information We Collect',
              content: 'We collect the following types of information:\n\n'
                  '• Personal Information: Name, email address, and phone number that you provide during registration.\n\n'
                  '• Study Materials: Notes, images, and documents you upload or scan using the app.\n\n'
                  '• Usage Data: Information about how you use the app, including features accessed and time spent.\n\n'
                  '• Device Information: Device type, operating system, and app version.',
            ),

            _buildSection(
              title: '3. How We Use Your Information',
              content: 'We use your information to:\n\n'
                  '• Provide and maintain our service\n\n'
                  '• Generate study materials using AI (summaries, flashcards, quizzes)\n\n'
                  '• Improve user experience and app functionality\n\n'
                  '• Send you notifications about your study progress (if enabled)\n\n'
                  '• Respond to your requests and provide customer support',
            ),

            _buildSection(
              title: '4. AI Processing',
              content: 'Study Buddy uses Google Gemini AI to process your study materials. When you use AI features:\n\n'
                  '• Your text and images are sent to Google\'s servers for processing\n\n'
                  '• Google may use this data according to their privacy policy\n\n'
                  '• We recommend not uploading sensitive or confidential information\n\n'
                  '• You can use your own API key for more control over data processing',
            ),

            _buildSection(
              title: '5. Data Storage',
              content: 'Your data is stored:\n\n'
                  '• Locally on your device using secure storage\n\n'
                  '• User credentials and preferences are encrypted\n\n'
                  '• Study materials are saved locally and not transmitted except for AI processing\n\n'
                  '• We do not maintain centralized servers for user data',
            ),

            _buildSection(
              title: '6. Third-Party Services',
              content: 'We use the following third-party services:\n\n'
                  '• Google Gemini AI: For generating study materials\n\n'
                  '• Google ML Kit: For text recognition from images\n\n'
                  'These services have their own privacy policies governing the use of your data.',
            ),

            _buildSection(
              title: '7. Your Rights',
              content: 'You have the right to:\n\n'
                  '• Access your personal data\n\n'
                  '• Update or correct your information\n\n'
                  '• Delete your account and all associated data\n\n'
                  '• Export your study materials\n\n'
                  '• Opt-out of notifications\n\n'
                  '• Use your own API key for AI processing',
            ),

            _buildSection(
              title: '8. Data Security',
              content: 'We implement appropriate security measures to protect your data:\n\n'
                  '• Local encryption for sensitive data\n\n'
                  '• Secure communication protocols\n\n'
                  '• Regular security updates\n\n'
                  '• No unauthorized third-party access',
            ),

            _buildSection(
              title: '9. Children\'s Privacy',
              content: 'Study Buddy is suitable for users of all ages. We do not knowingly collect data from children under 13 without parental consent. If you are a parent and believe your child has provided us with personal information, please contact us.',
            ),

            _buildSection(
              title: '10. Changes to Privacy Policy',
              content: 'We may update this privacy policy from time to time. We will notify you of any changes by posting the new policy in the app and updating the "Last updated" date.',
            ),

            _buildSection(
              title: '11. Contact Us',
              content: 'If you have questions about this privacy policy, please contact us:\n\n'
                  '• Email: privacy@studybuddy.app\n\n'
                  '• In-App Support: Settings → Help Center',
            ),

            //const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                //color: const Color(0xFF667EEA).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF667EEA).withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Color(0xFF667EEA),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomText(
                      text: 'By using Study Buddy, you agree to this Privacy Policy.',
                        fontSize: 12,
                        maxLines: 2,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
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

  Widget _buildSection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: title,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3436),
          ),
          const SizedBox(height: 6),
          CustomText(
            text: content,
              fontSize: 12,
              maxLines: content.length,
              color: Colors.grey.shade700,
          ),
        ],
      ),
    );
  }
}
