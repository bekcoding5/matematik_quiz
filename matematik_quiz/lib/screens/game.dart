import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matematik_quiz/class/math_engine.dart';  // MathEngine
import 'package:matematik_quiz/class/question.dart';      // Question, WrongAnswer
import 'package:matematik_quiz/main.dart';                // player (AudioPlayer)
import 'package:matematik_quiz/screens/result_page.dart';
import 'package:matematik_quiz/widgets/glass_box.dart';
import 'package:matematik_quiz/widgets/gradient_scaffold.dart';

// qolgan kod o'zgarishsiz...;

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
  final List<WrongAnswer> _wrongAnswersList = [];
  bool _isAnswering = false;

  @override
  void initState() {
    super.initState();
    _timeLeft = widget.time;
    _q = _engine.generate(widget.diff);
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _onAnswer(-1); // vaqt tugadi
      }
    });
  }

  Future<void> _onAnswer(int ans) async {
    if (_isAnswering) return;
    _isAnswering = true;
    _timer?.cancel();

    final bool correct = ans == _q.correctAnswer;

    try {
      await player.stop();
      if (correct) {
        await player.play(AssetSource('sounds/correct.mp3'));
        HapticFeedback.lightImpact();
      } else {
        await player.play(AssetSource('sounds/wrong.mp3'));
        HapticFeedback.vibrate();
      }
    } catch (_) {}

    if (correct) {
      _score += 10;
      if (widget.diff == 'Easy') {
        _coins += 3;
      } else if (widget.diff == 'Medium') {
        _coins += 5;
      } else {
        _coins += 10;
      }
    } else if (ans != -1) {
      _wrongAnswersList.add(
        WrongAnswer(
          question: _q.text,
          correct: _q.correctAnswer,
          userAns: ans,
        ),
      );
    }

    if (mounted) {
      setState(() {
        _flashColor = correct
            ? Colors.green.withOpacity(0.25)
            : Colors.red.withOpacity(0.25);
      });
    }

    await Future.delayed(const Duration(milliseconds: 350));

    if (!mounted) return;

    _currentIndex++;

    if (_currentIndex >= widget.totalQuestions) {
      _finish();
      return;
    }

    setState(() {
      _q = _engine.generate(widget.diff);
      _timeLeft = widget.time;
      _flashColor = Colors.transparent;
      _isAnswering = false;
    });

    _startTimer();
  }

  void _finish() {
    _timer?.cancel();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultPage(
          score: _score,
          wrongs: _wrongAnswersList,
          totalQuestions: widget.totalQuestions,
          coins: _coins,
          difficulty: widget.diff,
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
            '$val',
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
    // Vaqt foizi (progress bar uchun)
    double timePercent = _timeLeft / widget.time;
    Color timerColor = timePercent > 0.5
        ? Colors.cyanAccent
        : timePercent > 0.25
            ? Colors.orangeAccent
            : Colors.redAccent;

    return GradientScaffold(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        color: _flashColor,
        child: SafeArea(
          child: Column(
            children: [
              // --- TOP BAR ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Savol raqami
                    GlassBox(
                      opacity: 0.15,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        child: Text(
                          '${_currentIndex + 1} / ${widget.totalQuestions}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    // Coin counter
                    GlassBox(
                      opacity: 0.15,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.monetization_on, color: Colors.amber, size: 22),
                            const SizedBox(width: 6),
                            Text(
                              '$_coins',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Timer
                    GlassBox(
                      opacity: 0.15,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        child: Text(
                          '00:${_timeLeft.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: timerColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Timer progress bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: timePercent,
                    minHeight: 5,
                    backgroundColor: Colors.white12,
                    valueColor: AlwaysStoppedAnimation<Color>(timerColor),
                  ),
                ),
              ),

              const Spacer(),

              // --- SAVOL ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: GlassBox(
                  opacity: 0.15,
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(minHeight: 140),
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.center,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
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
              ),

              const Spacer(),

              // --- JAVOB TUGMALARI ---
              Padding(
                padding: const EdgeInsets.all(25),
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio: 1.6,
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
