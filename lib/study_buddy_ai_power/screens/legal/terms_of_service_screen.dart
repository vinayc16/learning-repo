import 'package:flutter/material.dart';

import '../../../ai_power_app/widget/custom_text.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

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
          text:'Terms of Service',
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
              text: 'Study Buddy Terms of Service',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF667EEA),
            ),
            const SizedBox(height: 4),
            CustomText(
              text: 'Last updated: February 5, 2026',
                fontSize: 14,
                color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(height: 24),

            _buildSection(
              title: '1. Acceptance of Terms',
              content: 'By downloading, installing, or using Study Buddy ("the App"), you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use the App.',
            ),

            _buildSection(
              title: '2. Description of Service',
              content: 'Study Buddy is an AI-powered study assistant application that helps users:\n\n'
                  '• Scan and extract text from study materials\n\n'
                  '• Generate summaries, flashcards, and quizzes using AI\n\n'
                  '• Track study progress and history\n\n'
                  '• Organize and manage study materials\n\n'
                  'The App uses Google Gemini AI for content generation and Google ML Kit for text recognition.',
            ),

            _buildSection(
              title: '3. User Account and Registration',
              content: 'To use the App, you must:\n\n'
                  '• Provide accurate registration information (name, email, phone)\n\n'
                  '• Maintain the security of your account credentials\n\n'
                  '• Be responsible for all activities under your account\n\n'
                  '• Notify us immediately of any unauthorized access\n\n'
                  '• Be at least 13 years old (users under 18 need parental consent)',
            ),

            _buildSection(
              title: '4. Acceptable Use',
              content: 'You agree to use the App only for lawful purposes and in accordance with these Terms. You must NOT:\n\n'
                  '• Upload illegal, offensive, or copyrighted content without permission\n\n'
                  '• Attempt to hack, reverse engineer, or compromise the App\n\n'
                  '• Use the App to harm, harass, or impersonate others\n\n'
                  '• Spam or abuse the AI generation features\n\n'
                  '• Share your account credentials with others\n\n'
                  '• Use automated tools or bots to access the App',
            ),

            _buildSection(
              title: '5. API Key Usage',
              content: 'The App provides a default Google Gemini API key for convenience. However:\n\n'
                  '• You may use your own API key for better control\n\n'
                  '• You are responsible for API usage costs if using your own key\n\n'
                  '• Google\'s API terms and policies apply to your API usage\n\n'
                  '• We are not liable for issues related to Google\'s API service\n\n'
                  '• Keep your API key secure and do not share it',
            ),

            _buildSection(
              title: '6. Content Ownership',
              content: 'You retain all rights to content you upload or create using the App. By using the App:\n\n'
                  '• You grant us permission to process your content for AI features\n\n'
                  '• Content sent to Google Gemini is subject to Google\'s terms\n\n'
                  '• Generated materials (summaries, quizzes) are your property\n\n'
                  '• We do not claim ownership of your study materials',
            ),

            _buildSection(
              title: '7. AI-Generated Content Disclaimer',
              content: 'AI-generated content is provided "as is" and may contain errors. We do not guarantee:\n\n'
                  '• Accuracy or completeness of generated materials\n\n'
                  '• Suitability for specific educational purposes\n\n'
                  '• Freedom from inaccuracies or biases\n\n'
                  'Always verify AI-generated content with reliable sources. Use generated materials as study aids, not as sole learning resources.',
            ),

            _buildSection(
              title: '8. Intellectual Property',
              content: 'The App and its original content, features, and functionality are owned by Study Buddy and are protected by:\n\n'
                  '• Copyright laws\n\n'
                  '• Trademark laws\n\n'
                  '• Other intellectual property rights\n\n'
                  'You may not copy, modify, or distribute the App without permission.',
            ),

            _buildSection(
              title: '9. Third-Party Services',
              content: 'The App integrates with third-party services:\n\n'
                  '• Google Gemini AI\n\n'
                  '• Google ML Kit\n\n'
                  '• Other Google services\n\n'
                  'Your use of these services is subject to their respective terms and policies. We are not responsible for third-party service availability or actions.',
            ),

            _buildSection(
              title: '10. Limitation of Liability',
              content: 'To the maximum extent permitted by law:\n\n'
                  '• The App is provided "as is" without warranties\n\n'
                  '• We are not liable for data loss or corruption\n\n'
                  '• We are not liable for academic consequences from using AI-generated content\n\n'
                  '• We are not liable for service interruptions or errors\n\n'
                  '• Our total liability is limited to the amount you paid (if any)',
            ),

            _buildSection(
              title: '11. Data Backup',
              content: 'You are responsible for backing up your data. We recommend:\n\n'
                  '• Regularly exporting your study materials\n\n'
                  '• Keeping copies of important notes\n\n'
                  '• Not relying solely on the App for data storage\n\n'
                  'We are not liable for data loss due to app uninstallation, device issues, or other causes.',
            ),

            _buildSection(
              title: '12. Termination',
              content: 'We reserve the right to:\n\n'
                  '• Suspend or terminate your account for violations\n\n'
                  '• Discontinue the App at any time\n\n'
                  '• Modify features or functionality\n\n'
                  'You may delete your account at any time from Settings.',
            ),

            _buildSection(
              title: '13. Changes to Terms',
              content: 'We may modify these Terms at any time. Changes will be effective when posted in the App. Continued use after changes constitutes acceptance of new Terms.',
            ),

            _buildSection(
              title: '14. Governing Law',
              content: 'These Terms are governed by applicable laws in your jurisdiction. Any disputes will be resolved in accordance with these laws.',
            ),

            _buildSection(
              title: '15. Contact Information',
              content: 'For questions about these Terms, contact us:\n\n'
                  '• Email: support@studybuddy.app\n\n'
                  '• In-App Support: Settings → Help Center',
            ),
            //const SizedBox(height: 24),
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
                    Icons.verified_user,
                    color: Color(0xFF667EEA),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomText(
                      text: 'By using Study Buddy, you acknowledge that you have read and agree to these Terms of Service.',
                        fontSize: 12,
                        maxLines: 5,
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
              fontSize: 16 ,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3436),
          ),
          const SizedBox(height: 12),
          CustomText(
            text: content,
              fontSize: 12,
              color: Colors.grey.shade700,
              maxLines: content.length,
          ),
        ],
      ),
    );
  }
}