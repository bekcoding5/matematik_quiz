import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matematik_quiz/class/question.dart';
import 'package:matematik_quiz/main.dart';
import 'package:matematik_quiz/screens/result_page.dart';
import 'package:matematik_quiz/widgets/glass_box.dart';

class GameScreen extends StatefulWidget {
  final String diff;
  final int time;
  final int totalQuestions;
  const GameScreen({
    super.key,
    required this.diff,
    required this.time,
    required this.totalQuestions,
  });
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final MathEngine _engine = MathEngine();
  late Question _q;
  int _currentIndex = 0;
  int _score = 0;
  int _timeLeft = 0;
  Timer? _timer;
  Color _flashColor = Colors.transparent;
  List<WrongAnswer> _wrongAnswersList = [];

  @override
  void initState() {
    super.initState();
    _timeLeft = widget.time;
    _generateNext();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _finish();
      }
    });
  }

  void _generateNext() {
    if (_currentIndex >= widget.totalQuestions) {
      _finish();
    } else {
      _q = _engine.generate(widget.diff);
      _timeLeft = widget.time;
    }
  }

  void _onAnswer(int ans) async {
    bool correct = ans == _q.correctAnswer;
    await player.play(
      correct
          ? AssetSource('sounds/correct.mp3')
          : AssetSource('sounds/wrong.mp3'),
    );
    setState(() {
      _flashColor = correct
          ? Colors.green.withOpacity(0.2)
          : Colors.red.withOpacity(0.2);
    });

    if (correct) {
      _score += 10;
      HapticFeedback.lightImpact();
    } else {
      _wrongAnswersList.add(
        WrongAnswer(question: _q.text, correct: _q.correctAnswer, userAns: ans),
      );
      HapticFeedback.vibrate();
    }

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _flashColor = Colors.transparent;
          _currentIndex++;
          _generateNext();
        });
      }
    });
  }

  void _finish() {
    _timer?.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultPage(
          score: _score,
          wrongs: _wrongAnswersList,
          totalQuestions: widget.totalQuestions,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget _answerBtn(int val) {
    return GestureDetector(
      onTap: () => _onAnswer(val),
      child: GlassBox(
        child: Center(
          child: Text(
            "$val",
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        color: _flashColor,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "SAVOL: ${_currentIndex + 1}/${widget.totalQuestions}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    GlassBox(
                      opacity: 0.2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 5,
                        ),
                        child: Text(
                          "00:${_timeLeft.toString().padLeft(2, '0')}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.cyanAccent,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: GlassBox(
                  opacity: 0.15,
                  child: Container(
                    width: double.infinity,
                    height: 180,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyanAccent.withOpacity(0.05),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _q.text,
                        style: const TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black54,
                              blurRadius: 10,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),

              const Spacer(),

              Padding(
                padding: const EdgeInsets.all(25),
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio: 1.3,
                  children: _q.options.map((o) => _answerBtn(o)).toList(),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
