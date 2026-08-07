import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class LessonNoteScreen extends StatefulWidget {
  final int weekNumber;
  final String weekTitle;
  final String language;
  final String level;

  const LessonNoteScreen({
    super.key,
    required this.weekNumber,
    required this.weekTitle,
    required this.language,
    required this.level,
  });

  @override
  State<LessonNoteScreen> createState() => _LessonNoteScreenState();
}

class _LessonNoteScreenState extends State<LessonNoteScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  void _initTts() {
    String langCode = 'de-DE';
    if (widget.language == 'Chinese') {
      langCode = 'zh-CN';
    } else if (widget.language == 'English') {
      langCode = 'en-US';
    } else if (widget.language == 'French') {
      langCode = 'fr-FR';
    }
    
    _flutterTts.setLanguage(langCode);
    _flutterTts.setSpeechRate(0.4);
    _flutterTts.setVolume(1.0);
    _flutterTts.setPitch(1.1);

    if (kIsWeb) {
      _flutterTts.awaitSpeakCompletion(true);
    }

    _flutterTts.setCompletionHandler(() {
      setState(() => _isSpeaking = false);
    });
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _speak(String text, {String? lang}) async {
    if (_isSpeaking) {
      await _flutterTts.stop();
    }
    setState(() => _isSpeaking = true);

    String languageCode = lang ?? 'de-DE';
    if (kIsWeb) {
      bool isSupported = await _flutterTts.isLanguageAvailable(languageCode);
      if (!isSupported) {
        if (languageCode.contains('-')) {
          languageCode = languageCode.split('-')[0];
        }
      }
    }

    await _flutterTts.setLanguage(languageCode);
    
    try {
      await _flutterTts.speak(text);
    } catch (e) {
      debugPrint("TTS Error: $e");
      setState(() => _isSpeaking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = _getContentPages();
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('${widget.level} - Week ${widget.weekNumber}'),
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6),
          child: LinearProgressIndicator(
            value: (pages.isEmpty) ? 0 : (_currentPage + 1) / pages.length,
            backgroundColor: Colors.grey.shade100,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
            minHeight: 6,
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() => _currentPage = index);
        },
        children: pages,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_currentPage > 0)
              OutlinedButton(
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: const Text('Back'),
              )
            else
              const SizedBox(width: 80),
            
