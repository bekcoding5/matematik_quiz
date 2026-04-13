import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:matematik_quiz/main.dart';
import 'package:matematik_quiz/class/question.dart';
import 'package:matematik_quiz/class/data_manager.dart';
import 'package:matematik_quiz/widgets/glass_box.dart';

class ResultPage extends StatefulWidget {
  final int score;
  final List<WrongAnswer> wrongs;
  final int totalQuestions;
  final int coins;
  final String difficulty;

  const ResultPage({
    super.key,
    required this.score,
    required this.wrongs,
    required this.totalQuestions,
    required this.coins,
    required this.difficulty,
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  void initState() {
    super.initState();
    _saveStats();
  }

  Future<void> _saveStats() async {
    int correctCount = widget.totalQuestions - widget.wrongs.length;
    await DataManager.saveGameStats(
      difficulty: widget.difficulty,
      correct: correctCount,
      total: widget.totalQuestions,
    );
    await DataManager.saveCoins(widget.coins);
  }

  void _showWrongs(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => GlassBox(
        opacity: 0.2,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                "ERROR ANALYSIS",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                ),
              ),
              const Divider(color: Colors.white24),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.wrongs.length,
                  itemBuilder: (context, i) => ListTile(
                    title: Text(
                      widget.wrongs[i].question,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      "You: ${widget.wrongs[i].userAns} | Correct: ${widget.wrongs[i].correct}",
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                    leading: const Icon(Icons.close, color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int correctCount = widget.totalQuestions - widget.wrongs.length;
    double successPercent = widget.totalQuestions > 0
        ? (correctCount / widget.totalQuestions) * 100
        : 0;

    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: GlassBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "GAME OVER",
                    style: TextStyle(
                        letterSpacing: 2,
                        fontSize: 14,
                        color: Colors.white60),
                  ),
                  const SizedBox(height: 25),
                  Column(
                    children: [
                      Text(
                        "${successPercent.toInt()}%",
                        style: const TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        "DEGREE OF ACCURACY",
                        style: TextStyle(
                            letterSpacing: 2,
                            fontSize: 10,
                            color: Colors.white70),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Text(
                    "${widget.score}",
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyanAccent,
                    ),
                  ),
                  const Text(
                    "TOTAL SCORE",
                    style: TextStyle(
                        letterSpacing: 2,
                        fontSize: 10,
                        color: Colors.white70),
                  ),
                  const SizedBox(height: 25),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: Colors.amber.withOpacity(0.5)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.monetization_on,
                            color: Colors.amber, size: 28),
                        const SizedBox(width: 10),
                        Text(
                          "+${widget.coins} COIN",
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (widget.wrongs.isNotEmpty)
                    TextButton.icon(
                      onPressed: () => _showWrongs(context),
                      icon: const Icon(Icons.list_alt,
                          color: Colors.cyanAccent),
                      label: const Text(
                        "VIEW ERRORS",
                        style: TextStyle(color: Colors.cyanAccent),
                      ),
                    ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyanAccent,
                        foregroundColor: Colors.black,
                        padding:
                            const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () async {
                        await player
                            .play(AssetSource('sounds/click.wav'));
                        Navigator.popUntil(
                            context, (r) => r.isFirst);
                      },
                      child: const Text(
                        "MAIN MENU",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}