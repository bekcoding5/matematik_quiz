import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:matematik_quiz/main.dart';
import 'package:matematik_quiz/screens/game.dart';
import 'package:matematik_quiz/widgets/glass_box.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});
  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  String _diff = 'O‘rta';
  int _time = 30;
  int _count = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      appBar: AppBar(
        title: const Text("SOZLAMALAR"),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            _optionTile(
              "QIYINLIK",
              ['Oson', 'O‘rta', 'Qiyin'],
              _diff,
              (v) => setState(() => _diff = v),
            ),
            const SizedBox(height: 15),
            _optionTile(
              "VAQT (sekund)",
              [15, 30, 45],
              _time,
              (v) => setState(() => _time = v),
            ),
            const SizedBox(height: 15),
            _optionTile(
              "SAVOLLAR SONI",
              [5, 10, 20],
              _count,
              (v) => setState(() => _count = v),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 65,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyanAccent,
                  foregroundColor: Colors.black,
                ),
                onPressed: () async {
                  await player.play(AssetSource('sounds/click.wav'));
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
                child: const Text(
                  "O'YINNI BOSHLASH",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _optionTile(
    String title,
    List opts,
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
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: opts
                  .map(
                    (o) => ChoiceChip(
                      label: Text("$o"),
                      selected: curr == o,
                      onSelected: (_) => onS(o),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
