import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DataManager {
  static const _storage = FlutterSecureStorage();

  static const String _coinKey = "user_coins";
  static const String _levelKey = "unlocked_level";
  static const String _totalGamesKey = "total_games";
  static const String _correctAnswersKey = "correct_answers";
  static const String _totalAnswersKey = "total_answers";
  static const String _easyGamesKey = "easy_games";
  static const String _mediumGamesKey = "medium_games";
  static const String _hardGamesKey = "hard_games";
  
  // 🔥 MAVZULAR UCHUN KALITLAR
  static const String _themeKey = "user_theme_index";
  static const String _unlockedThemesKey = "unlocked_themes_list";

  static Future<int> _getInt(String key) async {
    final val = await _storage.read(key: key);
    return int.tryParse(val ?? '0') ?? 0;
  }

  static Future<void> _setInt(String key, int value) async {
    await _storage.write(key: key, value: value.toString());
  }

  // --- TANGA ---
  static Future<void> saveCoins(int count) async {
    int current = await _getInt(_coinKey);
    await _setInt(_coinKey, current + count);
  }

  static Future<bool> useCoins(int amount) async {
    int current = await _getInt(_coinKey);
    if (current >= amount) {
      await _setInt(_coinKey, current - amount);
      return true;
    }
    return false;
  }

  static Future<int> getCoins() async => await _getInt(_coinKey);

  // --- MAVZULAR (THEMES) ---
  
  // Hozirgi tanlangan fon indeksi
  static Future<void> setTheme(int index) async => await _setInt(_themeKey, index);
  static Future<int> getTheme() async => await _getInt(_themeKey);

  // Sotib olingan fonlar ro'yxati (Masalan: "0,1,2")
  static Future<List<int>> getUnlockedThemes() async {
    final val = await _storage.read(key: _unlockedThemesKey);
    if (val == null) return [0]; // Standart fon doim ochiq
    return val.split(',').map((e) => int.parse(e)).toList();
  }

  // Yangi fonni sotib olinganlar ro'yxatiga qo'shish
  static Future<void> unlockTheme(int index) async {
    List<int> unlocked = await getUnlockedThemes();
    if (!unlocked.contains(index)) {
      unlocked.add(index);
      await _storage.write(key: _unlockedThemesKey, value: unlocked.join(','));
    }
  }

  // --- DARAJA ---
  static Future<int> getUnlockedLevel() async => await _getInt(_levelKey);
  static Future<void> setUnlockedLevel(int level) async => await _setInt(_levelKey, level);

  // --- STATISTIKA ---
  static Future<void> saveGameStats({
    required String difficulty,
    required int correct,
    required int total,
  }) async {
    await _setInt(_totalGamesKey, await _getInt(_totalGamesKey) + 1);
    await _setInt(_correctAnswersKey, await _getInt(_correctAnswersKey) + correct);
    await _setInt(_totalAnswersKey, await _getInt(_totalAnswersKey) + total);

    if (difficulty == 'Oson') {
      await _setInt(_easyGamesKey, await _getInt(_easyGamesKey) + 1);
    } else if (difficulty == "O'rta") {
      await _setInt(_mediumGamesKey, await _getInt(_mediumGamesKey) + 1);
    } else {
      await _setInt(_hardGamesKey, await _getInt(_hardGamesKey) + 1);
    }
  }

  static Future<Map<String, dynamic>> getStats() async {
    int totalAnswers = await _getInt(_totalAnswersKey);
    int correctAnswers = await _getInt(_correctAnswersKey);
    return {
      'totalGames': await _getInt(_totalGamesKey),
      'easyGames': await _getInt(_easyGamesKey),
      'mediumGames': await _getInt(_mediumGamesKey),
      'hardGames': await _getInt(_hardGamesKey),
      'accuracy': totalAnswers == 0 ? 0.0 : (correctAnswers / totalAnswers * 100),
    };
  }

  static Future<void> clearStats() async {
    for (final key in [_totalGamesKey, _correctAnswersKey, _totalAnswersKey, _easyGamesKey, _mediumGamesKey, _hardGamesKey]) {
      await _storage.delete(key: key);
    }
  }
}