import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:matematik_quiz/class/data_manager.dart';
import 'package:matematik_quiz/class/theme_item.dart';
import 'package:matematik_quiz/screens/home.dart';
import 'package:matematik_quiz/widgets/glass_box.dart';

// Global audio player
final AudioPlayer player = AudioPlayer();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await DataManager.init();
  currentThemeIndex.value = DataManager.getTheme();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  runApp(const MathMasterApp());
}

class MathMasterApp extends StatelessWidget {
  const MathMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const MainScreen(),
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
        return HomeScreen(themeIndex: themeIndex,);
      },
    );
  }
}


// --- THEME SHOP ---
class ThemeShopSheet extends StatefulWidget {
  final int initialCoins;
  final List<int> initialUnlocked;

  const ThemeShopSheet({
    required this.initialCoins,
    required this.initialUnlocked,
  });

  @override
  State<ThemeShopSheet> createState() => ThemeShopSheetState();
}

class ThemeShopSheetState extends State<ThemeShopSheet> {
  late int coins;
  late List<int> unlocked;

  @override
  void initState() {
    super.initState();
    coins = widget.initialCoins;
    unlocked = List.from(widget.initialUnlocked);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: currentThemeIndex,
      builder: (context, selectedIndex, _) {
        return GlassBox(
          opacity: 0.15,
          child: Container(
            padding: const EdgeInsets.all(24),
            height: MediaQuery.of(context).size.height * 0.75,
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white38,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'THEME SHOP',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.amber.withOpacity(0.4),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.monetization_on,
                            color: Colors.amber,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$coins',
                            style: const TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.white24, height: 30),
                Expanded(
                  child: ListView.builder(
                    itemCount: gameThemes.length,
                    itemBuilder: (context, i) {
                      bool isUnlocked = unlocked.contains(i);
                      bool isSelected = selectedIndex == i;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? Colors.white.withOpacity(0.08)
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                          border:
                              isSelected
                                  ? Border.all(
                                    color: Colors.cyanAccent.withOpacity(0.4),
                                  )
                                  : null,
                        ),
                        child: ListTile(
                          leading: Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors:
                                    gameThemes[i].colors.length >= 2
                                        ? [
                                          gameThemes[i].colors.first,
                                          gameThemes[i].colors.last,
                                        ]
                                        : [
                                          gameThemes[i].colors.first,
                                          gameThemes[i].colors.first,
                                        ],
                              ),
                              border: Border.all(color: Colors.white24),
                            ),
                          ),
                          title: Text(
                            gameThemes[i].name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            isUnlocked
                                ? 'Unlocked'
                                : '${gameThemes[i].price} coins',
                            style: TextStyle(
                              color:
                                  isUnlocked
                                      ? Colors.greenAccent
                                      : Colors.white54,
                            ),
                          ),
                          trailing:
                              isSelected
                                  ? const Icon(
                                    Icons.check_circle,
                                    color: Colors.cyanAccent,
                                    size: 30,
                                  )
                                  : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          isUnlocked
                                              ? Colors.cyanAccent.withOpacity(
                                                0.2,
                                              )
                                              : Colors.white10,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (isUnlocked) {
                                        currentThemeIndex.value = i;
                                        await DataManager.setTheme(i);
                                        if (context.mounted)
                                          Navigator.pop(context);
                                      } else if (coins >= gameThemes[i].price) {
                                        bool success =
                                            await DataManager.useCoins(
                                              gameThemes[i].price,
                                            );
                                        if (success) {
                                          await DataManager.unlockTheme(i);
                                          await DataManager.setTheme(i);
                                          currentThemeIndex.value = i;
                                          setState(() {
                                            coins -= gameThemes[i].price;
                                            unlocked.add(i);
                                          });
                                          if (context.mounted)
                                            Navigator.pop(context);
                                        }
                                      } else {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Tangalar yetarli emas!',
                                              ),
                                              backgroundColor: Colors.redAccent,
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    child: Text(isUnlocked ? 'USE' : 'BUY'),
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
    );
  }
}
