import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import '../services/ai_service.dart';

class AIVoicePracticeScreen extends StatefulWidget {
  final String language;
  final String topic;

  const AIVoicePracticeScreen({super.key, required this.language, required this.topic});

  @override
  State<AIVoicePracticeScreen> createState() => _AIVoicePracticeScreenState();
}

class _AIVoicePracticeScreenState extends State<AIVoicePracticeScreen> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _tts = FlutterTts();
  final AIService _aiService = AIService();

  bool _isListening = false;
  String _lastWords = '';
  String _aiFeedback = 'Hello! I am ready to listen. Tap the mic and pronounce a letter or sound from this week\'s lesson.';
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  void _initTts() {
    _tts.setLanguage(widget.language == 'German' ? 'de-DE' : 'en-US');
    _tts.setSpeechRate(0.4);
    if (kIsWeb) {
      _tts.awaitSpeakCompletion(true);
    }
  }

  @override
  void dispose() {
    _speech.stop();
    _tts.stop();
    super.dispose();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() {
          _isListening = true;
          _lastWords = ''; // Reset words
        });
        _speech.listen(
          onResult: (val) {
            setState(() {
              _lastWords = val.recognizedWords;
            });
          },
        );
      } else {
        setState(() {
          _aiFeedback = "Speech recognition is not available or permission was denied.";
        });
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      if (_lastWords.isNotEmpty) {
        _getAIFeedback();
      } else {
        setState(() {
          _aiFeedback = "I didn't quite catch that. Please hold the mic and speak again!";
        });
      }
    }
  }

  void _getAIFeedback() async {
    setState(() {
      _isProcessing = true;
      _aiFeedback = 'Thinking...';
    });

    final feedback = await _aiService.getResponse(
      "The student practiced saying '$_lastWords' for the topic ${widget.topic}. "
      "Give a short (1-2 sentences) encouraging response and correction in English.",
      widget.language
    );
    
    if (mounted) {
      setState(() {
        _aiFeedback = feedback;
        _isProcessing = false;
      });
      
      String langCode = 'en-US';
      if (kIsWeb) {
        bool isSupported = await _tts.isLanguageAvailable(langCode);
        if (!isSupported) langCode = 'en';
      }
      
      await _tts.stop();
      await _tts.setLanguage(langCode);
      await _tts.speak(feedback);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Voice Practice')),
      body: Column(
        children: [
          const SizedBox(height: 40),
          const CircleAvatar(
            radius: 60,
            backgroundColor: Colors.blueAccent,
            child: Icon(Icons.face, size: 80, color: Colors.white),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
                border: _isProcessing ? Border.all(color: Colors.blueAccent) : null,
              ),
              child: Column(
                children: [
                  if (_isProcessing)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  Text(
                    _aiFeedback,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          if (_lastWords.isNotEmpty)
            Text('You said: "$_lastWords"', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
          const SizedBox(height: 24),
          GestureDetector(
            onLongPress: _listen,
            onLongPressUp: _listen,
            child: CircleAvatar(
              radius: 40,
              backgroundColor: _isListening ? Colors.red : Colors.blue,
              child: Icon(
                _isListening ? Icons.mic : Icons.mic_none,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Hold to Speak', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
