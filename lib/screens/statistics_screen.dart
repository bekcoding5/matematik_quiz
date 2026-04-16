import 'package:flutter/material.dart';
import 'package:matematik_quiz/class/data_manager.dart';
import 'package:matematik_quiz/widgets/gradient_scaffold.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late Map<String, dynamic> _stats;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  void _loadStats() {
    setState(() {
      _stats = DataManager.getStats();
    });
  }

  Future<void> _clearStats() async {
    await DataManager.clearStats();
    _loadStats();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        title: const Text(
          'STATISTICS',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            letterSpacing: 4,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: _showClearDialog,
          ),
        ],
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _accuracyCard(),
              const SizedBox(height: 16),
              _statCard(
                icon: Icons.sports_esports,
                title: 'Total games',
                value: '${_stats['totalGames']}',
                color: Colors.cyanAccent,
              ),
              const SizedBox(height: 16),
              _sectionTitle('BY DIFFICULTY'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _difficultyCard(
                      label: 'Easy',
                      value: '${_stats['easyGames']}',
                      color: Colors.greenAccent,
                      icon: Icons.sentiment_satisfied_alt,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _difficultyCard(
                      label: 'Medium',
                      value: '${_stats['mediumGames']}',
                      color: Colors.orangeAccent,
                      icon: Icons.sentiment_neutral,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _difficultyCard(
                      label: 'Hard',
                      value: '${_stats['hardGames']}',
                      color: Colors.redAccent,
                      icon: Icons.sentiment_very_dissatisfied,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _accuracyCard() {
    final double accuracy = (_stats['accuracy'] as double?) ?? 0.0;
    final Color accuracyColor = accuracy >= 70
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
            'ACCURACY',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${accuracy.toStringAsFixed(1)}%',
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
          color: Colors.white38,
          fontSize: 12,
          letterSpacing: 3,
        ),
      ),
    );
  }

  void _showClearDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF203A43),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Clear statistics',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'All statistics will be deleted. Do you want to continue?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _clearStats();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}
