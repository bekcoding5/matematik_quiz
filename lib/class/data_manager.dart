import 'package:hive_flutter/hive_flutter.dart';

class DataManager {
  static const String _boxName = 'math_master_box';
  static const String _coinKey = 'user_coins';
  static const String _levelKey = 'unlocked_level';
  static const String _totalGamesKey = 'total_games';
  static const String _correctAnswersKey = 'correct_answers';
  static const String _totalAnswersKey = 'total_answers';
  static const String _easyGamesKey = 'easy_games';
  static const String _mediumGamesKey = 'medium_games';
  static const String _hardGamesKey = 'hard_games';
  static const String _themeKey = 'selected_theme';
  static const String _unlockedThemesKey = 'unlocked_themes';

  static Box? _box;

  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);
  }

  static Box get box {
    if (_box == null || !_box!.isOpen) {
      throw Exception('DataManager not initialized. Call DataManager.init() first.');
    }
    return _box!;
  }

  static int _getInt(String key) {
    return box.get(key, defaultValue: 0) as int;
  }

  static Future<void> _setInt(String key, int value) async {
    await box.put(key, value);
  }

  // --- TANGA ---
  static Future<void> saveCoins(int count) async {
    int current = _getInt(_coinKey);
    await _setInt(_coinKey, current + count);
  }

  static Future<bool> useCoins(int amount) async {
    int current = _getInt(_coinKey);
    if (current >= amount) {
      await _setInt(_coinKey, current - amount);
      return true;
    }
    return false;
  }

  static int getCoins() => _getInt(_coinKey);

  // --- DARAJA ---
  static int getUnlockedLevel() => _getInt(_levelKey);

  static Future<void> setUnlockedLevel(int level) async =>
      await _setInt(_levelKey, level);

  // --- TEMA ---
  static int getTheme() => _getInt(_themeKey);

  static Future<void> setTheme(int index) async =>
      await _setInt(_themeKey, index);

  static List<int> getUnlockedThemes() {
    final val = box.get(_unlockedThemesKey, defaultValue: '0') as String;
    if (val.isEmpty) return [0];
    return val.split(',').map((e) => int.tryParse(e) ?? 0).toList();
  }

  static Future<void> unlockTheme(int index) async {
    List<int> current = getUnlockedThemes();
    if (!current.contains(index)) {
      current.add(index);
      await box.put(_unlockedThemesKey, current.join(','));
    }
  }

  // --- STATISTIKA ---
  static Future<void> saveGameStats({
    required String difficulty,
    required int correct,
    required int total,
  }) async {
    await _setInt(_totalGamesKey, _getInt(_totalGamesKey) + 1);
    await _setInt(_correctAnswersKey, _getInt(_correctAnswersKey) + correct);
    await _setInt(_totalAnswersKey, _getInt(_totalAnswersKey) + total);

    if (difficulty == 'Easy') {
      await _setInt(_easyGamesKey, _getInt(_easyGamesKey) + 1);
    } else if (difficulty == 'Medium') {
      await _setInt(_mediumGamesKey, _getInt(_mediumGamesKey) + 1);
    } else if (difficulty == 'Hard') {
      await _setInt(_hardGamesKey, _getInt(_hardGamesKey) + 1);
    }
  }

  static Map<String, dynamic> getStats() {
    int totalAnswers = _getInt(_totalAnswersKey);
    int correctAnswers = _getInt(_correctAnswersKey);
    return {
      'totalGames': _getInt(_totalGamesKey),
      'easyGames': _getInt(_easyGamesKey),
      'mediumGames': _getInt(_mediumGamesKey),
      'hardGames': _getInt(_hardGamesKey),
      'accuracy': totalAnswers == 0
          ? 0.0
          : (correctAnswers / totalAnswers * 100),
    };
  }

  static Future<void> clearStats() async {
    for (final key in [
      _totalGamesKey,
      _correctAnswersKey,
      _totalAnswersKey,
      _easyGamesKey,
      _mediumGamesKey,
      _hardGamesKey,
    ]) {
      await box.delete(key);
    }
  }
}