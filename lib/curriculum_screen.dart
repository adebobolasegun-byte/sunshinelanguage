import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/language_provider.dart';
import 'models/lesson.dart';

class CurriculumScreen extends StatelessWidget {
  final String language;

  const CurriculumScreen({super.key, required this.language});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LanguageProvider>(context);
    final modules = provider.getModules(language);
    
    // We should probably filter modules by level if we want to show a specific level's curriculum
    // But since this is often called from WeeksSelectionScreen which knows the level,
    // let's ensure it shows what's expected.
    
    // If you want to show ALL modules for a language, use the line above.
    // If you want to show only the currently active modules for the student:
    // final modules = provider.getModulesByLevel(language, 'A1'); // Example

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'First Term',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showTermInfo(context);
            },
          ),
        ],
      ),
      body: modules.isEmpty
          ? const Center(child: Text('Coming soon for this language!'))
          : Column(
              children: [
                _buildTermProgress(provider, modules),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: modules.length,
                    itemBuilder: (context, index) {
                      final module = modules[index];
                      // Display as Unit 1, Unit 2...
                      return _UnitCard(
                        unitNumber: index + 1,
                        module: module,
                        language: language,
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildTermProgress(LanguageProvider provider, List<Module> modules) {
    int totalLessons = modules.fold(0, (sum, m) => sum + m.lessons.length);
    int completedLessons = modules.fold(
        0, (sum, m) => sum + m.lessons.where((l) => l.isCompleted).length);
    double progress = totalLessons > 0 ? completedLessons / totalLessons : 0;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.blueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Term 1 Progress',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white24,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: 10,
            borderRadius: BorderRadius.circular(5),
          ),
          const SizedBox(height: 8),
          Text(
            '$completedLessons of $totalLessons Lessons Completed',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  void _showTermInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('First Term Syllabus'),
        content: const Text(
          'This term covers the foundational basics of German including the Alphabet, Greetings, Numbers, and basic Sentence Structure (A1 Level Part 1).',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }
}

class _UnitCard extends StatelessWidget {
  final int unitNumber;
  final Module module;
  final String language;

  const _UnitCard({
    required this.unitNumber,
    required this.module,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Text(
            'UNIT $unitNumber: ${module.title.replaceAll('MODULE $unitNumber: ', '')}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
              letterSpacing: 1.1,
            ),
          ),
        ),
        ...module.lessons.map((lesson) => _LessonTile(
              lesson: lesson,
              language: language,
            )),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _LessonTile extends StatelessWidget {
  final Lesson lesson;
  final String language;

  const _LessonTile({required this.lesson, required this.language});

  IconData _getIcon() {
    switch (lesson.type) {
      case LessonType.quiz:
        return Icons.quiz_outlined;
      case LessonType.audio:
        return Icons.headphones_outlined;
      case LessonType.dialogue:
        return Icons.forum_outlined;
      case LessonType.flashcards:
        return Icons.style_outlined;
      case LessonType.exam:
        return Icons.assignment_outlined;
      case LessonType.lesson:
        return Icons.menu_book_outlined;
    }
  }

  Color _getColor() {
    if (lesson.isCompleted) return Colors.green;
    switch (lesson.type) {
      case LessonType.quiz:
        return Colors.orange;
      case LessonType.exam:
        return Colors.red;
      case LessonType.audio:
        return Colors.purple;
      case LessonType.lesson:
      case LessonType.dialogue:
      case LessonType.flashcards:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getColor().withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(_getIcon(), color: _getColor(), size: 24),
        ),
        title: Text(
          lesson.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: lesson.isCompleted ? Colors.grey : Colors.black87,
            decoration: lesson.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          lesson.description,
          style: const TextStyle(fontSize: 12),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Icon(
          lesson.isCompleted ? Icons.check_circle : Icons.arrow_forward_ios,
          color: lesson.isCompleted ? Colors.green : Colors.grey.shade400,
          size: 18,
        ),
        onTap: () {
          _showLessonPreview(context);
        },
      ),
    );
  }

  void _showLessonPreview(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_getIcon(), color: _getColor()),
                const SizedBox(width: 8),
                Text(
                  lesson.type.name.toUpperCase(),
                  style: TextStyle(
                    color: _getColor(),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              lesson.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(lesson.description, style: TextStyle(color: Colors.grey.shade700, fontSize: 16)),
            const SizedBox(height: 24),
            if (lesson.vocabulary.isNotEmpty) ...[
              const Text('Vocabulary you will see:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: lesson.vocabulary.map((v) => Chip(
                  label: Text(v),
                  backgroundColor: Colors.blue.shade50,
                  labelStyle: const TextStyle(color: Colors.blueAccent),
                )).toList(),
              ),
              const SizedBox(height: 24),
            ],
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Provider.of<LanguageProvider>(context, listen: false)
                      .completeLesson(language, lesson.id);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getColor(),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  lesson.isCompleted ? 'REVIEW NOW' : 'START NOW',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
