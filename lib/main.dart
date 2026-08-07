import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'profile_screen.dart';
import 'providers/language_provider.dart';
import 'screens/term_selection_screen.dart';
import 'tutor_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: const SunshineLanguageTutorApp(),
    ),
  );
}

class SunshineLanguageTutorApp extends StatelessWidget {
  const SunshineLanguageTutorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Sunshine Language Tutor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          primary: Colors.blueAccent,
          secondary: Colors.orangeAccent,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/logo.png', cacheWidth: 100),
        ),
        title: const Text(
          'My Sunshine Language Tutor',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/logo.png',
                height: 100,
                cacheHeight: 250,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Welcome back, Learner!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(

              'What would you like to learn today?',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _LanguageCard(
                  language: 'German',
                  flag: '🇩🇪',
                  gradientColors: [Colors.orange.shade400, Colors.deepOrange.shade600],
                  onTap: () => _startTutor(context, 'German'),
                ),
                _LanguageCard(
                  language: 'French',
                  flag: '🇫🇷',
                  gradientColors: [Colors.blue.shade400, Colors.indigo.shade600],
                  onTap: () => _startTutor(context, 'French'),
                ),
                _LanguageCard(
                  language: 'Chinese',
                  flag: '🇨🇳',
                  gradientColors: [Colors.red.shade400, Colors.red.shade800],
                  onTap: () => _startTutor(context, 'Chinese'),
                ),
                _LanguageCard(
                  language: 'English',
                  flag: '🇬🇧',
                  gradientColors: [Colors.teal.shade400, Colors.green.shade700],
                  onTap: () => _startTutor(context, 'English'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'Your Progress',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _ProgressSummary(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Sunshine Tutor'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
        ],
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
             _startTutor(context, 'English'); // Default to English for general tutor
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TutorScreen(language: 'English'),
            ),
          );
        },
        label: const Text('Ask AI'),
        icon: const Icon(Icons.mic),
      ),
    );
  }

  void _startTutor(BuildContext context, String language) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TermSelectionScreen(language: language),
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  final String language;
  final String flag;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const _LanguageCard({
    required this.language,
    required this.flag,
    required this.gradientColors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'lang_$language',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: gradientColors.last.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Text(flag, style: const TextStyle(fontSize: 44)),
                ),
                const SizedBox(height: 12),
                Text(
                  language,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LanguageProvider>(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
              label: 'Streak',
              value: '${provider.streak} Days',
              icon: Icons.local_fire_department,
              color: Colors.orange),
          Container(width: 1, height: 40, color: Colors.grey.shade200),
          _StatItem(
              label: 'Points',
              value: provider.points.toString(),
              icon: Icons.stars,
              color: Colors.amber),
          Container(width: 1, height: 40, color: Colors.grey.shade200),
          _StatItem(
              label: 'Fluency',
              value: provider.fluency,
              icon: Icons.trending_up,
              color: Colors.blue),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
