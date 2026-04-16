import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:matematik_quiz/main.dart';
import 'package:matematik_quiz/screens/game.dart';
import 'package:matematik_quiz/widgets/glass_box.dart';
import 'package:matematik_quiz/widgets/gradient_scaffold.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  String _diff = 'Medium';
  int _time = 30;
  int _count = 10;

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        title: const Text(
          'SETTINGS',
          style: TextStyle(letterSpacing: 3, fontWeight: FontWeight.w900),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              _optionTile(
                'DIFFICULTY',
                ['Easy', 'Medium', 'Hard'],
                _diff,
                (v) => setState(() => _diff = v),
              ),
              const SizedBox(height: 15),
              _optionTile(
                'TIME (seconds)',
                [15, 30, 45],
                _time,
                (v) => setState(() => _time = v),
              ),
              const SizedBox(height: 15),
              _optionTile(
                'NUMBER OF QUESTIONS',
                [5, 10, 20],
                _count,
                (v) => setState(() => _count = v),
              ),
              const Spacer(),
              _startBtn(context),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _startBtn(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        try {
          await player.play(AssetSource('sounds/click.wav'));
        } catch (_) {}
        if (!context.mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => GameScreen(
              diff: _diff,
              time: _time,
              totalQuestions: _count,
            ),
          ),
        );
      },
      child: GlassBox(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.play_arrow_rounded, color: Colors.cyanAccent, size: 28),
              SizedBox(width: 10),
              Text(
                'START GAME',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _optionTile(
    String title,
    List<dynamic> opts,
    dynamic curr,
    Function(dynamic) onS,
  ) {
    return GlassBox(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.cyanAccent,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: opts.map((o) {
                final isSelected = curr == o;
                return GestureDetector(
                  onTap: () => onS(o),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.cyanAccent.withOpacity(0.25)
                          : Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? Colors.cyanAccent.withOpacity(0.6)
                            : Colors.white.withOpacity(0.15),
                      ),
                    ),
                    child: Text(
                      '$o',
                      style: TextStyle(
                        color: isSelected ? Colors.cyanAccent : Colors.white70,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 15,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
