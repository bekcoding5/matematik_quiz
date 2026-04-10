import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matematik_quiz/class/question.dart';
import 'package:matematik_quiz/screens/set_up.dart';
import 'package:matematik_quiz/screens/statistics_screen.dart';
import 'package:matematik_quiz/widgets/glass_box.dart';

final player = AudioPlayer();

class MathEngine {
  final Random _rnd = Random();

  Question generate(String difficulty) {
    int depth = difficulty == 'Oson' ? 1 : (difficulty == 'Qiyin' ? 3 : 2);
    int maxNum = difficulty == 'Oson' ? 10 : (difficulty == 'Qiyin' ? 50 : 20);
    return _generateRecursive(depth, maxNum);
  }

  Question _generateRecursive(int depth, int maxNum) {
    int currentResult = _rnd.nextInt(maxNum) + 2;
    String expression = "$currentResult";

    for (int i = 0; i < depth; i++) {
      int nextNum = _rnd.nextInt(maxNum) + 2;
      int op = _rnd.nextInt(4);

      switch (op) {
        case 0:
          currentResult += nextNum;
          expression = "($expression + $nextNum)";
          break;
        case 1:
          currentResult -= nextNum;
          expression = "($expression - $nextNum)";
          break;
        case 2:
          int smallNum = _rnd.nextInt(5) + 2;
          currentResult *= smallNum;
          expression = "($expression * $smallNum)";
          break;
        case 3:
          int divisor = _rnd.nextInt(5) + 2;
          int newVal = currentResult * divisor;
          expression = "($newVal / $divisor)";
          currentResult = newVal;
          break;
      }
    }

    if (expression.startsWith('(') && expression.endsWith(')')) {
      expression = expression.substring(1, expression.length - 1);
    }

    return _build(currentResult, expression);
  }

  Question _build(int res, String txt) {
    Set<int> opts = {res};
    while (opts.length < 4) {
      int offset = _rnd.nextInt(10) + 1;
      int w = res + (_rnd.nextBool() ? offset : -offset);
      if (w != res) opts.add(w);
    }
    return Question(
      text: txt,
      correctAnswer: res,
      options: opts.toList()..shuffle(),
    );
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(const MathMasterApp());
}

class MathMasterApp extends StatelessWidget {
  const MathMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.cyanAccent,
          brightness: Brightness.dark,
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.psychology, size: 100, color: Colors.cyanAccent),
              const SizedBox(height: 20),
              const Text(
                "MATH MASTER",
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4,
                ),
              ),
              const Text(
                "Use your brain to the fullest",
                style: TextStyle(color: Colors.cyanAccent, fontSize: 12),
              ),
              const SizedBox(height: 80),

              // ✅ START — keng, yirik, chetdan 32px bo'sh joy
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: _startBtn(context),
              ),

              const SizedBox(height: 24),

              // ✅ STATISTIKA — oddiy kichik button
              _actionBtn(
                context,
            "STATISTICS",
                Icons.bar_chart_rounded,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StatisticsScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _startBtn(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await player.play(AssetSource('sounds/click.wav'));
        HapticFeedback.lightImpact();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SetupScreen()),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.cyanAccent.withOpacity(0.6),
            width: 1.5,
          ),
          color: Colors.cyanAccent.withOpacity(0.12),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.play_arrow_rounded, color: Colors.cyanAccent, size: 32),
            SizedBox(width: 12),
            Text(
              "START",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                letterSpacing: 4,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionBtn(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: () async {
        await player.play(AssetSource('sounds/click.wav'));
        HapticFeedback.lightImpact();
        onTap();
      },
      child: GlassBox(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.cyanAccent, size: 22),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}