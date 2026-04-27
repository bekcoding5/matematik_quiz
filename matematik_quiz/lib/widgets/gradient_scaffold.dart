import 'package:flutter/material.dart';
import 'package:matematik_quiz/class/theme_item.dart'; // main.dart emas!

class GradientScaffold extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;

  const GradientScaffold({
    super.key,
    required this.child,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: currentThemeIndex,
      builder: (context, themeIndex, _) {
        return Scaffold(
          appBar: appBar,
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
            child: child,
          ),
        );
      },
    );
  }
}