import 'package:flutter/material.dart';
import 'package:matematik_quiz/class/data_manager.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  Map<String, dynamic> _stats = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final stats = await DataManager.getStats();
    setState(() {
      _stats = stats;
      _loading = false;
    });
  }

  Future<void> _clearStats() async {
    await DataManager.clearStats();
    await _loadStats();
  }

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
        child: SafeArea(
          child: _loading
              ? const Center(child: CircularProgressIndicator(color: Colors.cyanAccent))
              : Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Expanded(
                            child: Text(
                              "STATISTIKA",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 4,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                            onPressed: () => _showClearDialog(),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            // Aniqlik foizi - asosiy karta
                            _accuracyCard(),
                            const SizedBox(height: 20),
                            // Umumiy o'yinlar
                            _statCard(
                              icon: Icons.sports_esports,
                              title: "Umumiy o'yinlar",
                              value: "${_stats['totalGames']}",
                              color: Colors.cyanAccent,
                            ),
                            const SizedBox(height: 12),
                            // Qiyinlik bo'yicha
                            _sectionTitle("Qiyinlik bo'yicha"),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _difficultyCard(
                                    label: "Oson",
                                    value: "${_stats['easyGames']}",
                                    color: Colors.greenAccent,
                                    icon: Icons.sentiment_satisfied_alt,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _difficultyCard(
                                    label: "O'rta",
                                    value: "${_stats['mediumGames']}",
                                    color: Colors.orangeAccent,
                                    icon: Icons.sentiment_neutral,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _difficultyCard(
                                    label: "Qiyin",
                                    value: "${_stats['hardGames']}",
                                    color: Colors.redAccent,
                                    icon: Icons.sentiment_very_dissatisfied,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _accuracyCard() {
    double accuracy = (_stats['accuracy'] as double?) ?? 0.0;
    Color accuracyColor = accuracy >= 70
        ? Colors.greenAccent
        : accuracy >= 40
            ? Colors.orangeAccent
            : Colors.redAccent;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          const Text(
            "Aniqlik",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "${accuracy.toStringAsFixed(1)}%",
            style: TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.w900,
              color: accuracyColor,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: accuracy / 100,
              minHeight: 8,
              backgroundColor: Colors.white10,
              valueColor: AlwaysStoppedAnimation<Color>(accuracyColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _difficultyCard({
    required String label,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white54,
          fontSize: 13,
          letterSpacing: 2,
        ),
      ),
    );
  }

  void _showClearDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF203A43),
        title: const Text("Tozalash", style: TextStyle(color: Colors.white)),
        content: const Text(
          "Barcha statistika o'chiriladi. Davom etasizmi?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Bekor", style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _clearStats();
            },
            child: const Text("O'chirish", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}