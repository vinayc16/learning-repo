import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:learning_statemanejment/ai_power_app/widget/custom_text.dart';
import 'package:share_plus/share_plus.dart';

class ExtractText extends StatefulWidget {
  final String extractedText;

  const ExtractText({super.key, required this.extractedText});

  @override
  State<ExtractText> createState() => _ExtractTextState();
}

class _ExtractTextState extends State<ExtractText> {
  late TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.extractedText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  late final params = ShareParams(
      files: [XFile.fromData(utf8.encode(_controller.text), mimeType: 'text/plain')],
      fileNameOverrides: ['myfile.txt']
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2D3436), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const CustomText(
          text: 'Edit & Review',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2D3436),
        ),
        actions: [
          // એડિટિંગ મોડ ટોગલ કરવા માટે બટન
          IconButton(
            icon: Icon(_isEditing ? Icons.check_circle : Icons.edit_note,
                color: const Color(0xFF667EEA), size: 28),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
              if (!_isEditing) {
                Fluttertoast.showToast(msg: "Changes saved locally!");
              }
            },
          ),

          // Copy Button
          if (!_isEditing)
            TextButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: _controller.text));
                Fluttertoast.showToast(msg: "Copied to clipboard!");
              },
              icon: const Icon(Icons.copy_all, size: 18),
              label: const CustomText(text: "Copy\nAll Text",fontSize: 12,fontWeight: FontWeight.bold,),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            _buildStatusCard(),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomText(
                  text: "Note Content",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3436),
                ),
                TextButton(onPressed: () {
                  //SharePlus.instance.share(params);
                  SharePlus.instance.share(
                    ShareParams(
                        text: _controller.text,
                        title: "Note Content"
                    ),
                  );

                }, child: Icon(Icons.share,/*color: Colors.black*/size: 20,)),
              ],
            ),
            const SizedBox(height: 10),

            // Editable Text Field
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _isEditing ? const Color(0xFF667EEA) : Colors.grey.shade200,
                  width: _isEditing ? 1.5 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextFormField(
                controller: _controller,
                maxLines: null,
                enabled: _isEditing,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: Colors.grey.shade800,
                ),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  border: InputBorder.none,
                  hintText: "No text extracted...",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isEditing
              ? [const Color(0xFFFFAF7B), const Color(0xFFD76D77)]
              : [const Color(0xFF667EEA), const Color(0xFF764BA2)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(_isEditing ? Icons.edit_document : Icons.auto_awesome, color: Colors.white),
          const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: _isEditing ?"Edit Extracted Text!": "Text Extracted Successfully!",
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            const CustomText(
              text: "Review and edit your notes below.",
              fontSize: 11,
              color: Colors.white70,
            ),
          ],
        ),
      )],
      ),
    );
  }
}