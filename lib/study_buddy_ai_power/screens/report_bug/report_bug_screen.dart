import 'package:flutter/material.dart';
import 'package:learning_statemanejment/study_buddy_ai_power/utils/apploader.dart';
import '../../../ai_power_app/widget/custom_text.dart';
import '../../services/bugreport_service.dart';

class ReportBugScreen extends StatefulWidget {
  const ReportBugScreen({super.key});

  @override
  State<ReportBugScreen> createState() => _ReportBugScreenState();
}

class _ReportBugScreenState extends State<ReportBugScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  bool _isSending = false;

  void _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSending = true);

    // Simulating the BugReportService call
    bool success = await BugReportService().sendBugReport(
      title: _titleController.text,
      description: _descController.text,
      deviceLogs: "OS: Android/iOS, Role: Flutter Developer", // Contextual info
    );

    setState(() => _isSending = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Report sent successfully!")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const CustomText(text: "Report a Bug", fontSize: 18, fontWeight: FontWeight.bold),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderCard(),
              const SizedBox(height: 28,),
              const CustomText(text: "Issue Title", fontWeight: FontWeight.bold),
              const SizedBox(height: 10),
              _buildField(_titleController, "e.g., App crashes on login"),

              const SizedBox(height: 24),
              const CustomText(text: "Description", fontWeight: FontWeight.bold),
              const SizedBox(height: 10),
              _buildField(_descController, "Explain what happened...", maxLines: 5),

              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSending ? null : _submitReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF667EEA),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isSending
                      ? AppLoader(color: Colors.white)
                      : const CustomText(text: "Send Report", color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        // boxShadow: [
        //   BoxShadow(
        //     color: const Color(0xFF667EEA).withOpacity(0.3),
        //     blurRadius: 15,
        //     offset: const Offset(0, 8),
        //   )
        // ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: "Submit suggestions, or issues.",
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          const SizedBox(height: 8),
          CustomText(
            text: "Encountered an issue or bug in the app? Submit feedback, suggestions, or report problems to help us improve",
            fontSize: 12,
            maxLines: 3,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.8),
          ),
        ],
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String hint, {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
      validator: (val) => val!.isEmpty ? "Required field" : null,
    );
  }
}