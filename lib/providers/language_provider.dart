import 'package:flutter/material.dart';
import '../models/lesson.dart';

class LanguageProvider with ChangeNotifier {
  final int _streak = 5;
  int _points = 1250;
  String _currentFluency = 'A1';

  int get streak => _streak;
  int get points => _points;
  String get fluency => _currentFluency;

  // Track completed levels for each language
  final Map<String, List<String>> _completedLevels = {
    'German': [],
    'French': [],
    'Chinese': [],
    'English': [],
  };

  final Map<String, List<Module>> _curriculums = {
    'German': [
      Module(
        id: 'ger_m1',
        title: 'Week 1: Alphabet & Greetings',
        lessons: [
          Lesson(id: 'ger_m1_l1', title: 'Lesson 1: A–Z Phonetics', description: 'Learn the German alphabet and sounds.', level: 'A1'),
          Lesson(id: 'ger_m1_l2', title: 'Lesson 2: Basic Greetings', description: 'Hallo, Guten Tag, and social etiquette.', level: 'A1'),
          Lesson(id: 'ger_m1_q', title: 'Quiz', description: 'Test your alphabet and greetings.', level: 'A1', type: LessonType.quiz),
        ],
      ),
      Module(
        id: 'ger_m2',
        title: 'Week 2: Introductions & Personal Info',
        lessons: [
          Lesson(id: 'ger_m2_l1', title: 'Lesson 1: Self Introductions', description: 'Saying who you are and where you are from.', level: 'A1'),
          Lesson(id: 'ger_m2_l2', title: 'Lesson 2: Formal vs Informal', description: 'Mastering Sie vs du.', level: 'A1'),
          Lesson(id: 'ger_m2_l3', title: 'Lesson 3: Jobs & Professions', description: 'Talking about what you do.', level: 'A1'),
        ],
      ),
      Module(
        id: 'ger_m3',
        title: 'Week 3: Numbers, Time & Dates',
        lessons: [
          Lesson(id: 'ger_m3_l1', title: 'Lesson 1: The Number System', description: 'Counting 1-1000 and the ones-before-tens rule.', level: 'A1'),
          Lesson(id: 'ger_m3_l2', title: 'Lesson 2: Telling Time', description: 'Formal and informal time.', level: 'A1'),
          Lesson(id: 'ger_m3_l3', title: 'Lesson 3: Calendar', description: 'Days, months, and dates.', level: 'A1'),
        ],
      ),
      Module(
        id: 'ger_m4',
        title: 'Week 4: Sentence Structure & Articles',
        lessons: [
          Lesson(id: 'ger_m4_l1', title: 'Lesson 1: The V2 Rule', description: 'German sentence structure basics.', level: 'A1'),
          Lesson(id: 'ger_m4_l2', title: 'Lesson 2: Articles & Gender', description: 'Mastering der, die, das.', level: 'A1'),
        ],
      ),
      Module(
        id: 'ger_m5',
        title: 'Week 5: Verbs & Final A1 Review',
        lessons: [
          Lesson(id: 'ger_m5_l1', title: 'Lesson 1: Present Tense', description: 'Regular and irregular verb conjugation.', level: 'A1'),
          Lesson(id: 'ger_m5_l2', title: 'Lesson 2: Revision', description: 'Consolidating Level A1 knowledge.', level: 'A1'),
        ],
      ),
      // --- LEVEL A2 ---
      Module(
        id: 'ger_m6',
        title: 'Week 6: Communication & Routine',
        lessons: [
          Lesson(id: 'ger_m6_l1', title: 'Lesson 1: W-Questions', description: 'Fragewörter for real conversation.', level: 'A2'),
          Lesson(id: 'ger_m6_l2', title: 'Lesson 2: Daily Routine', description: 'Reflexive verbs and daily schedule.', level: 'A2'),
        ],
      ),
      Module(
        id: 'ger_m7',
        title: 'Week 7: Housing + Food & Shopping',
        lessons: [
          Lesson(id: 'ger_m7_l1', title: 'Lesson 1: At Home', description: 'Rooms, furniture, and location (Dative).', level: 'A2'),
          Lesson(id: 'ger_m7_l2', title: 'Lesson 2: Shopping', description: 'Supermarket vocabulary and quantities.', level: 'A2'),
        ],
      ),
      Module(
        id: 'ger_m8',
        title: 'Week 8: Restaurant + Health & Body',
        lessons: [
          Lesson(id: 'ger_m8_l1', title: 'Lesson 1: Dining Out', description: 'Ordering and paying at a restaurant.', level: 'A2'),
          Lesson(id: 'ger_m8_l2', title: 'Lesson 2: Health', description: 'Body parts and doctor visits.', level: 'A2'),
        ],
      ),
      Module(
        id: 'ger_m9',
        title: 'Week 9: Travel + Fashion & Colors',
        lessons: [
          Lesson(id: 'ger_m9_l1', title: 'Lesson 1: Travel', description: 'Directions and travel phrases.', level: 'A2'),
          Lesson(id: 'ger_m9_l2', title: 'Lesson 2: Style', description: 'Fashion, clothes, and colors.', level: 'A2'),
        ],
      ),
      Module(
        id: 'ger_m10',
        title: 'Week 10: Career + Final A2 Revision',
        lessons: [
          Lesson(id: 'ger_m10_l1', title: 'Lesson 1: Career', description: 'Work, professions, and job interviews.', level: 'A2'),
          Lesson(id: 'ger_m10_l2', title: 'Lesson 2: A2 Final Assessment', description: 'Reviewing Level A2.', level: 'A2'),
        ],
      ),
      // --- LEVEL B1 (Second Term) ---
      Module(
        id: 'ger_b1_m1',
        title: 'Week 1: Past Tense (Perfekt)',
        lessons: [
          Lesson(id: 'ger_b1_m1_l1', title: 'Lesson 1: Haben vs Sein', description: 'Mastering the Perfekt auxiliary verbs.', level: 'B1'),
          Lesson(id: 'ger_b1_m1_l2', title: 'Lesson 2: Irregular Participles', description: 'Common strong verbs in the past.', level: 'B1'),
        ],
      ),
      Module(
        id: 'ger_b1_m2',
        title: 'Week 2: Narrating the Past (Präteritum)',
        lessons: [
          Lesson(id: 'ger_b1_m2_l1', title: 'Lesson 1: war & hatte', description: 'Using the simple past for states and possession.', level: 'B1'),
          Lesson(id: 'ger_b1_m2_l2', title: 'Lesson 2: Simple Stories', description: 'Narrating your childhood.', level: 'B1'),
        ],
      ),
      Module(
        id: 'ger_b1_m3',
        title: 'Week 3: Opinions & Relationships',
        lessons: [
          Lesson(id: 'ger_b1_m3_l1', title: 'Lesson 1: dass-Sätze', description: 'Expressing thoughts and beliefs.', level: 'B1'),
          Lesson(id: 'ger_b1_m3_l2', title: 'Lesson 2: weil-Sätze', description: 'Giving reasons and explanations.', level: 'B1'),
        ],
      ),
      Module(
        id: 'ger_b1_m4',
        title: 'Week 4: Travel & Vacations',
        lessons: [
          Lesson(id: 'ger_b1_m4_l1', title: 'Lesson 1: Booking a Trip', description: 'Travel vocabulary and adjective endings.', level: 'B1'),
          Lesson(id: 'ger_b1_m4_l2', title: 'Lesson 2: Postcards', description: 'Describing landscapes and activities.', level: 'B1'),
        ],
      ),
      Module(
        id: 'ger_b1_m5',
        title: 'Week 5: B1 Review & Assessment',
        lessons: [
          Lesson(id: 'ger_b1_m5_l1', title: 'Lesson 1: Mastery Review', description: 'Consolidating B1 grammar.', level: 'B1'),
          Lesson(id: 'ger_b1_m5_l2', title: 'Lesson 2: Final Test', description: 'Intermediate proficiency exam.', level: 'B1'),
        ],
      ),
      // --- LEVEL B2 (Second Term) ---
      Module(
        id: 'ger_b2_m6',
        title: 'Week 6: The Passive Voice',
        lessons: [
          Lesson(id: 'ger_b2_m6_l1', title: 'Lesson 1: Vorgangspassiv', description: 'Understanding how things are done.', level: 'B2'),
          Lesson(id: 'ger_b2_m6_l2', title: 'Lesson 2: Passive in Context', description: 'Using passive in news and processes.', level: 'B2'),
        ],
      ),
      Module(
        id: 'ger_b2_m7',
        title: 'Week 7: Hypothetical Worlds',
        lessons: [
          Lesson(id: 'ger_b2_m7_l1', title: 'Lesson 1: Konjunktiv II', description: 'Wishes, dreams, and polite requests.', level: 'B2'),
          Lesson(id: 'ger_b2_m7_l2', title: 'Lesson 2: Unreal Conditions', description: 'What would happen if...', level: 'B2'),
        ],
      ),
      Module(
        id: 'ger_b2_m8',
        title: 'Week 8: Environment & Future',
        lessons: [
          Lesson(id: 'ger_b2_m8_l1', title: 'Lesson 1: Climate Change', description: 'Discussing environmental issues.', level: 'B2'),
          Lesson(id: 'ger_b2_m8_l2', title: 'Lesson 2: Futur I & II', description: 'Expressing future intentions and completions.', level: 'B2'),
        ],
      ),
      Module(
        id: 'ger_b2_m9',
        title: 'Week 9: Culture & Society',
        lessons: [
          Lesson(id: 'ger_b2_m9_l1', title: 'Lesson 1: Relative Clauses', description: 'Advanced descriptions and detail.', level: 'B2'),
          Lesson(id: 'ger_b2_m9_l2', title: 'Lesson 2: The Genitive Case', description: 'Expressing possession and relationships formally.', level: 'B2'),
        ],
      ),
      Module(
        id: 'ger_b2_m10',
        title: 'Week 10: B2 Review & Term 2 Completion',
        lessons: [
          Lesson(id: 'ger_b2_m10_l1', title: 'Lesson 1: Final Mastery Review', description: 'Consolidating Term 2 knowledge.', level: 'B2'),
          Lesson(id: 'ger_b2_m10_l2', title: 'Lesson 2: Proficiency Assessment', description: 'Upper intermediate terminal exam.', level: 'B2'),
        ],
      ),
      // --- LEVEL C1 (Third Term) ---
      Module(
        id: 'ger_c1_m1',
        title: 'Week 1: Abstract Ideas',
        lessons: [
          Lesson(id: 'ger_c1_m1_l1', title: 'Lesson 1: Nominalization', description: 'Turning verbs and adjectives into nouns.', level: 'C1'),
          Lesson(id: 'ger_c1_m1_l2', title: 'Lesson 2: Complex Adjectives', description: 'Describing abstract concepts in detail.', level: 'C1'),
        ],
      ),
      Module(
        id: 'ger_c1_m2',
        title: 'Week 2: Politics & Law',
        lessons: [
          Lesson(id: 'ger_c1_m2_l1', title: 'Lesson 1: State & Society', description: 'Political systems and civil rights.', level: 'C1'),
          Lesson(id: 'ger_c1_m2_l2', title: 'Lesson 2: Legal Terminology', description: 'Basic law and justice vocabulary.', level: 'C1'),
        ],
      ),
      Module(
        id: 'ger_c1_m3',
        title: 'Week 3: Science & Research',
        lessons: [
          Lesson(id: 'ger_c1_m3_l1', title: 'Lesson 1: Scientific Method', description: 'Describing experiments and findings.', level: 'C1'),
          Lesson(id: 'ger_c1_m3_l2', title: 'Lesson 2: Academic Writing', description: 'Formal structures for research papers.', level: 'C1'),
        ],
      ),
      Module(
        id: 'ger_c1_m4',
        title: 'Week 4: Literature & Arts',
        lessons: [
          Lesson(id: 'ger_c1_m4_l1', title: 'Lesson 1: Literary Analysis', description: 'Interpreting prose and poetry.', level: 'C1'),
          Lesson(id: 'ger_c1_m4_l2', title: 'Lesson 2: Stylistic Devices', description: 'Metaphors, irony, and symbolism.', level: 'C1'),
        ],
      ),
      Module(
        id: 'ger_c1_m5',
        title: 'Week 5: Advanced Review',
        lessons: [
          Lesson(id: 'ger_c1_m5_l1', title: 'Lesson 1: C1 Assessment', description: 'Advanced proficiency exam.', level: 'C1'),
        ],
      ),
      // --- LEVEL C2 (Third Term) ---
      Module(
        id: 'ger_c2_m6',
        title: 'Week 6: Nuances & Idioms',
        lessons: [
          Lesson(id: 'ger_c2_m6_l1', title: 'Lesson 1: Idiomatic Expressions', description: 'Mastering cultural sayings.', level: 'C2'),
          Lesson(id: 'ger_c2_m6_l2', title: 'Lesson 2: Subtle Meanings', description: 'Differentiating similar words.', level: 'C2'),
        ],
      ),
      Module(
        id: 'ger_c2_m7',
        title: 'Week 7: Professional Mastery',
        lessons: [
          Lesson(id: 'ger_c2_m7_l1', title: 'Lesson 1: Business Negotiations', description: 'Complex professional dialogue.', level: 'C2'),
          Lesson(id: 'ger_c2_m7_l2', title: 'Lesson 2: Corporate Ethics', description: 'Discussing moral issues in work.', level: 'C2'),
        ],
      ),
      Module(
        id: 'ger_c2_m8',
        title: 'Week 8: Philosophy & Ethics',
        lessons: [
          Lesson(id: 'ger_c2_m8_l1', title: 'Lesson 1: Existentialism', description: 'German philosophical traditions.', level: 'C2'),
          Lesson(id: 'ger_c2_m8_l2', title: 'Lesson 2: Moral Debate', description: 'Arguing ethical positions.', level: 'C2'),
        ],
      ),
      Module(
        id: 'ger_c2_m9',
        title: 'Week 9: Dialects & Varieties',
        lessons: [
          Lesson(id: 'ger_c2_m9_l1', title: 'Lesson 1: Regional Dialects', description: 'Exploring Bavarian, Saxon, etc.', level: 'C2'),
          Lesson(id: 'ger_c2_m9_l2', title: 'Lesson 2: Language Evolution', description: 'How German changes over time.', level: 'C2'),
        ],
      ),
      Module(
        id: 'ger_c2_m10',
        title: 'Week 10: Grand Final Mastery',
        lessons: [
          Lesson(id: 'ger_c2_m10_l1', title: 'Lesson 1: Final C2 Project', description: 'Comprehensive proficiency display.', level: 'C2'),
          Lesson(id: 'ger_c2_m10_l2', title: 'Lesson 2: Mastery Diploma', description: 'Completion of the German track.', level: 'C2'),
        ],
      ),
    ],
    'Chinese': [
      // --- LEVEL A1 (Term 1) ---
      Module(
        id: 'chi_m1',
        title: 'Week 1: Pinyin & Tones',
        lessons: [
          Lesson(id: 'chi_m1_l1', title: 'Lesson 1: Initials & Finals', description: 'Basic sounds of Mandarin Chinese.', level: 'A1'),
          Lesson(id: 'chi_m1_l2', title: 'Lesson 2: The Four Tones', description: 'Mastering the essential pitch variations.', level: 'A1'),
        ],
      ),
      Module(
        id: 'chi_m2',
        title: 'Week 2: Greetings & Numbers',
        lessons: [
          Lesson(id: 'chi_m2_l1', title: 'Lesson 1: Ni Hao', description: 'Basic greetings and social etiquette.', level: 'A1'),
          Lesson(id: 'chi_m2_l2', title: 'Lesson 2: Counting 1-100', description: 'Essential numbers for daily use.', level: 'A1'),
        ],
      ),
      Module(
        id: 'chi_m3',
        title: 'Week 3: Identity & Family',
        lessons: [
          Lesson(id: 'chi_m3_l1', title: 'Lesson 1: Self Intro', description: 'Talking about your name and nationality.', level: 'A1'),
          Lesson(id: 'chi_m3_l2', title: 'Lesson 2: My Family', description: 'Members of the family and titles.', level: 'A1'),
        ],
      ),
      Module(
        id: 'chi_m4',
        title: 'Week 4: Time & Dates',
        lessons: [
          Lesson(id: 'chi_m4_l1', title: 'Lesson 1: Days & Months', description: 'Calendars and scheduling.', level: 'A1'),
          Lesson(id: 'chi_m4_l2', title: 'Lesson 2: Telling Time', description: 'Hours, minutes, and time of day.', level: 'A1'),
        ],
      ),
      Module(
        id: 'chi_m5',
        title: 'Week 5: A1 Review & Assessment',
        lessons: [
          Lesson(id: 'chi_m5_l1', title: 'Lesson 1: Level A1 Check', description: 'Consolidating beginner knowledge.', level: 'A1'),
        ],
      ),
      // --- LEVEL A2 (Term 1) ---
      Module(
        id: 'chi_m6',
        title: 'Week 6: Daily Life & Routine',
        lessons: [
          Lesson(id: 'chi_m6_l1', title: 'Lesson 1: My Day', description: 'Common verbs and daily activities.', level: 'A2'),
          Lesson(id: 'chi_m6_l2', title: 'Lesson 2: Hobbies', description: 'Talking about what you like to do.', level: 'A2'),
        ],
      ),
      Module(
        id: 'chi_m7',
        title: 'Week 7: Shopping & Food',
        lessons: [
          Lesson(id: 'chi_m7_l1', title: 'Lesson 1: At the Market', description: 'Buying food and basic bargaining.', level: 'A2'),
          Lesson(id: 'chi_m7_l2', title: 'Lesson 2: Ordering Food', description: 'Restaurant phrases and menus.', level: 'A2'),
        ],
      ),
      Module(
        id: 'chi_m8',
        title: 'Week 8: Locations & Travel',
        lessons: [
          Lesson(id: 'chi_m8_l1', title: 'Lesson 1: Directions', description: 'Asking for the way and landmarks.', level: 'A2'),
          Lesson(id: 'chi_m8_l2', title: 'Lesson 2: Transportation', description: 'Trains, buses, and planes.', level: 'A2'),
        ],
      ),
      Module(
        id: 'chi_m9',
        title: 'Week 9: Health & Weather',
        lessons: [
          Lesson(id: 'chi_m9_l1', title: 'Lesson 1: Feeling Unwell', description: 'Body parts and doctor visits.', level: 'A2'),
          Lesson(id: 'chi_m9_l2', title: 'Lesson 2: Seasons', description: 'Describing weather and climate.', level: 'A2'),
        ],
      ),
      Module(
        id: 'chi_m10',
        title: 'Week 10: A2 Final Review',
        lessons: [
          Lesson(id: 'chi_m10_l1', title: 'Lesson 1: Assessment', description: 'Reviewing Term 1 Chinese.', level: 'A2'),
        ],
      ),
      // --- LEVEL B1 (Term 2) ---
      Module(
        id: 'chi_m11',
        title: 'Week 1: Past Experiences (Guo)',
        lessons: [
          Lesson(id: 'chi_m11_l1', title: 'Lesson 1: Have you ever...?', description: 'Using "Guo" for past actions.', level: 'B1'),
        ],
      ),
      Module(
        id: 'chi_m12',
        title: 'Week 2: Plan & Arrangements',
        lessons: [
          Lesson(id: 'chi_m12_l1', title: 'Lesson 1: Making Plans', description: 'Scheduling meetings and events.', level: 'B1'),
        ],
      ),
      Module(
        id: 'chi_m13',
        title: 'Week 3: Emotions & Feelings',
        lessons: [
          Lesson(id: 'chi_m13_l1', title: 'Lesson 1: Expressing Yourself', description: 'Detailed descriptions of mood.', level: 'B1'),
        ],
      ),
      Module(
        id: 'chi_m14',
        title: 'Week 4: Work & Career',
        lessons: [
          Lesson(id: 'chi_m14_l1', title: 'Lesson 1: The Office', description: 'Professional titles and tasks.', level: 'B1'),
        ],
      ),
      Module(
        id: 'chi_m15',
        title: 'Week 5: B1 Review',
        lessons: [
          Lesson(id: 'chi_m15_l1', title: 'Lesson 1: Progress Check', description: 'Consolidating intermediate skills.', level: 'B1'),
        ],
      ),
      // --- LEVEL B2 (Term 2) ---
      Module(
        id: 'chi_m16',
        title: 'Week 6: Business Etiquette',
        lessons: [
          Lesson(id: 'chi_m16_l1', title: 'Lesson 1: Formality', description: 'Cultural norms in business.', level: 'B2'),
        ],
      ),
      Module(
        id: 'chi_m17',
        title: 'Week 7: News & Media',
        lessons: [
          Lesson(id: 'chi_m17_l1', title: 'Lesson 1: Current Events', description: 'Reading news and social media.', level: 'B2'),
        ],
      ),
      Module(
        id: 'chi_m18',
        title: 'Week 8: Technology & Future',
        lessons: [
          Lesson(id: 'chi_m18_l1', title: 'Lesson 1: Digital Life', description: 'AI, internet, and tech trends.', level: 'B2'),
        ],
      ),
      Module(
        id: 'chi_m19',
        title: 'Week 9: Environment',
        lessons: [
          Lesson(id: 'chi_m19_l1', title: 'Lesson 1: Sustainability', description: 'Discussing climate and nature.', level: 'B2'),
        ],
      ),
      Module(
        id: 'chi_m20',
        title: 'Week 10: Term 2 Mastery',
        lessons: [
          Lesson(id: 'chi_m20_l1', title: 'Lesson 1: Assessment', description: 'Upper-intermediate review.', level: 'B2'),
        ],
      ),
      // --- LEVEL C1 (Term 3) ---
      Module(
        id: 'chi_m21',
        title: 'Week 1: Abstract Concepts',
        lessons: [
          Lesson(id: 'chi_m21_l1', title: 'Lesson 1: Philosophy', description: 'Advanced abstract discussions.', level: 'C1'),
        ],
      ),
      Module(
        id: 'chi_m22',
        title: 'Week 2: Proverbs (Chengyu)',
        lessons: [
          Lesson(id: 'chi_m22_l1', title: 'Lesson 1: Idiomatic Wisdom', description: 'Mastering 4-character proverbs.', level: 'C1'),
        ],
      ),
      Module(
        id: 'chi_m23',
        title: 'Week 3: Politics & Society',
        lessons: [
          Lesson(id: 'chi_m23_l1', title: 'Lesson 1: Deep Debate', description: 'Complex social issues.', level: 'C1'),
        ],
      ),
      Module(
        id: 'chi_m24',
        title: 'Week 4: Classical Influence',
        lessons: [
          Lesson(id: 'chi_m24_l1', title: 'Lesson 1: Literature', description: 'Modern and classical analysis.', level: 'C1'),
        ],
      ),
      Module(
        id: 'chi_m25',
        title: 'Week 5: C1 Review',
        lessons: [
          Lesson(id: 'chi_m25_l1', title: 'Lesson 1: Advanced Assessment', description: 'C1 mastery check.', level: 'C1'),
        ],
      ),
      // --- LEVEL C2 (Term 3) ---
      Module(
        id: 'chi_m26',
        title: 'Week 6: Cultural Mastery',
        lessons: [
          Lesson(id: 'chi_m26_l1', title: 'Lesson 1: Nuance', description: 'Near-native expression.', level: 'C2'),
        ],
      ),
      Module(
        id: 'chi_m27',
        title: 'Week 7: Negotiation Mastery',
        lessons: [
          Lesson(id: 'chi_m27_l1', title: 'Lesson 1: Diplomacy', description: 'Advanced professional usage.', level: 'C2'),
        ],
      ),
      Module(
        id: 'chi_m28',
        title: 'Week 8: Art & Esthetics',
        lessons: [
          Lesson(id: 'chi_m28_l1', title: 'Lesson 1: Critique', description: 'Analyzing beauty and form.', level: 'C2'),
        ],
      ),
      Module(
        id: 'chi_m29',
        title: 'Week 9: Dialects & History',
        lessons: [
          Lesson(id: 'chi_m29_l1', title: 'Lesson 1: Evolution', description: 'Language roots and regionalisms.', level: 'C2'),
        ],
      ),
      Module(
        id: 'chi_m30',
        title: 'Week 10: Grand Final Mastery',
        lessons: [
          Lesson(id: 'chi_m30_l1', title: 'Lesson 1: Graduation', description: 'Final Mastery Project.', level: 'C2'),
        ],
      ),
    ],
    'French': [],
    'English': [],
  };

