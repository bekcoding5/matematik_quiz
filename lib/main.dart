import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matematik_quiz/class/question.dart';
import 'package:matematik_quiz/class/data_manager.dart';
import 'package:matematik_quiz/screens/set_up.dart';
import 'package:matematik_quiz/screens/statistics_screen.dart';
import 'package:matematik_quiz/widgets/glass_box.dart';

// 1. GLOBAL O'ZGARUVCHILAR
final player = AudioPlayer();

class ThemeItem {
  final List<Color> colors;
  final int price;
  final String name;
  ThemeItem({required this.colors, required this.price, required this.name});
}

// 🎨 BOYITILGAN RANGLAR RO'YXATI
final List<ThemeItem> gameThemes = [
  ThemeItem(name: "Okean", price: 0, colors: [const Color(0xFF0F2027), const Color(0xFF203A43), const Color(0xFF2C5364)]),
  ThemeItem(name: "Tungi", price: 500, colors: [const Color(0xFF141E30), const Color(0xFF243B55)]),
  ThemeItem(name: "Binafsha", price: 1000, colors: [const Color(0xFF4A00E0), const Color(0xFF8E2DE2)]),
  ThemeItem(name: "Olov", price: 1500, colors: [const Color(0xFFf12711), const Color(0xFFf5af19)]),
  ThemeItem(name: "Koinot", price: 2000, colors: [const Color(0xFF000428), const Color(0xFF004e92)]),
  ThemeItem(name: "Zümrad", price: 2500, colors: [const Color(0xFF1D976C), const Color(0xFF93F9B9)]),
  ThemeItem(name: "Retro", price: 3000, colors: [const Color(0xFF3D7EAA), const Color(0xFFFFE47A)]),
  ThemeItem(name: "Neon", price: 4000, colors: [const Color(0xFF000000), const Color(0xFF434343)]),
];

ValueNotifier<int> currentThemeIndex = ValueNotifier<int>(0);

class MathEngine {
  final Random _rnd = Random();

  Question generate(String difficulty) {
    int depth;     // Amallar soni
    int maxNum;    // Sonlarning kattaligi
    List<String> ops = ['+', '-'];

    // Darajaga qarab sozlash
    if (difficulty == 'Easy') {
      depth = 1;
      maxNum = 15;
    } else if (difficulty == "Medium") {
      depth = 2;
      maxNum = 30;
      ops.addAll(['*', '/']);
    } else {
      depth = 3;
      maxNum = 50;
      ops.addAll(['*', '/']);
    }

    int result = _rnd.nextInt(maxNum) + 2;
    String expression = "$result";

    for (int i = 0; i < depth; i++) {
      String op = ops[_rnd.nextInt(ops.length)];
      int n = _rnd.nextInt(maxNum) + 2;

      if (op == '+') {
        result += n;
        expression = "($expression + $n)";
      } else if (op == '-') {
        result -= n;
        expression = "($expression - $n)";
      } else if (op == '*') {
        // Ko'paytirishda sonlarni kichraytiramiz, juda katta bo'lib ketmasligi uchun
        int smallN = _rnd.nextInt(10) + 2;
        result *= smallN;
        expression = "($expression * $smallN)";
      } else if (op == '/') {
        // Bo'lishda qoldiqsiz chiqishi uchun natijani ko'paytirib olamiz
        int divisor = _rnd.nextInt(10) + 2;
        int newTotal = result * divisor;
        expression = "($newTotal / $divisor)";
        result = result; // result o'zgarmaydi, chunki (res*div)/div = res
      }
    }

    // Qavslarni tozalash (eng chetki qavslar kerak emas)
    if (expression.startsWith('(') && expression.endsWith(')')) {
      expression = expression.substring(1, expression.length - 1);
    }

    // Variantlarni yasash
    Set<int> opts = {result};
    while (opts.length < 4) {
      int offset = _rnd.nextInt(10) + 1;
      opts.add(result + (_rnd.nextBool() ? offset : -offset));
    }

    return Question(
      text: expression,
      correctAnswer: result,
      options: opts.toList()..shuffle(),
    );
  }
}

