import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:matematik_quiz/class/question.dart';
import 'package:matematik_quiz/class/stats_printer.dart';
import 'package:matematik_quiz/main.dart';
import 'package:matematik_quiz/widgets/glass_box.dart';

class ResultPage extends StatelessWidget {
  final int score;
  final List<WrongAnswer> wrongs;
  final int totalQuestions;

  const ResultPage({
    super.key,
    required this.score,
    required this.wrongs,
    required this.totalQuestions,
  });

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
                "XATOLAR TAHLILI",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                ),
              ),
              const Divider(color: Colors.white24),
              Expanded(
                child: ListView.builder(
                  itemCount: wrongs.length,
                  itemBuilder: (context, i) => ListTile(
                    title: Text(
                      wrongs[i].question,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "Siz: ${wrongs[i].userAns} | To'g'ri: ${wrongs[i].correct}",
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
    int correctCount = totalQuestions - wrongs.length;
    double successPercent = totalQuestions > 0
        ? (correctCount / totalQuestions) * 100
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
                    "O'YIN YAKUNLANDI",
                    style: TextStyle(
                      letterSpacing: 2,
                      fontSize: 14,
                      color: Colors.white60,
                    ),
                  ),
                  const SizedBox(height: 25),

                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 140,
                        height: 140,
                        child: CustomPaint(
                          painter: StatsPainter(successPercent),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            "${successPercent.toInt()}%",
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            "To'g'ri",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.cyanAccent,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                  Text(
                    "$score",
                    style: const TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyanAccent,
                    ),
                  ),
                  const Text(
                    "UMUMIY BALL",
                    style: TextStyle(letterSpacing: 2, fontSize: 12),
                  ),

                  const SizedBox(height: 30),
                  if (wrongs.isNotEmpty)
                    TextButton.icon(
                      onPressed: () => _showWrongs(context),
                      icon: const Icon(
                        Icons.list_alt,
                        color: Colors.cyanAccent,
                      ),
                      label: const Text(
                        "XATOLARNI KO'RISH",
                        style: TextStyle(color: Colors.cyanAccent),
                      ),
                    ),

                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyanAccent,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () async {
                        await player.play(AssetSource('sounds/click.wav'));
                        Navigator.popUntil(context, (r) => r.isFirst);
                      },

                      child: const Text(
                        "ASOSIY MENYU",
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