  List<Module> getModules(String language) => _curriculums[language] ?? [];

  List<Module> getModulesByLevel(String language, String level) {
    final allModules = _curriculums[language] ?? [];
    return allModules.where((m) => m.lessons.any((l) => l.level == level)).toList();
  }

  bool isLevelUnlocked(String language, String level) {
    return true; // All levels unlocked for exploration
  }

  void addPoints(int amount) {
    _points += amount;
    notifyListeners();
  }

  void completeLesson(String language, String lessonId) {
    final modules = _curriculums[language];
    if (modules == null) return;

    for (var module in modules) {
      final lessonIndex = module.lessons.indexWhere((l) => l.id == lessonId);
      if (lessonIndex != -1 && !module.lessons[lessonIndex].isCompleted) {
        module.lessons[lessonIndex].isCompleted = true;
        addPoints(100);
        
        // Check if all lessons in module are completed
        if (module.lessons.every((l) => l.isCompleted)) {
          module.isCompleted = true;
        }

        // Check if all modules in the level (e.g. A1) are completed
        final level = module.lessons[lessonIndex].level;
        final allModulesInLevel = modules.where((m) => m.lessons.any((l) => l.level == level));
        if (allModulesInLevel.every((m) => m.isCompleted)) {
          if (!_completedLevels[language]!.contains(level)) {
            _completedLevels[language]!.add(level);
            _updateFluency(level);
          }
        }
        
        notifyListeners();
        return;
      }
    }
  }

