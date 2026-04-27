import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:matematik_quiz/class/data_manager.dart';
import 'package:matematik_quiz/class/question.dart';
import 'package:matematik_quiz/main.dart';
import 'package:matematik_quiz/widgets/glass_box.dart';
import 'package:matematik_quiz/widgets/gradient_scaffold.dart';

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
  bool _statsSaved = false;

  @override
  void initState() {
    super.initState();
    _saveStats();
  }

  Future<void> _saveStats() async {
    if (_statsSaved) return;
    _statsSaved = true;
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
      isScrollControlled: true,
      builder: (_) => GlassBox(
        opacity: 0.2,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white38,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Text(
                'ERROR ANALYSIS',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                  letterSpacing: 2,
                ),
              ),
              const Divider(color: Colors.white24, height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.wrongs.length,
                  itemBuilder: (context, i) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.close, color: Colors.redAccent, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.wrongs[i].question,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'You: ${widget.wrongs[i].userAns}   |   Correct: ${widget.wrongs[i].correct}',
                                style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
    final int correctCount = widget.totalQuestions - widget.wrongs.length;
    final double successPercent = widget.totalQuestions > 0
        ? (correctCount / widget.totalQuestions) * 100
        : 0;

    final Color accuracyColor = successPercent >= 70
        ? Colors.greenAccent
        : successPercent >= 40
            ? Colors.orangeAccent
            : Colors.redAccent;

    final String resultEmoji = successPercent >= 80
        ? '🏆'
        : successPercent >= 50
            ? '👍'
            : '💪';

    return GradientScaffold(
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: GlassBox(
              opacity: 0.12,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      resultEmoji,
                      style: const TextStyle(fontSize: 60),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'GAME OVER',
                      style: TextStyle(
                        letterSpacing: 3,
                        fontSize: 14,
                        color: Colors.white60,
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Aniqlik
                    Text(
                      '${successPercent.toInt()}%',
                      style: TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.w900,
                        color: accuracyColor,
                      ),
                    ),
                    const Text(
                      'ACCURACY',
                      style: TextStyle(
                        letterSpacing: 3,
                        fontSize: 11,
                        color: Colors.white54,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: successPercent / 100,
                        minHeight: 6,
                        backgroundColor: Colors.white10,
                        valueColor: AlwaysStoppedAnimation<Color>(accuracyColor),
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Score
                    Text(
                      '${widget.score}',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: Colors.cyanAccent,
                      ),
                    ),
                    const Text(
                      'TOTAL SCORE',
                      style: TextStyle(
                        letterSpacing: 3,
                        fontSize: 11,
                        color: Colors.white54,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // To'g'ri / Noto'g'ri
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _statChip(
                          '${correctCount}✓',
                          Colors.greenAccent,
                        ),
                        const SizedBox(width: 12),
                        _statChip(
                          '${widget.wrongs.length}✗',
                          Colors.redAccent,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Coin
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
                            '+${widget.coins} COINS',
                            style: const TextStyle(
                              fontSize: 22,
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Xatolar tugmasi
                    if (widget.wrongs.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TextButton.icon(
                          onPressed: () => _showWrongs(context),
                          icon: const Icon(Icons.list_alt,
                              color: Colors.cyanAccent),
                          label: const Text(
                            'VIEW ERRORS',
                            style: TextStyle(color: Colors.cyanAccent),
                          ),
                        ),
                      ),

                    // Bosh menu tugmasi
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyanAccent,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () async {
                          try {
                            await player.play(AssetSource('sounds/click.wav'));
                          } catch (_) {}
                          if (!context.mounted) return;
                          Navigator.popUntil(context, (r) => r.isFirst);
                        },
                        child: const Text(
                          'MAIN MENU',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _statChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