            Text(
              'Page ${_currentPage + 1} of ${pages.length}',
              style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500),
            ),

            if (_currentPage < pages.length - 1)
              ElevatedButton(
                onPressed: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Continue'),
              )
            else
              const SizedBox(width: 80),
          ],
        ),
      ),
      floatingActionButton: _currentPage == 0 ? FloatingActionButton.extended(
        heroTag: 'ask_sunshine',
        onPressed: () => _speakIntro(),
        label: const Text('Ask Sunshine'),
        icon: const Icon(Icons.face),
        backgroundColor: Colors.orangeAccent,
      ) : null,
    );
  }

  void _speakIntro() {
    String intro = "";
    if (widget.language == 'German') {
      if (widget.level == 'A1') {
        switch (widget.weekNumber) {
          case 1: intro = "Hello! I am your Sunshine Tutor. Today we are learning about German Phonetics, the Alphabet, and basic Greetings."; break;
          case 2: intro = "Welcome to Week 2. Today we master Introductions and Personal Information. Learning to say who you are is the first step!"; break;
          case 3: intro = "Numbers and Time! Today we learn to count and schedule our day in German."; break;
          case 4: intro = "Sentence Structure and Articles. We'll master the V2 rule and those tricky genders: der, die, and das."; break;
          case 5: intro = "Verbs and Review. We'll cover regular and irregular verbs and wrap up Level A1!"; break;
        }
      }
    } else if (widget.language == 'Chinese') {
      if (widget.level == 'A1') {
        switch (widget.weekNumber) {
          case 1: intro = "Ni hao! Welcome to Chinese Week 1. Today we learn Pinyin and the four tones, the foundation of Mandarin."; break;
          case 2: intro = "Hello! Today we master basic Greetings and Numbers. Learning to count is essential for your first trip to China!"; break;
          case 3: intro = "Who are you? Today we explore Identity and Family, learning to talk about yourself and your loved ones."; break;
          case 4: intro = "What time is it? Today we learn about Days, Months, and telling Time in Chinese."; break;
          case 5: intro = "Great job! You've finished A1. Today we review everything and prepare for Level A2."; break;
        }
      }
    }
    _speak(intro, lang: 'en-US');
  }

  List<Widget> _getContentPages() {
    if (widget.language == 'German') {
      switch (widget.level) {
        case 'A1':
          switch (widget.weekNumber) {
            case 1: return _buildGermanA1Week1Pages();
            case 2: return _buildGermanA1Week2Pages();
            case 3: return _buildGermanA1Week3Pages();
            case 4: return _buildGermanA1Week4Pages();
            case 5: return _buildGermanA1Week5Pages();
          }
          break;
        case 'A2':
          switch (widget.weekNumber) {
            case 6: return _buildConsolidatedA2Week6Pages();
            case 7: return _buildGermanA2Week7Pages();
            case 8: return _buildGermanA2Week8Pages();
            case 9: return _buildGermanA2Week9Pages();
            case 10: return _buildGermanA2Week10Pages();
          }
          break;
        case 'B1':
          switch (widget.weekNumber) {
            case 1: return _buildConsolidatedB1Week1Pages();
            case 2: return _buildConsolidatedB1Week2Pages();
            case 3: return _buildConsolidatedB1Week3Pages();
            case 4: return _buildConsolidatedB1Week4Pages();
            case 5: return _buildConsolidatedB1Week5Pages();
          }
          break;
        case 'B2':
          switch (widget.weekNumber) {
            case 6: return _buildConsolidatedB2Week6Pages();
            case 7: return _buildConsolidatedB2Week7Pages();
            case 8: return _buildConsolidatedB2Week8Pages();
            case 9: return _buildConsolidatedB2Week9Pages();
            case 10: return _buildConsolidatedB2Week10Pages();
          }
          break;
        case 'C1':
          switch (widget.weekNumber) {
            case 1: return _buildConsolidatedC1Week1Pages();
            case 2: return _buildGermanC1Week2Pages();
            case 3: return _buildGermanC1Week3Pages();
            case 4: return _buildGermanC1Week4Pages();
            case 5: return _buildGermanC1Week5Pages();
          }
          break;
        case 'C2':
          switch (widget.weekNumber) {
            case 6: return _buildConsolidatedC2Week6Pages();
            case 7: return _buildGermanC2Week7Pages();
            case 8: return _buildGermanC2Week8Pages();
            case 9: return _buildGermanC2Week9Pages();
            case 10: return _buildGermanC2Week10Pages();
          }
          break;
      }
    } else if (widget.language == 'Chinese') {
      switch (widget.level) {
        case 'A1':
          switch (widget.weekNumber) {
            case 1: return _buildChineseA1Week1Pages();
            case 2: return _buildChineseA1Week2Pages();
            case 3: return _buildChineseA1Week3Pages();
            case 4: return _buildChineseA1Week4Pages();
            case 5: return _buildChineseA1Week5Pages();
          }
          break;
        case 'A2':
          switch (widget.weekNumber) {
            case 6: return _buildChineseA2Week6Pages();
            case 7: return _buildChineseA2Week7Pages();
            case 8: return _buildChineseA2Week8Pages();
            case 9: return _buildChineseA2Week9Pages();
            case 10: return _buildChineseA2Week10Pages();
          }
          break;
        case 'B1':
          switch (widget.weekNumber) {
            case 1: return _buildChineseB1Week1Pages();
            case 2: return _buildChineseB1Week2Pages();
            case 3: return _buildChineseB1Week3Pages();
            case 4: return _buildChineseB1Week4Pages();
            case 5: return _buildChineseB1Week5Pages();
          }
          break;
        case 'B2':
          switch (widget.weekNumber) {
            case 6: return _buildChineseB2Week6Pages();
            case 7: return _buildChineseB2Week7Pages();
            case 8: return _buildChineseB2Week8Pages();
            case 9: return _buildChineseB2Week9Pages();
            case 10: return _buildChineseB2Week10Pages();
          }
          break;
        case 'C1':
          switch (widget.weekNumber) {
            case 1: return _buildChineseC1Week1Pages();
            case 2: return _buildChineseC1Week2Pages();
            case 3: return _buildChineseC1Week3Pages();
            case 4: return _buildChineseC1Week4Pages();
            case 5: return _buildChineseC1Week5Pages();
          }
          break;
        case 'C2':
          switch (widget.weekNumber) {
            case 6: return _buildChineseC2Week6Pages();
            case 7: return _buildChineseC2Week7Pages();
            case 8: return _buildChineseC2Week8Pages();
            case 9: return _buildChineseC2Week9Pages();
            case 10: return _buildChineseC2Week10Pages();
          }
          break;
      }
    }
    return [ _buildContentPage(title: 'Coming Soon', children: [_buildTextContent('Refactoring...')]) ];
  }

  // --- GERMAN BUILDERS ---

  List<Widget> _buildGermanA1Week1Pages() {
    return [
      _buildContentPage(title: '1. The German Alphabet (Das Alphabet)', children: [
        _buildTextContent('The German alphabet has 26 standard letters. Pronunciation (Aussprache) is key!'),
        _buildAlphabetGrid(),
      ]),
      _buildAssessmentPage(question: 'How does the German letter "W" sound?', options: ['Like W', 'Like V (English)', 'Like F'], correctIndex: 1),
      _buildContentPage(title: '2. Special Characters (Sonderzeichen)', children: [
        _buildSnippetBox('Ä / ä:', 'Sounds like "e" in "bed" (Äpfel - apples)', onSpeak: () => _speak("ä")),
        _buildSnippetBox('Ö / ö:', 'Similar to "u" in "fur" (hören - to hear)', onSpeak: () => _speak("ö")),
        _buildSnippetBox('Ü / ü:', 'Pucker your lips "ee" sound (über - over)', onSpeak: () => _speak("ü")),
        _buildSnippetBox('ß (Eszett):', 'A sharp "s" sound (die Straße - street)', onSpeak: () => _speak("ß")),
      ]),
      _buildContentPage(title: '3. Formal Greetings (Begrüßungen)', children: [
        _buildSnippetBox('Guten Tag', 'Good day (Guten Tag)', onSpeak: () => _speak("Guten Tag")),
        _buildSnippetBox('Auf Wiedersehen', 'Goodbye (Auf Wiedersehen)', onSpeak: () => _speak("Auf Wiedersehen")),
        _buildCultureBox('Germans value formal greetings in shops and offices.'),
        _buildFooterButtons('Greetings'),
      ]),
    ];
  }

  List<Widget> _buildGermanA1Week2Pages() {
    return [
      _buildContentPage(title: '1. Self Introductions (Sich vorstellen)', children: [
        _buildSnippetBox('Ich heiße...', 'My name is... (Ich heiße Lukas)', onSpeak: () => _speak("Ich heiße Lukas")),
        _buildSnippetBox('Wer bist du?', 'Who are you? (Wer bist du?)', onSpeak: () => _speak("Wer bist du?")),
        _buildSnippetBox('Freut mich.', 'Nice to meet you. (Freut mich)', onSpeak: () => _speak("Freut mich")),
      ]),
      _buildAssessmentPage(question: 'How do you say "My name is" using "heiße"?', options: ['Ich bin', 'Ich heiße', 'Ich wohne'], correctIndex: 1),
      _buildContentPage(title: '2. Origins & Residence', children: [
        _buildSnippetBox('Woher kommst du?', 'Where do you come from? (Woher kommst du?)', onSpeak: () => _speak("Woher kommst du?")),
        _buildSnippetBox('Ich komme aus...', 'I come from... (Ich komme aus Nigeria)', onSpeak: () => _speak("Ich komme aus Nigeria")),
        _buildSnippetBox('Ich wohne in...', 'I live in... (Ich wohne in Berlin)', onSpeak: () => _speak("Ich wohne in Berlin")),
        _buildFooterButtons('Introductions'),
      ]),
    ];
  }

  List<Widget> _buildGermanA1Week3Pages() {
    return [
      _buildContentPage(title: '1. Numbers 0-20 (Zahlen)', children: [
        _buildSnippetBox('0-10:', 'null (0), eins (1), zwei (2), drei (3), vier (4), fünf (5), sechs (6), sieben (7), acht (8), neun (9), zehn (10).', onSpeak: () => _speak("null bis zehn")),
        _buildSnippetBox('11-20:', 'elf (11), zwölf (12), dreizehn (13), vierzehn (14)... zwanzig (20).', onSpeak: () => _speak("elf bis zwanzig")),
      ]),
      _buildAssessmentPage(question: 'What is the German number for 12?', options: ['elf', 'zwölf', 'zehn'], correctIndex: 1),
      _buildContentPage(title: '2. Time (Die Uhrzeit)', children: [
        _buildSnippetBox('Wie spät ist es?', 'What time is it? (Wie spät ist es?)', onSpeak: () => _speak("Wie spät ist es?")),
        _buildSnippetBox('Es ist acht Uhr.', 'It is 8 o\'clock. (Es ist acht Uhr)', onSpeak: () => _speak("Es ist acht Uhr")),
        _buildFooterButtons('Numbers & Time'),
      ]),
    ];
  }

  List<Widget> _buildGermanA1Week4Pages() {
    return [
      _buildContentPage(title: '1. The V2 Rule (Satzbau)', children: [
        _buildGrammarBox('Verb Position', 'In a statement, the conjugated verb MUST be in Position 2.'),
        _buildSnippetBox('Sentence:', 'Ich (1) lerne (2) Deutsch. (I learn German.)', onSpeak: () => _speak("Ich lerne Deutsch")),
        _buildSnippetBox('Sentence:', 'Heute (1) lerne (2) ich Deutsch. (Today I learn German.)', onSpeak: () => _speak("Heute lerne ich Deutsch")),
      ]),
      _buildAssessmentPage(question: 'Where does the verb go in a German statement?', options: ['Pos 1', 'Pos 2', 'End'], correctIndex: 1),
      _buildContentPage(title: '2. Articles (Der, Die, Das)', children: [
        _buildSnippetBox('der Tisch', 'the table (masculine)', onSpeak: () => _speak("der Tisch")),
        _buildSnippetBox('die Frau', 'the woman (feminine)', onSpeak: () => _speak("die Frau")),
        _buildSnippetBox('das Kind', 'the child (neuter)', onSpeak: () => _speak("das Kind")),
        _buildFooterButtons('Grammar'),
      ]),
    ];
  }

  List<Widget> _buildGermanA1Week5Pages() {
    return [
      _buildContentPage(title: '1. Regular Verbs (Verben)', children: [
        _buildTextContent('To conjugate, add endings to the stem: ich -e, du -st, er/sie/es -t.'),
        _buildRegularVerbTable(),
      ]),
      _buildAssessmentPage(question: 'What is the ending for "ich"?', options: ['-st', '-t', '-e'], correctIndex: 2),
      _buildContentPage(title: '2. Irregular Verbs', children: [
        _buildSnippetBox('sein (to be):', 'ich bin, du bist, er ist...', onSpeak: () => _speak("sein")),
        _buildSnippetBox('haben (to have):', 'ich habe, du hast, er hat...', onSpeak: () => _speak("haben")),
        _buildFooterButtons('Verbs'),
      ]),
    ];
  }

  List<Widget> _buildGermanA2Week6Pages() {
    return [
      _buildContentPage(title: '1. W-Questions', children: [
        _buildSnippetBox('Wer (Who):', 'Wer ist das? (Who is that?)', onSpeak: () => _speak("Wer ist das?")),
        _buildSnippetBox('Was (What):', 'Was machst du? (What are you doing?)', onSpeak: () => _speak("Was machst du?")),
        _buildSnippetBox('Wo (Where):', 'Wo wohnst du? (Where do you live?)', onSpeak: () => _speak("Wo wohnst du?")),
      ]),
      _buildAssessmentPage(question: 'Which word means "Where"?', options: ['Wer', 'Was', 'Wo'], correctIndex: 2),
      _buildContentPage(title: '2. Daily Routine', children: [
        _buildSnippetBox('aufstehen:', 'to get up (ich stehe auf)', onSpeak: () => _speak("ich stehe auf")),
        _buildFooterButtons('Routine'),
      ]),
    ];
  }

  List<Widget> _buildGermanA2Week7Pages() => [_buildContentPage(title: '1. Housing (Wohnen)', children: [_buildSnippetBox('Küche', 'kitchen'), _buildSnippetBox('Brot', 'bread'), _buildFooterButtons('Housing')])];
  List<Widget> _buildGermanA2Week8Pages() => [_buildContentPage(title: '1. Restaurant', children: [_buildSnippetBox('Rechnung', 'bill'), _buildSnippetBox('Kopf', 'head'), _buildFooterButtons('Health')])];
  List<Widget> _buildGermanA2Week9Pages() => [_buildContentPage(title: '1. Travel', children: [_buildSnippetBox('Bahnhof', 'station'), _buildSnippetBox('Hemd', 'shirt'), _buildFooterButtons('Travel')])];
  List<Widget> _buildGermanA2Week10Pages() => [_buildContentPage(title: '1. Review', children: [_buildTextContent('A2 Complete! Term 1 Mastery achieved.'), _buildFooterButtons('Review')])];

  List<Widget> _buildGermanB1Week1Pages() => [_buildContentPage(title: '1. Perfekt', children: [_buildSnippetBox('Ich habe gelesen', 'I read (past)'), _buildFooterButtons('Past')])];
  List<Widget> _buildGermanB1Week2Pages() => [_buildContentPage(title: '1. War/Hatte', children: [_buildSnippetBox('Ich war', 'I was'), _buildSnippetBox('Ich hatte', 'I had'), _buildFooterButtons('Narrating')])];
  List<Widget> _buildGermanB1Week3Pages() => [_buildContentPage(title: '1. Opinions', children: [_buildSnippetBox('dass', 'that'), _buildSnippetBox('weil', 'because'), _buildFooterButtons('Opinions')])];
  List<Widget> _buildGermanB1Week4Pages() => [_buildContentPage(title: '1. Travel B1', children: [_buildSnippetBox('buchen', 'to book'), _buildFooterButtons('Travel')])];
  List<Widget> _buildGermanB1Week5Pages() => [_buildContentPage(title: '1. B1 Final', children: [_buildTextContent('B1 complete.'), _buildFooterButtons('Review')])];

  List<Widget> _buildGermanB2Week6Pages() => [_buildContentPage(title: '1. Passive', children: [_buildSnippetBox('wird gebaut', 'is being built'), _buildFooterButtons('Passive')])];
  List<Widget> _buildGermanB2Week7Pages() => [_buildContentPage(title: '1. Hypotheticals', children: [_buildSnippetBox('wäre', 'would be'), _buildSnippetBox('hätte', 'would have'), _buildFooterButtons('Hypothetical')])];
  List<Widget> _buildGermanB2Week8Pages() => [_buildContentPage(title: '1. Environment', children: [_buildSnippetBox('nachhaltig', 'sustainable'), _buildFooterButtons('Environment')])];
  List<Widget> _buildGermanB2Week9Pages() => [_buildContentPage(title: '1. Society', children: [_buildSnippetBox('Relativsatz', 'relative clause'), _buildFooterButtons('Culture')])];
  List<Widget> _buildGermanB2Week10Pages() => [_buildContentPage(title: '1. B2 Final', children: [_buildTextContent('B2 complete.'), _buildFooterButtons('Review')])];

  List<Widget> _buildGermanC1Week1Pages() => [_buildContentPage(title: '1. Nominalization', children: [_buildSnippetBox('Entscheidung', 'decision'), _buildFooterButtons('Abstract')])];
  List<Widget> _buildGermanC1Week2Pages() => [_buildContentPage(title: '1. Politics', children: [_buildSnippetBox('Gewaltenteilung', 'separation of powers'), _buildFooterButtons('Politics')])];
  List<Widget> _buildGermanC1Week3Pages() => [_buildContentPage(title: '1. Science', children: [_buildSnippetBox('Hypothese', 'hypothesis'), _buildFooterButtons('Science')])];
  List<Widget> _buildGermanC1Week4Pages() => [_buildContentPage(title: '1. Literature', children: [_buildSnippetBox('Metapher', 'metaphor'), _buildFooterButtons('Literature')])];
  List<Widget> _buildGermanC1Week5Pages() => [_buildContentPage(title: '1. C1 Final', children: [_buildTextContent('C1 complete.'), _buildFooterButtons('Review')])];

  List<Widget> _buildGermanC2Week6Pages() => [_buildContentPage(title: '1. Idioms', children: [_buildSnippetBox('Redewendung', 'idiom'), _buildFooterButtons('Nuance')])];
  List<Widget> _buildGermanC2Week7Pages() => [_buildContentPage(title: '1. Business', children: [_buildSnippetBox('Verhandlung', 'negotiation'), _buildFooterButtons('Professional')])];
  List<Widget> _buildGermanC2Week8Pages() => [_buildContentPage(title: '1. Ethics', children: [_buildSnippetBox('Philosophie', 'philosophy'), _buildFooterButtons('Ethics')])];
  List<Widget> _buildGermanC2Week9Pages() => [_buildContentPage(title: '1. Dialects', children: [_buildSnippetBox('Varietät', 'variety'), _buildFooterButtons('Dialects')])];
  List<Widget> _buildGermanC2Week10Pages() => [_buildContentPage(title: '1. C2 Final', children: [_buildTextContent('C2 complete.'), _buildFooterButtons('Review')])];

  // --- CHINESE BUILDERS ---

  List<Widget> _buildChineseA1Week1Pages() {
    return [
      _buildContentPage(title: '1. Initials (Shengmu 声母)', children: [
        _buildSnippetBox('b, p, m, f:', 'bàba (father 爸爸), māma (mother 妈妈).', onSpeak: () => _speak("b, p, m, f", lang: 'zh-CN')),
        _buildSnippetBox('d, t, n, l:', 'dìdi (little brother 弟弟), nǐ (you 你).', onSpeak: () => _speak("d, t, n, l", lang: 'zh-CN')),
      ]),
      _buildAssessmentPage(question: 'Which initial is in "hǎo" (good)?', options: ['b', 'd', 'h', 'm'], correctIndex: 2),
      _buildContentPage(title: '2. Four Tones (声调)', children: [
        _buildGrammarBox('Tones', 'Pitch changes meaning! 1st: flat, 2nd: rising, 3rd: fall-rise, 4th: falling.'),
        _buildSnippetBox('mā (妈):', 'mother (1st tone)', onSpeak: () => _speak("mā", lang: 'zh-CN')),
        _buildSnippetBox('mǎ (马):', 'horse (3rd tone)', onSpeak: () => _speak("mǎ", lang: 'zh-CN')),
        _buildFooterButtons('Mandarin Basics'),
      ]),
    ];
  }

  List<Widget> _buildChineseA1Week2Pages() {
    return [
      _buildContentPage(title: '1. Greetings (问候)', children: [
        _buildSnippetBox('Nǐ hǎo:', 'Hello (你好).', onSpeak: () => _speak("Nǐ hǎo", lang: 'zh-CN')),
        _buildSnippetBox('Nǐ hǎo ma?:', 'How are you? (你好吗？)', onSpeak: () => _speak("Nǐ hǎo ma", lang: 'zh-CN')),
        _buildSnippetBox('Xièxie:', 'Thank you (谢谢).', onSpeak: () => _speak("Xièxie", lang: 'zh-CN')),
      ]),
      _buildAssessmentPage(question: 'What is "Hello" in Mandarin?', options: ['Xièxie', 'Nǐ hǎo', 'Zàijiàn'], correctIndex: 1),
      _buildContentPage(title: '2. Numbers 1-10', children: [
        _buildSnippetBox('1-5:', 'yī (1), èr (2), sān (3), sì (4), wǔ (5).', onSpeak: () => _speak("yī èr sān sì wǔ", lang: 'zh-CN')),
        _buildFooterButtons('Greetings'),
      ]),
    ];
  }

  List<Widget> _buildChineseA1Week3Pages() => [_buildContentPage(title: '1. Family (家庭)', children: [_buildSnippetBox('bàba:', 'father (爸爸)'), _buildSnippetBox('māma:', 'mother (妈妈)'), _buildFooterButtons('Family')])];
  List<Widget> _buildChineseA1Week4Pages() => [_buildContentPage(title: '1. Weekdays (星期)', children: [_buildSnippetBox('Xīngqī yī:', 'Monday (星期一)'), _buildSnippetBox('Xīngqī liù:', 'Saturday (星期六)'), _buildFooterButtons('Time')])];
  List<Widget> _buildChineseA1Week5Pages() => [_buildContentPage(title: '1. Review', children: [_buildTextContent('A1 Complete! Progress to A2.'), _buildFooterButtons('Review')])];

  List<Widget> _buildChineseA2Week6Pages() => [_buildContentPage(title: '1. Routine (日常)', children: [_buildSnippetBox('qǐchuáng:', 'get up (起床)'), _buildSnippetBox('chī fàn:', 'eat (吃饭)'), _buildFooterButtons('Routine')])];
  List<Widget> _buildChineseA2Week7Pages() => [_buildContentPage(title: '1. Shopping (购物)', children: [_buildSnippetBox('duōshǎo qián?', 'how much? (多少钱？)'), _buildFooterButtons('Shopping')])];
  List<Widget> _buildChineseA2Week8Pages() => [_buildContentPage(title: '1. Travel (旅游)', children: [_buildSnippetBox('zài nǎr?', 'where? (在哪儿？)'), _buildFooterButtons('Travel')])];
  List<Widget> _buildChineseA2Week9Pages() => [_buildContentPage(title: '1. Health (健康)', children: [_buildSnippetBox('téng:', 'pain (疼)'), _buildFooterButtons('Health')])];
  List<Widget> _buildChineseA2Week10Pages() => [_buildContentPage(title: '1. Review', children: [_buildTextContent('A2 Complete! Term 1 Mastery.'), _buildFooterButtons('Review')])];

  List<Widget> _buildChineseB1Week1Pages() => [_buildContentPage(title: '1. Particle Guò (过)', children: [_buildSnippetBox('qù guò:', 'have been to (去过)'), _buildFooterButtons('Past')])];
  List<Widget> _buildChineseB1Week2Pages() => [_buildContentPage(title: '1. Plans (打算)', children: [_buildSnippetBox('ānpái:', 'arrangement (安排)'), _buildFooterButtons('Plans')])];
  List<Widget> _buildChineseB1Week3Pages() => [_buildContentPage(title: '1. Moods (心情)', children: [_buildSnippetBox('gāoxìng:', 'happy (高兴)'), _buildFooterButtons('Emotions')])];
  List<Widget> _buildChineseB1Week4Pages() => [_buildContentPage(title: '1. Career (职业)', children: [_buildSnippetBox('jīnglǐ:', 'manager (经理)'), _buildFooterButtons('Career')])];
  List<Widget> _buildChineseB1Week5Pages() => [_buildContentPage(title: '1. Review', children: [_buildTextContent('B1 complete.'), _buildFooterButtons('Review')])];

  List<Widget> _buildChineseB2Week6Pages() => [_buildContentPage(title: '1. Business (商务)', children: [_buildSnippetBox('míngpiàn:', 'business card (名片)'), _buildFooterButtons('Business')])];
  List<Widget> _buildChineseB2Week7Pages() => [_buildContentPage(title: '1. Media (媒体)', children: [_buildSnippetBox('xīnwén:', 'news (新闻)'), _buildFooterButtons('Media')])];
  List<Widget> _buildChineseB2Week8Pages() => [_buildContentPage(title: '1. Tech (科技)', children: [_buildSnippetBox('zhìnéng:', 'AI (智能)'), _buildFooterButtons('Tech')])];
  List<Widget> _buildChineseB2Week9Pages() => [_buildContentPage(title: '1. Eco (环保)', children: [_buildSnippetBox('huánbǎo:', 'eco-friendly (环保)'), _buildFooterButtons('Environment')])];
  List<Widget> _buildChineseB2Week10Pages() => [_buildContentPage(title: '1. Review', children: [_buildTextContent('B2 complete.'), _buildFooterButtons('Review')])];

  List<Widget> _buildChineseC1Week1Pages() => [_buildContentPage(title: '1. Concepts (概念)', children: [_buildSnippetBox('zhéxué:', 'philosophy (哲学)'), _buildFooterButtons('Abstract')])];
  List<Widget> _buildChineseC1Week2Pages() => [_buildContentPage(title: '1. Idioms (成语)', children: [_buildSnippetBox('bàn tú ér fèi:', 'give up halfway'), _buildFooterButtons('Idioms')])];
  List<Widget> _buildChineseC1Week3Pages() => [_buildContentPage(title: '1. Policy (政策)', children: [_buildSnippetBox('zhèngcè:', 'policy'), _buildFooterButtons('Politics')])];
  List<Widget> _buildChineseC1Week4Pages() => [_buildContentPage(title: '1. Literature (文学)', children: [_buildSnippetBox('wénxué:', 'literature'), _buildFooterButtons('Literature')])];
  List<Widget> _buildChineseC1Week5Pages() => [_buildContentPage(title: '1. Review', children: [_buildTextContent('C1 complete.'), _buildFooterButtons('Review')])];

  List<Widget> _buildChineseC2Week6Pages() => [_buildContentPage(title: '1. Nuance (语气)', children: [_buildSnippetBox('yǔqi:', 'tone (语气)'), _buildFooterButtons('Mastery')])];
  List<Widget> _buildChineseC2Week7Pages() => [_buildContentPage(title: '1. Diplomacy (外交)', children: [_buildSnippetBox('wàijiāo:', 'diplomacy'), _buildFooterButtons('Negotiation')])];
  List<Widget> _buildChineseC2Week8Pages() => [_buildContentPage(title: '1. Arts (艺术)', children: [_buildSnippetBox('měixué:', 'aesthetics'), _buildFooterButtons('Art')])];
  List<Widget> _buildChineseC2Week9Pages() => [_buildContentPage(title: '1. History (历史)', children: [_buildSnippetBox('gǔwén:', 'classical Chinese'), _buildFooterButtons('History')])];
  List<Widget> _buildChineseC2Week10Pages() => [_buildContentPage(title: '1. Final', children: [_buildTextContent('C2 complete.'), _buildFooterButtons('Final')])];

  // --- UI HELPERS ---

  Widget _buildContentPage({required String title, required List<Widget> children}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.blue.shade900, height: 1.1)),
        const SizedBox(height: 24),
        ...children,
      ]),
    );
  }

  Widget _buildAssessmentPage({required String question, required List<String> options, required int correctIndex}) {
    return _QuickAssessment(question: question, options: options, correctIndex: correctIndex, onNext: () => _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut));
  }

  Widget _buildSnippetBox(String label, String detail, {VoidCallback? onSpeak}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))]),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        title: Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade700, fontSize: 16)),
        subtitle: Padding(padding: const EdgeInsets.only(top: 8.0), child: Text(detail, style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.4))),
        trailing: onSpeak != null ? IconButton(icon: const Icon(Icons.volume_up_rounded, color: Colors.blueAccent), onPressed: onSpeak) : null,
      ),
    );
  }

  Widget _buildGrammarBox(String title, String rule) {
    return Container(width: double.infinity, margin: const EdgeInsets.only(bottom: 20), padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.indigo.shade50, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.indigo.shade100)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Icon(Icons.g_translate_rounded, color: Colors.indigo.shade700, size: 20), const SizedBox(width: 8), Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo.shade900, fontSize: 17))]), const SizedBox(height: 12), Text(rule, style: TextStyle(fontSize: 15, color: Colors.indigo.shade800, height: 1.5))]));
  }

  Widget _buildCultureBox(String fact) {
    return Container(width: double.infinity, margin: const EdgeInsets.only(bottom: 20), padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.amber.shade50, Colors.orange.shade50]), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.amber.shade200)), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.lightbulb_rounded, color: Colors.amber.shade800, size: 24), const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Cultural Tip', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), const SizedBox(height: 4), Text(fact, style: TextStyle(color: Colors.orange.shade900, height: 1.4))]))]));
  }

  Widget _buildTextContent(String text) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(text, style: const TextStyle(fontSize: 15, height: 1.5)));

  Widget _buildHeader(String title, String audioText) => const SizedBox(); // Placeholder

  Widget _buildAlphabetGrid() {
    final letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
    return Wrap(spacing: 8, runSpacing: 8, children: letters.map((l) => InkWell(onTap: () => _speak(l, lang: 'de-DE'), child: Container(width: 40, height: 40, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)), alignment: Alignment.center, child: Text(l, style: const TextStyle(fontWeight: FontWeight.bold))))).toList());
  }

  Widget _buildRegularVerbTable() {
    return Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)), child: Table(border: TableBorder.symmetric(inside: BorderSide(color: Colors.grey.shade300)), children: [TableRow(decoration: BoxDecoration(color: Colors.blueGrey.shade50), children: [_buildTableCell('Subject', isHeader: true), _buildTableCell('Ending', isHeader: true), _buildTableCell('Example', isHeader: true)]), _buildConjugationRow('ich', '-e', 'mache'), _buildConjugationRow('du', '-st', 'machst'), _buildConjugationRow('er/sie/es', '-t', 'macht')]));
  }

  TableRow _buildConjugationRow(String sub, String end, String ex) => TableRow(children: [_buildTableCell(sub), _buildTableCell(end), _buildTableCell(ex)]);

  Widget _buildTableCell(String text, {bool isHeader = false}) => Padding(padding: const EdgeInsets.all(8.0), child: Text(text, textAlign: TextAlign.center, style: TextStyle(fontWeight: isHeader ? FontWeight.bold : FontWeight.normal, fontSize: 12)));

  Widget _buildDialogueLine(String speaker, String text) => Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(children: [Text('$speaker: ', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)), Expanded(child: Text(text))]));

  Widget _buildBulletPoint(String text) => Padding(padding: const EdgeInsets.only(left: 8, bottom: 8), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('• ', style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold, fontSize: 18)), Expanded(child: Text(text, style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.4)))]));

  Widget _buildFooterButtons(String topic) {
    return Column(children: [
      const SizedBox(height: 32),
      Row(children: [
        Expanded(child: ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.quiz), label: const Text('QUIZ'), style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))),
        const SizedBox(width: 12),
        Expanded(child: ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.mic), label: const Text('PRACTICE'), style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))),
      ]),
      const SizedBox(height: 16),
      SizedBox(width: double.infinity, height: 50, child: OutlinedButton.icon(onPressed: () { Provider.of<LanguageProvider>(context, listen: false).completeWeek(widget.language, widget.level, widget.weekNumber); Navigator.pop(context); }, icon: const Icon(Icons.check_circle_outline), label: const Text('MARK AS READ'), style: OutlinedButton.styleFrom(foregroundColor: Colors.green, side: const BorderSide(color: Colors.green), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))),
    ]);
  }

  Widget _buildPlaceholder() => Center(child: Text('Content for Week ${widget.weekNumber} is being prepared with full translations.', textAlign: TextAlign.center));
}

