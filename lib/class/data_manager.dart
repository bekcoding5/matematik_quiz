import 'package:shared_preferences/shared_preferences.dart';

class DataManager {
  static const String _coinKey = "user_coins";
  static const String _levelKey = "unlocked_level";
  static const String _totalGamesKey = "total_games";
  static const String _correctAnswersKey = "correct_answers";
  static const String _totalAnswersKey = "total_answers";
  static const String _easyGamesKey = "easy_games";
  static const String _mediumGamesKey = "medium_games";
  static const String _hardGamesKey = "hard_games";

  // --- TANGA MANTIQI ---
  static Future<void> saveCoins(int count) async {
    final prefs = await SharedPreferences.getInstance();
    int current = prefs.getInt(_coinKey) ?? 0;
    await prefs.setInt(_coinKey, current + count);
  }

  static Future<bool> useCoins(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    int current = prefs.getInt(_coinKey) ?? 0;
    if (current >= amount) {
      await prefs.setInt(_coinKey, current - amount);
      return true;
    }
    return false;
  }

  static Future<int> getCoins() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_coinKey) ?? 0;
  }

  // --- DARAJA MANTIQI ---
  static Future<int> getUnlockedLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_levelKey) ?? 1;
  }

  static Future<void> setUnlockedLevel(int level) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_levelKey, level);
  }

  // --- STATISTIKA MANTIQI ---
  static Future<void> saveGameStats({
    required String difficulty,
    required int correct,
    required int total,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    int totalGames = (prefs.getInt(_totalGamesKey) ?? 0) + 1;
    int totalCorrect = (prefs.getInt(_correctAnswersKey) ?? 0) + correct;
    int totalAnswers = (prefs.getInt(_totalAnswersKey) ?? 0) + total;

    await prefs.setInt(_totalGamesKey, totalGames);
    await prefs.setInt(_correctAnswersKey, totalCorrect);
    await prefs.setInt(_totalAnswersKey, totalAnswers);

    if (difficulty == 'Oson') {
      await prefs.setInt(_easyGamesKey, (prefs.getInt(_easyGamesKey) ?? 0) + 1);
    } else if (difficulty == "O'rta") {
      await prefs.setInt(_mediumGamesKey, (prefs.getInt(_mediumGamesKey) ?? 0) + 1);
    } else {
      await prefs.setInt(_hardGamesKey, (prefs.getInt(_hardGamesKey) ?? 0) + 1);
    }
  }

  static Future<Map<String, dynamic>> getStats() async {
    final prefs = await SharedPreferences.getInstance();
    int totalAnswers = prefs.getInt(_totalAnswersKey) ?? 0;
    int correctAnswers = prefs.getInt(_correctAnswersKey) ?? 0;

    return {
      'totalGames': prefs.getInt(_totalGamesKey) ?? 0,
      'easyGames': prefs.getInt(_easyGamesKey) ?? 0,
      'mediumGames': prefs.getInt(_mediumGamesKey) ?? 0,
      'hardGames': prefs.getInt(_hardGamesKey) ?? 0,
      'accuracy': totalAnswers == 0
          ? 0.0
          : (correctAnswers / totalAnswers * 100),
    };
  }

  // --- STATISTIKANI TOZALASH ---
  static Future<void> clearStats() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_totalGamesKey);
    await prefs.remove(_correctAnswersKey);
    await prefs.remove(_totalAnswersKey);
    await prefs.remove(_easyGamesKey);
    await prefs.remove(_mediumGamesKey);
    await prefs.remove(_hardGamesKey);
  }
}