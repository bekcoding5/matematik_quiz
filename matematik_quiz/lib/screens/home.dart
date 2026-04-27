import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matematik_quiz/class/data_manager.dart';
import 'package:matematik_quiz/class/theme_item.dart';
import 'package:matematik_quiz/main.dart';
import 'package:matematik_quiz/screens/set_up.dart';
import 'package:matematik_quiz/screens/statistics_screen.dart';
import 'package:matematik_quiz/widgets/glass_box.dart';
import 'package:matematik_quiz/widgets/new.dart';

class HomeScreen extends StatefulWidget {
  final int themeIndex;
  const HomeScreen({super.key, required this.themeIndex});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget _actionBtn(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: GestureDetector(
        onTap: () async {
          try {
            await player.play(AssetSource('sounds/click.wav'));
          } catch (_) {}
          HapticFeedback.lightImpact();
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
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showThemeShop(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => ThemeShopSheet(
            initialCoins: DataManager.getCoins(),
            initialUnlocked: DataManager.getUnlockedThemes(),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gameThemes[widget.themeIndex].colors,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  const Icon(
                    Icons.psychology,
                    size: 100,
                    color: Colors.cyanAccent,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'MATH MASTER',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 80),
                  _actionBtn(context, 'START', Icons.play_arrow_rounded, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SetupScreen()),
                    );
                  }),
                  const SizedBox(height: 20),
                  _actionBtn(
                    context,
                    'STATISTICS',
                    Icons.bar_chart_rounded,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const StatisticsScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  _actionBtn(context, 'THEME SHOP', Icons.palette_outlined, () {
                    _showThemeShop(context);
                  }),
                  const SizedBox(height: 40),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: MyNewWidget(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
