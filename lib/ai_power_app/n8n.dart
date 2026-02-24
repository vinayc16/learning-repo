import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Webhook Chat',
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool isLoading = false;
  String responseText = "";

  Future<void> sendMessage() async {
    if (_messageController.text.isEmpty) return;

    setState(() {
      isLoading = true;
      responseText = "";
    });

    final url = Uri.parse(
      "https://heer-patel01.app.n8n.cloud/webhook-test/mychatapp",
    );

    final body = {
      "message": _messageController.text,
      "sender": "flutter_user",
    };

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          responseText = data.toString();
        });
      } else {
        setState(() {
          responseText = "Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        responseText = "Exception: $e";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("n8n Webhook Chat"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Input field
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Type your message",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// Send Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: isLoading ? null : sendMessage,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Send to Webhook"),
              ),
            ),

            const SizedBox(height: 20),

            /// Response UI
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Webhook Response:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    responseText.isEmpty
                        ? "No response yet"
                        : responseText,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}