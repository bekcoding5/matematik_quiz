import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matematik_quiz/class/question.dart';
import 'package:matematik_quiz/main.dart';
import 'package:matematik_quiz/screens/result_page.dart';
import 'package:matematik_quiz/widgets/glass_box.dart';
import 'package:matematik_quiz/main.dart' show player;
// ignore: undefined_shown_name
import 'package:matematik_quiz/main.dart' show MathEngine;

class CoinCounter extends StatelessWidget {
  final int coins;
  const CoinCounter({super.key, required this.coins});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.monetization_on, color: Colors.amber, size: 24),
        const SizedBox(width: 5),
        Text(
          "$coins",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}

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
  int _coins = 0;
  int _timeLeft = 0;
  Timer? _timer;
  Color _flashColor = Colors.transparent;
  List<WrongAnswer> _wrongAnswersList = [];

  @override
  void initState() {
    super.initState();
    _timeLeft = widget.time;
    _generateNext();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _onAnswer(-1);
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
    bool correct = (ans == _q.correctAnswer);

    await player.stop();

    if (correct) {
      await player.play(AssetSource('sounds/correct.mp3'));
      HapticFeedback.lightImpact();
      _score += 10;
      _coins += 5;
    } else {
      await player.play(AssetSource('sounds/wrong.mp3'));
      HapticFeedback.vibrate();
      if (ans != -1) {
        _wrongAnswersList.add(
          WrongAnswer(
            question: _q.text,
            correct: _q.correctAnswer,
            userAns: ans,
          ),
        );
      }
    }

    setState(() {
      _flashColor = correct
          ? Colors.green.withOpacity(0.2)
          : Colors.red.withOpacity(0.2);
    });

    Future.delayed(const Duration(milliseconds: 300), () {
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
          coins: _coins,
          difficulty: widget.diff, // ← shu qo'shildi
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
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
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
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "SAVOL: ${_currentIndex + 1}/${widget.totalQuestions}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    CoinCounter(coins: _coins),
                    GlassBox(
                      opacity: 0.2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: Text(
                          "00:${_timeLeft.toString().padLeft(2, '0')}",
                          style: const TextStyle(
                            fontSize: 18,
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
                    height: 160,
                    alignment: Alignment.center,
                    child: Text(
                      _q.text,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
                  childAspectRatio: 1.4,
                  children: _q.options.map((o) => _answerBtn(o)).toList(),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}