import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class QuizScreen extends StatefulWidget {
  final String title;
  final String language;

  const QuizScreen({super.key, required this.title, required this.language});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _quizCompleted = false;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'How is the letter "J" pronounced in the German alphabet?',
      'options': ['Jay', 'Yot', 'Zet', 'Ha'],
      'answer': 'Yot',
    },
    {
      'question': 'Which sound does the Umlaut "Ä" typically make?',
      'options': ['Like "oo" in moon', 'Like "e" in bed', 'Like "i" in machine', 'Like "a" in car'],
      'answer': 'Like "e" in bed',
    },
    {
      'question': 'The diphthong "ei" (as in "frei") sounds like:',
      'options': ['Eye', 'Ee', 'Ay', 'Oh'],
      'answer': 'Eye',
    },
    {
      'question': 'Which character is called "Eszett"?',
      'options': ['ä', 'ö', 'ü', 'ß'],
      'answer': 'ß',
    },
  ];

  void _answerQuestion(String selectedOption) {
    if (selectedOption == _questions[_currentQuestionIndex]['answer']) {
      setState(() {
        _score++;
      });
    }

    setState(() {
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
      } else {
        _quizCompleted = true;
        // Award points via provider
        Provider.of<LanguageProvider>(context, listen: false).addPoints(_score * 50);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: _quizCompleted ? _buildResultArea() : _buildQuizArea(),
    );
  }

  Widget _buildQuizArea() {
    final question = _questions[_currentQuestionIndex];
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / _questions.length,
            backgroundColor: Colors.grey.shade200,
            color: Colors.blue,
          ),
          const SizedBox(height: 32),
          Text(
            'Question ${_currentQuestionIndex + 1}/${_questions.length}',
            style: const TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            question['question'],
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          ...List.generate(question['options'].length, (index) {
            final option = question['options'][index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: OutlinedButton(
                  onPressed: () => _answerQuestion(option),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    side: const BorderSide(color: Colors.blue, width: 2),
                  ),
                  child: Text(option, style: const TextStyle(fontSize: 18, color: Colors.black87)),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildResultArea() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.stars, size: 100, color: Colors.amber),
            const SizedBox(height: 24),
            const Text('Quiz Completed!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('You scored $_score out of ${_questions.length}', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 32),
            Text('+${_score * 50} Sunshine Points Earned!', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('CONTINUE', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
