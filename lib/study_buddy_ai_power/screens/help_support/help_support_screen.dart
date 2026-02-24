import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../ai_power_app/widget/custom_text.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  String contact = "+91 7433816816";

  Future<void> makePhoneCall(String phoneNumber) async {
    try {
      // Validate and clean the phone number
      if (phoneNumber.isEmpty || phoneNumber == 'Unknown Number' || phoneNumber == '-' || phoneNumber == 'null') {
        return;
      }

      // Clean the phone number - remove all non-digit characters
      final cleanedNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

      // Validate if we have a valid phone number (at least 10 digits)
      if (cleanedNumber.length < 10) {
        //_showSnackbar('Phone number is too short', isError: true);
        return;
      }

      // Format for tel: scheme (just digits, no spaces or special characters)
      final String telUrl = 'tel:$cleanedNumber';

      // Use launchUrl instead of canLaunchUrl + launchUrl for better reliability
      final Uri uri = Uri.parse(telUrl);

      if (await launchUrl(
        uri,
        mode: LaunchMode.externalApplication, // This is important
      )) {
        // Success - phone dialer opened
        //AppLog.i('Phone dialer launched for: $cleanedNumber');
      } else {
        ///_showSnackbar('Cannot make phone call. Please check if your device supports calling.', isError: true);
      }
    } catch (e) {
      //AppLog.e('Error launching phone dialer: $e');
      //_showSnackbar('Cannot make phone call: ${e.toString()}', isError: true);
    }
  }

  Future<void> _openEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'chauhanvinay857@gmail.com',
      query: 'subject=Study Buddy Support &body=Hello...,',
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not open email app';
    }
  }

  Future<void> _launchWebUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $url')),
        );
      }
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2D3436), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const CustomText(
          text: 'Help & Support',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2D3436),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            // Header Section
            _buildHeaderCard(),
            const SizedBox(height: 32),

            // Direct Contact Section
            _buildSectionTitle("Direct Contact"),
            const SizedBox(height: 12),
            _buildContactTile(
              icon: Icons.email_rounded,
              title: "Email Support",
              value: "chauhhanvinay857@gmail.com",
              color: Colors.redAccent,
              onTap: () => null /*_openEmail()*/,
            ),
            _buildContactTile(
              icon: Icons.phone,
              title: "Call/WhatsApp",
              value: "+91 7862916153",
              color: Colors.green,
              onTap: () => makePhoneCall("7862916151"),
            ),

            const SizedBox(height: 32),

            // Social Media Section
            _buildSectionTitle("Follow us on Social Media"),
            const SizedBox(height: 16),
            _buildSocialGrid(),

            const SizedBox(height: 32),

            // Portfolio Button
            //_buildPortfolioButton(),

            const SizedBox(height: 20),
            const CustomText(
              text: "v1.0.0 • Made with 💙 by Vinay Chauhan",
              fontSize: 10,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: "Hello, how can we help?",
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          const SizedBox(height: 8),
          CustomText(
            text: "We would love to hear your feedback and questions.",
            fontSize: 12,
            maxLines: 2,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.8),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: CustomText(
        text: title,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF2D3436),
      ),
    );
  }

  Widget _buildContactTile({required IconData icon, required String title, required String value, required Color color, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 16),
        ),
        title: CustomText(text: title, fontSize: 13, color: Colors.grey,fontWeight: FontWeight.w500,),
        subtitle: CustomText(text: value, fontSize: 12, fontWeight: FontWeight.w600),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      ),
    );
  }

  Widget _buildSocialGrid() {
    return Wrap(
      spacing: 10,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        _socialCircleIcon(FontAwesomeIcons.linkedinIn, const Color(0xFF0077B5), "https://www.linkedin.com/in/chauhan-vinay-6b8024280/"),
        _socialCircleIcon(FontAwesomeIcons.github, const Color(0xFF333333), "https://github.com/chauhanvinay16"),
        _socialCircleIcon(FontAwesomeIcons.instagram, const Color(0xFFE4405F), "https://www.instagram.com/flutter.protuts"),
        _socialCircleIcon(FontAwesomeIcons.medium, const Color(0xFF000000), "https://medium.com/@chauhanvinay857"),
        _socialCircleIcon(Icons.public, const Color(0xFF000000), "https://vinay-chauhan16.vercel.app/"),
      ],
    );
  }

  Widget _socialCircleIcon(IconData icon, Color color, String url) {
    return InkWell(
      onTap: () => _launchWebUrl(url),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: FaIcon(icon, color: color, size: 24),
      ),
    );
  }
}