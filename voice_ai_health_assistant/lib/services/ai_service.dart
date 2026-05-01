import 'dart:convert';
import 'package:http/http.dart' as http;

class AiService {
  // TODO: Replace with your actual OpenAI API key
  static const String _apiKey = 'YOUR_OPENAI_API_KEY_HERE';
  static const String _endpoint = 'https://api.openai.com/v1/chat/completions';

  static const String _systemPrompt = '''
You are a voice-based health assistant.
* Keep responses under 80 words
* Ask only 1 follow-up question at a time
* Do not diagnose diseases
* Suggest only basic home remedies or general advice
* If symptoms seem serious, say: 'Please consult a doctor'
* Keep answers short and conversational
* Avoid repetition
''';

  /// Evaluates user input for critical symptoms before calling the API.
  bool _isCriticalSymptom(String input) {
    final lowerInput = input.toLowerCase();
    final criticalKeywords = ['chest pain', 'breathing problem', 'severe pain'];
    
    for (var keyword in criticalKeywords) {
      if (lowerInput.contains(keyword)) {
        return true;
      }
    }
    return false;
  }

  /// Sends the latest user message to ChatGPT API.
  /// Does NOT send full conversation history to minimize tokens.
  Future<String> getAiResponse(String userMessage) async {
    // 1. Safety Override
    if (_isCriticalSymptom(userMessage)) {
      return 'Please consult a doctor immediately.';
    }

    // 2. Call API
    try {
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o-mini', // or 'gpt-3.5-turbo' for cost efficiency
          'messages': [
            {'role': 'system', 'content': _systemPrompt},
            {'role': 'user', 'content': userMessage},
          ],
          'max_tokens': 100, // Enforce short response strictly
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        if (data['choices'] != null && data['choices'].isNotEmpty) {
          return data['choices'][0]['message']['content'].toString().trim();
        }
      }
      return 'I am currently unable to process your request. Please try again later.';
    } catch (e) {
      print('Error calling AI API: $e');
      return 'Sorry, there was an error connecting to my servers.';
    }
  }
}
