import 'package:flutter/material.dart';
import 'level_selection_screen.dart';

class TermSelectionScreen extends StatelessWidget {
  final String language;

  const TermSelectionScreen({super.key, required this.language});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Hero(
          tag: 'lang_$language',
          child: Material(
            color: Colors.transparent,
            child: Text(
              '$language Study Plan',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Your Term',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Master $language following our 3-term intensive curriculum.',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView(
                children: [
                  _TermCard(
                    termTitle: 'First Term',
                    subtitle: 'Fundamentals & Basic Communication',
                    icon: Icons.filter_1,
                    color: Colors.blue.shade600,
                    onTap: () => _navigateToLevel(context, ['A1', 'A2'], 'First Term'),
                  ),
                  _TermCard(
                    termTitle: 'Second Term',
                    subtitle: 'Daily Situations & Past Events',
                    icon: Icons.filter_2,
                    color: Colors.orange.shade700,
                    onTap: () => _navigateToLevel(context, ['B1', 'B2'], 'Second Term'),
                  ),
                  _TermCard(
                    termTitle: 'Third Term',
                    subtitle: 'Opinions & Complex Structures',
                    icon: Icons.filter_3,
                    color: Colors.purple.shade600,
                    onTap: () => _navigateToLevel(context, ['C1', 'C2'], 'Third Term'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToLevel(BuildContext context, List<String> codes, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LevelSelectionScreen(
          language: language,
          filterCodes: codes,
          title: '$title Levels',
        ),
      ),
    );
  }
}

class _TermCard extends StatelessWidget {
  final String termTitle;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _TermCard({
    required this.termTitle,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: color, size: 32),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        termTitle,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
