import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'weeks_selection_screen.dart';
import '../providers/language_provider.dart';

class LevelSelectionScreen extends StatelessWidget {
  final String language;
  final List<String>? filterCodes;
  final String title;

  const LevelSelectionScreen({
    super.key,
    required this.language,
    this.filterCodes,
    this.title = 'Levels',
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LanguageProvider>(context);
    
    final List<Map<String, dynamic>> allLevels = [
      {'code': 'A1', 'name': 'Beginner', 'color': Colors.green.shade600},
      {'code': 'A2', 'name': 'Elementary', 'color': Colors.teal.shade600},
      {'code': 'B1', 'name': 'Intermediate', 'color': Colors.orange.shade700},
      {'code': 'B2', 'name': 'Upper Intermediate', 'color': Colors.deepOrange.shade700},
      {'code': 'C1', 'name': 'Advanced', 'color': Colors.purple.shade600},
      {'code': 'C2', 'name': 'Master / Proficiency', 'color': Colors.red.shade700},
    ];

    final levels = filterCodes == null 
        ? allLevels 
        : allLevels.where((l) => filterCodes!.contains(l['code'])).toList();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        itemCount: levels.length,
        itemBuilder: (context, index) {
          final level = levels[index];
          final String levelCode = level['code'];
          final bool isUnlocked = provider.isLevelUnlocked(language, levelCode);
          // Calculate progress (this is a mock for now, but integrates with the provider later)
          final double progress = isUnlocked ? 0.4 : 0.0; // Mock progress

          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: Material(
              color: isUnlocked ? Colors.white : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(24),
              elevation: isUnlocked ? 4 : 0,
              shadowColor: Colors.black.withValues(alpha: 0.05),
              child: InkWell(
                onTap: isUnlocked ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WeeksSelectionScreen(
                        language: language,
                        level: levelCode,
                      ),
                    ),
                  );
                } : () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Finish previous levels to unlock!'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(24),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: isUnlocked ? level['color'].withValues(alpha: 0.1) : Colors.grey.shade200,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: isUnlocked 
                          ? Text(
                              levelCode,
                              style: TextStyle(
                                color: level['color'],
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            )
                          : Icon(Icons.lock, color: Colors.grey.shade400, size: 24),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Level $levelCode',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isUnlocked ? Colors.black87 : Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              level['name'],
                              style: TextStyle(
                                color: isUnlocked ? Colors.black54 : Colors.grey.shade400,
                                fontSize: 14,
                              ),
                            ),
                            if (isUnlocked) ...[
                              const SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  backgroundColor: level['color'].withValues(alpha: 0.1),
                                  valueColor: AlwaysStoppedAnimation<Color>(level['color']),
                                  minHeight: 6,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Icon(
                        isUnlocked ? Icons.chevron_right : Icons.lock_outline,
                        color: isUnlocked ? Colors.grey.shade400 : Colors.grey.shade300,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
