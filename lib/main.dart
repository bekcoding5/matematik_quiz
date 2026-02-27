import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matematik_quiz/class/question.dart';
import 'package:matematik_quiz/screens/set_up.dart';
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

          expression = "(${currentResult * divisor} / $divisor)";

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
                "Miyangizni maksimal darajada ishlating",
                style: TextStyle(color: Colors.cyanAccent, fontSize: 12),
              ),
              const SizedBox(height: 80),
              _actionBtn(
                context,
                "START",
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SetupScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionBtn(BuildContext context, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: () async {
        await player.play(AssetSource('sounds/click.wav'));
        HapticFeedback.lightImpact();
        onTap();
      },
      child: GlassBox(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}
