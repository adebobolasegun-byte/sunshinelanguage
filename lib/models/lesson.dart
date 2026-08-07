enum LessonType { lesson, quiz, audio, dialogue, flashcards, exam }

class Module {
  final String id;
  final String title;
  final List<Lesson> lessons;
  bool isCompleted;

  Module({
    required this.id,
    required this.title,
    required this.lessons,
    this.isCompleted = false,
  });
}

class Lesson {
  final String id;
  final String title;
  final String description;
  final List<String> vocabulary;
  final List<Flashcard> flashcards;
  final String level; // A1, A2, etc.
  final LessonType type;
  final bool isLocked;
  bool isCompleted;

  Lesson({
    required this.id,
    required this.title,
    required this.description,
    this.vocabulary = const [],
    this.flashcards = const [],
    required this.level,
    this.type = LessonType.lesson,
    this.isLocked = false,
    this.isCompleted = false,
  });
}

class Flashcard {
  final String front;
  final String back;
  final String pronunciation;

  Flashcard({
    required this.front,
    required this.back,
    required this.pronunciation,
  });
}
