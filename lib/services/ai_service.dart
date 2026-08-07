import 'package:google_generative_ai/google_generative_ai.dart';

class AIService {
  // Add your Gemini API Key here
  static const String _apiKey = 'YOUR_GEMINI_API_KEY';
  
  late final GenerativeModel _model;
  bool _isConfigured = false;

  AIService() {
    if (_apiKey != 'YOUR_GEMINI_API_KEY') {
      _model = GenerativeModel(model: 'gemini-pro', apiKey: _apiKey);
      _isConfigured = true;
    }
  }

  Future<String> getResponse(String userMessage, String language) async {
    if (!_isConfigured) {
      // Return a simulated intelligent response if no API key is provided
      return _getMockResponse(userMessage, language);
    }

    try {
      final prompt = "You are a helpful language tutor named Sunshine. "
          "You are teaching $language. The student says: '$userMessage'. "
          "Respond in $language, provide a translation in English, and briefly correct any grammar errors.";
      
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? "I'm sorry, I couldn't process that.";
    } catch (e) {
      return "Error connecting to AI: $e";
    }
  }

  String _getMockResponse(String msg, String lang) {
    msg = msg.toLowerCase();
    if (msg.contains('hello') || msg.contains('hi')) {
      return "Hallo! (Hello!) I am your $lang tutor. How can I help you today?";
    }
    return "Great effort! You said '$msg'. In $lang, pronunciation is key. Let's try to focus on the vowel sounds next time!";
  }
}
