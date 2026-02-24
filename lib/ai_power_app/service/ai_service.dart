import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_key.dart';

class AiService {
  static Future<String> summarizeText(String text) async {
    final response = await http.post(
      Uri.parse("https://api.openai.com/v1/chat/completions"),
      headers: {
        "Authorization": "Bearer ${ApiKeys.openAiKey}",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "model": "gpt-4o-mini",
        "messages": [
          {
            "role": "user",
            "content": "Summarize this text in 2 lines:\n$text"
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["choices"][0]["message"]["content"];
    } else {
      throw Exception("Failed to summarize");
    }
  }

  static Future<List<String>> extractKeywordsAI(String text) async {
    final response = await http.post(
      Uri.parse("https://api.openai.com/v1/chat/completions"),
      headers: {
        "Authorization": "Bearer ${ApiKeys.openAiKey}",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "model": "gpt-4o-mini",
        "messages": [
          {
            "role": "user",
            "content":
            "Extract the 5 most relevant keywords from this text. "
                "Return only comma-separated keywords:\n$text"
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final result = data["choices"][0]["message"]["content"];

      return result
          .split(',')
          .map((e) => e.trim())
          .toList();
    } else {
      throw Exception("Keyword extraction failed");
    }
  }

}