class _QuickAssessment extends StatefulWidget {
  final String question;
  final List<String> options;
  final int correctIndex;
  final VoidCallback onNext;

  const _QuickAssessment({required this.question, required this.options, required this.correctIndex, required this.onNext});

  @override
  State<_QuickAssessment> createState() => _QuickAssessmentState();
}

class _QuickAssessmentState extends State<_QuickAssessment> {
  int? _selectedIndex;
  bool _isAnswered = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.blue.shade50,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(color: Colors.blue.shade600, borderRadius: BorderRadius.circular(20)), child: const Text('QUICK CHECK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
        const SizedBox(height: 32),
        Text(widget.question, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 40),
        ...List.generate(widget.options.length, (index) {
          final isSelected = _selectedIndex == index;
          Color borderColor = isSelected ? Colors.blue.shade600 : Colors.grey.shade300;
          if (_isAnswered) {
            if (index == widget.correctIndex) borderColor = Colors.green;
            else if (isSelected) borderColor = Colors.red;
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              onTap: _isAnswered ? null : () => setState(() => _selectedIndex = index),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: borderColor, width: 2)),
                child: Row(children: [Expanded(child: Text(widget.options[index], style: const TextStyle(fontSize: 18))), if (_isAnswered && index == widget.correctIndex) const Icon(Icons.check_circle, color: Colors.green)]),
              ),
            ),
          );
        }),
        const SizedBox(height: 40),
        if (!_isAnswered)
          SizedBox(width: double.infinity, height: 56, child: ElevatedButton(onPressed: _selectedIndex == null ? null : () => setState(() { _isAnswered = true; }), child: const Text('CHECK ANSWER')))
        else
          SizedBox(width: double.infinity, height: 56, child: ElevatedButton(onPressed: widget.onNext, style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white), child: const Text('CONTINUE'))),
      ]),
    );
  }
}
