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
  final int coins; // Bu yerda qiymat GameScreen'dan keladi

  const ResultPage({
    super.key,
    required this.score,
    required this.wrongs,
    required this.totalQuestions,
    required this.coins, // 'required' qilish xatolikni oldini oladi
  });

  // Xatolarni ko'rsatish funksiyasi (O'zgarishsiz qoldi)
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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.cyanAccent),
              ),
              const Divider(color: Colors.white24),
              Expanded(
                child: ListView.builder(
                  itemCount: wrongs.length,
                  itemBuilder: (context, i) => ListTile(
                    title: Text(wrongs[i].question, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    subtitle: Text("Siz: ${wrongs[i].userAns} | To'g'ri: ${wrongs[i].correct}", style: const TextStyle(color: Colors.redAccent)),
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
    double successPercent = totalQuestions > 0 ? (correctCount / totalQuestions) * 100 : 0;

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
                  const Text("O'YIN YAKUNLANDI", style: TextStyle(letterSpacing: 2, fontSize: 14, color: Colors.white60)),
                  const SizedBox(height: 25),

                  // Foizli aylana (Stats)
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: CustomPaint(painter: StatsPainter(successPercent)),
                      ),
                      Text("${successPercent.toInt()}%", style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),

                  const SizedBox(height: 20),
                  
                  // Score (Ball)
                  Text("$score", style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.cyanAccent)),
                  const Text("UMUMIY BALL", style: TextStyle(letterSpacing: 2, fontSize: 10, color: Colors.white70)),

                  const SizedBox(height: 20),

                  // --- COINLAR EKRANI ---
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.amber.withOpacity(0.5)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.monetization_on, color: Colors.amber, size: 28),
                        const SizedBox(width: 10),
                        Text(
                          "+$coins COIN",
                          style: const TextStyle(fontSize: 22, color: Colors.amber, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Tugmalar
                  if (wrongs.isNotEmpty)
                    TextButton.icon(
                      onPressed: () => _showWrongs(context),
                      icon: const Icon(Icons.list_alt, color: Colors.cyanAccent),
                      label: const Text("XATOLARNI KO'RISH", style: TextStyle(color: Colors.cyanAccent)),
                    ),

                  const SizedBox(height: 15),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyanAccent,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      onPressed: () async {
                        await player.play(AssetSource('sounds/click.wav'));
                        Navigator.popUntil(context, (r) => r.isFirst);
                      },
                      child: const Text("ASOSIY MENYU", style: TextStyle(fontWeight: FontWeight.bold)),
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