  void completeWeek(String language, String level, int weekNumber) {
    final modules = getModulesByLevel(language, level);
    
    // Calculate index within the filtered level list
    int moduleIndex;
    if (level == 'A2' || level == 'B2' || level == 'C2') {
      moduleIndex = weekNumber - 6;
    } else {
      moduleIndex = weekNumber - 1;
    }
    
    if (moduleIndex >= 0 && moduleIndex < modules.length) {
      final module = modules[moduleIndex];
      
      // Mark all lessons in this week as completed
      for (var lesson in module.lessons) {
        lesson.isCompleted = true;
      }
      module.isCompleted = true;
      addPoints(200);

      // Check if all modules for the current level are done
      final allModulesInLevel = _curriculums[language]!.where((m) => m.lessons.any((l) => l.level == level));
      
      if (allModulesInLevel.every((m) => m.isCompleted)) {
        if (!_completedLevels[language]!.contains(level)) {
          _completedLevels[language]!.add(level);
          _updateFluency(level);
        }
      }
      
      notifyListeners();
    }
  }

  void _updateFluency(String level) {
    final levelsOrder = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
    final nextIndex = levelsOrder.indexOf(level) + 1;
    if (nextIndex < levelsOrder.length) {
      _currentFluency = levelsOrder[nextIndex];
    }
  }
}
