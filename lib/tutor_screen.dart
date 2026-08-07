import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'curriculum_screen.dart';
import 'services/ai_service.dart';

class TutorScreen extends StatefulWidget {
  final String language;

  const TutorScreen({super.key, required this.language});

  @override
  State<TutorScreen> createState() => _TutorScreenState();
}

class _TutorScreenState extends State<TutorScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final AIService _aiService = AIService();
  final FlutterTts _flutterTts = FlutterTts();
  final stt.SpeechToText _speech = stt.SpeechToText();

  bool _isListening = false;
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _messages.add({
      'role': 'ai',
      'text': 'Hello! I am your Sunshine Tutor for ${widget.language}. How can I help you today?'
    });
    _initTTS();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _flutterTts.stop();
    _speech.stop();
    super.dispose();
  }

  void _initTTS() {
    _flutterTts.setLanguage(_getLanguageCode(widget.language));
    _flutterTts.setSpeechRate(0.5);
    if (kIsWeb) {
      _flutterTts.awaitSpeakCompletion(true);
    }
    _flutterTts.setCompletionHandler(() {
      setState(() => _isSpeaking = false);
    });
  }

  String _getLanguageCode(String lang) {
    switch (lang) {
      case 'German': return 'de-DE';
      case 'French': return 'fr-FR';
      case 'Chinese': return 'zh-CN';
      case 'English': return 'en-GB';
      default: return 'en-US';
    }
  }

  Future<void> _speak(String text) async {
    if (_isSpeaking) {
      await _flutterTts.stop();
    }
    setState(() => _isSpeaking = true);
    
    String langCode = _getLanguageCode(widget.language);
    if (kIsWeb) {
      bool isSupported = await _flutterTts.isLanguageAvailable(langCode);
      if (!isSupported && langCode.contains('-')) {
        langCode = langCode.split('-')[0];
      }
    }
    await _flutterTts.setLanguage(langCode);
    await _flutterTts.speak(text);
  }

  Future<void> _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(onResult: (val) {
          setState(() {
            _messageController.text = val.recognizedWords;
          });
        });
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      if (_messageController.text.isNotEmpty) {
        _sendMessage();
      }
    }
  }

  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      final userText = _messageController.text;
      setState(() {
        _messages.add({'role': 'user', 'text': userText});
        _messageController.clear();
      });

      // Get AI response
      final response = await _aiService.getResponse(userText, widget.language);
      
      if (mounted) {
        setState(() {
          _messages.add({'role': 'ai', 'text': response});
        });
        _speak(response);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.language} Sunshine Tutor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.school),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => CurriculumScreen(language: widget.language),
              ));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _ChatBubble(
                  text: message['text']!,
                  isAi: message['role'] == 'ai',
                  isSpeaking: _isSpeaking,
                  onSpeak: () => _speak(message['text']!),
                );
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))
      ]),
      child: SafeArea(
        child: Row(
          children: [
            GestureDetector(
              onTapDown: (_) => _listen(),
              onTapUp: (_) => _listen(),
              child: CircleAvatar(
                backgroundColor: _isListening ? Colors.red : Colors.blue.shade50,
                child: Icon(_isListening ? Icons.stop : Icons.mic, 
                  color: _isListening ? Colors.white : Colors.blue),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _messageController,
                onSubmitted: (_) => _sendMessage(),
                decoration: InputDecoration(
                  hintText: _isListening ? 'Listening...' : 'Talk to your tutor...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.blue,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String text;
  final bool isAi;
  final bool isSpeaking;
  final VoidCallback onSpeak;

  const _ChatBubble({required this.text, required this.isAi, required this.isSpeaking, required this.onSpeak});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isAi ? Alignment.centerLeft : Alignment.centerRight,
      child: Column(
        crossAxisAlignment: isAi ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            decoration: BoxDecoration(
              color: isAi ? Colors.white : Colors.blue,
              borderRadius: BorderRadius.circular(20).copyWith(
                bottomLeft: isAi ? Radius.zero : const Radius.circular(20),
                bottomRight: isAi ? const Radius.circular(20) : Radius.zero,
              ),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 5, offset: Offset(0, 2))],
            ),
            child: Text(
              text,
              style: TextStyle(fontSize: 16, color: isAi ? Colors.black87 : Colors.white),
            ),
          ),
          if (isAi)
            IconButton(
              icon: Icon(isSpeaking ? Icons.volume_up : Icons.volume_up_outlined, size: 18, color: isSpeaking ? Colors.blue : Colors.grey),
              onPressed: onSpeak,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
}
