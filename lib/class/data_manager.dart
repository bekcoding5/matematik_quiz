import 'package:shared_preferences/shared_preferences.dart';

class DataManager {
  static const String _coinKey = "user_coins";
  static const String _levelKey = "unlocked_level"; // Darajalar uchun kalit

  // --- TANGA MANTIQI ---

  // Tangani qo'shish (O'yin tugaganda chaqiriladi)
  static Future<void> saveCoins(int count) async {
    final prefs = await SharedPreferences.getInstance();
    int current = prefs.getInt(_coinKey) ?? 0;
    await prefs.setInt(_coinKey, current + count);
  }

  // Tangani ishlatish (Sotib olayotganda chaqiriladi)
  static Future<bool> useCoins(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    int current = prefs.getInt(_coinKey) ?? 0;
    if (current >= amount) {
      await prefs.setInt(_coinKey, current - amount);
      return true; // Pul yechildi
    }
    return false; // Pul yetmadi
  }

  // Hozirgi tangalarni ko'rish
  static Future<int> getCoins() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_coinKey) ?? 0;
  }

  // --- DARAJA (LEVEL) MANTIQI ---

  // Qaysi darajagacha ochiqligini aniqlash (1: Oson, 2: O'rta, 3: Qiyin)
  static Future<int> getUnlockedLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_levelKey) ?? 1; // Standartda faqat 1-daraja ochiq
  }

  // Yangi darajani sotib olganda xotiraga saqlash
  static Future<void> setUnlockedLevel(int level) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_levelKey, level);
  }
}