// 3. MAIN FUNKSIYASI
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Saqlangan rangni yuklash
  int savedTheme = await DataManager.getTheme();
  currentThemeIndex.value = savedTheme;
  
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(const MathMasterApp());
}

class MathMasterApp extends StatelessWidget {
  const MathMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: currentThemeIndex,
      builder: (context, index, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark(useMaterial3: true),
          home: const MainScreen(),
        );
      },
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: currentThemeIndex,
      builder: (context, themeIndex, _) {
        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gameThemes[themeIndex].colors,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.psychology, size: 100, color: Colors.cyanAccent),
                  const SizedBox(height: 20),
                  const Text("MATH MASTER", style: TextStyle(fontSize: 42, fontWeight: FontWeight.w900, letterSpacing: 4)),
                  const SizedBox(height: 80),
                  
                  // Tugmalar - hammasi audio effekt bilan
                  _actionBtn(context, "START", Icons.play_arrow_rounded, () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const SetupScreen()));
                  }),
                  const SizedBox(height: 20),
                  _actionBtn(context, "STATISTICS", Icons.bar_chart_rounded, () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const StatisticsScreen()));
                  }),
                  const SizedBox(height: 20),
                  _actionBtn(context, "THEME SHOP", Icons.palette_outlined, () {
                    _showThemeShop(context);
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // --- UNIVERSAL ACTION BUTTON (Ovoz va Vibratsiya bilan) ---
  Widget _actionBtn(BuildContext context, String label, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: GestureDetector(
        onTap: () async {
          // Ovoz effekti
          try {
            await player.play(AssetSource('sounds/click.wav'));
          } catch (_) {}
          HapticFeedback.lightImpact(); // Yengil vibratsiya
          onTap();
        },
        child: GlassBox(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.cyanAccent, size: 26),
                const SizedBox(width: 15),
                Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- SHOP MODAL WINDOW ---
  void _showThemeShop(BuildContext context) async {
    List<int> unlocked = await DataManager.getUnlockedThemes();
    int coins = await DataManager.getCoins();

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return GlassBox(
            child: Container(
              padding: const EdgeInsets.all(24),
              height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("THEME SHOP", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.monetization_on, color: Colors.amber, size: 20),
                            const SizedBox(width: 8),
                            Text("$coins", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 18)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white24, height: 40),
                  Expanded(
                    child: ListView.builder(
                      itemCount: gameThemes.length,
                      itemBuilder: (context, i) {
                        bool isUnlocked = unlocked.contains(i);
                        bool isSelected = currentThemeIndex.value == i;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white.withOpacity(0.05) : Colors.transparent,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            leading: Container(
                              width: 45, height: 45,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(colors: gameThemes[i].colors),
                                border: Border.all(color: Colors.white24),
                              ),
                            ),
                            title: Text(gameThemes[i].name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(isUnlocked ? "Unlocked" : "${gameThemes[i].price} coins"),
                            trailing: isSelected 
                              ? const Icon(Icons.check_circle, color: Colors.cyanAccent, size: 30)
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isUnlocked ? Colors.white10 : Colors.cyanAccent.withOpacity(0.2),
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: () async {
                                    if (isUnlocked) {
                                      currentThemeIndex.value = i;
                                      await DataManager.setTheme(i);
                                      Navigator.pop(context);
                                    } else if (coins >= gameThemes[i].price) {
                                      bool success = await DataManager.useCoins(gameThemes[i].price);
                                      if (success) {
                                        await DataManager.unlockTheme(i);
                                        await DataManager.setTheme(i);
                                        currentThemeIndex.value = i;
                                        Navigator.pop(context);
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("Tangalar yetarli emas!")),
                                      );
                                    }
                                  },
                                  child: Text(isUnlocked ? "USE" : "BUY"),
                                ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}