import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'lesson_note_screen.dart';
import '../providers/language_provider.dart';

class WeeksSelectionScreen extends StatelessWidget {
  final String language;
  final String level;

  const WeeksSelectionScreen({
    super.key,
    required this.language,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LanguageProvider>(context);
    final modules = provider.getModulesByLevel(language, level);
    
    // Generate weeks based on module index starting from 1 for each level
    final List<int> weeks = level == 'A1'
        ? List.generate(modules.length, (index) => index + 1)
        : level == 'A2'
            ? List.generate(modules.length, (index) => index + 6)
            : level == 'B1'
                ? List.generate(modules.length, (index) => index + 1)
                : level == 'B2'
                    ? List.generate(modules.length, (index) => index + 6)
                    : level == 'C1'
                        ? List.generate(modules.length, (index) => index + 1)
                        : level == 'C2'
                            ? List.generate(modules.length, (index) => index + 6)
                            : List.generate(modules.length, (index) => index + 1);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('$language $level Weeks'),
      ),
      body: weeks.isEmpty 
        ? const Center(child: Text('Coming soon!'))
        : GridView.builder(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 0.9,
        ),
        itemCount: weeks.length,
        itemBuilder: (context, index) {
          final week = weeks[index];
          // Simple unlocked view for development
          bool isLocked = false; 

          return _WeekCard(
            weekNumber: week,
            isLocked: isLocked,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LessonNoteScreen(
                    weekNumber: week,
                    weekTitle: 'Week $week - $language $level',
                    language: language,
                    level: level,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _WeekCard extends StatelessWidget {
  final int weekNumber;
  final bool isLocked;
  final VoidCallback onTap;

  const _WeekCard({
    required this.weekNumber,
    required this.isLocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isLocked ? Colors.grey.shade100 : Colors.white,
      borderRadius: BorderRadius.circular(24),
      elevation: isLocked ? 0 : 4,
      shadowColor: Colors.black.withValues(alpha: 0.05),
      child: InkWell(
        onTap: isLocked ? null : onTap,
        borderRadius: BorderRadius.circular(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isLocked ? Colors.grey.shade200 : Colors.blue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isLocked ? Icons.lock_outline : Icons.calendar_today_rounded,
                color: isLocked ? Colors.grey.shade400 : Colors.blue.shade600,
                size: 28,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Week $weekNumber',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isLocked ? Colors.grey.shade400 : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isLocked ? 'Locked' : 'Get Started',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isLocked ? Colors.grey.shade400 : Colors.green.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
