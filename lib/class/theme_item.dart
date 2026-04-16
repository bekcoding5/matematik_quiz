import 'package:flutter/material.dart';

class ThemeItem {
  final List<Color> colors;
  final int price;
  final String name;

  ThemeItem({required this.colors, required this.price, required this.name});
}

final List<ThemeItem> gameThemes = [
  ThemeItem(
    name: "Okean",
    price: 0,
    colors: [const Color(0xFF0F2027), const Color(0xFF203A43), const Color(0xFF2C5364)],
  ),
  ThemeItem(
    name: "Tungi",
    price: 500,
    colors: [const Color(0xFF141E30), const Color(0xFF243B55)],
  ),
  ThemeItem(
    name: "Binafsha",
    price: 1000,
    colors: [const Color(0xFF4A00E0), const Color(0xFF8E2DE2)],
  ),
  ThemeItem(
    name: "Olov",
    price: 1500,
    colors: [const Color(0xFFf12711), const Color(0xFFf5af19)],
  ),
  ThemeItem(
    name: "Koinot",
    price: 2000,
    colors: [const Color(0xFF000428), const Color(0xFF004e92)],
  ),
  ThemeItem(
    name: "Zümrad",
    price: 2500,
    colors: [const Color(0xFF1D976C), const Color(0xFF93F9B9)],
  ),
  ThemeItem(
    name: "Retro",
    price: 3000,
    colors: [const Color(0xFF3D7EAA), const Color(0xFFFFE47A)],
  ),
  ThemeItem(
    name: "Neon",
    price: 4000,
    colors: [const Color(0xFF000000), const Color(0xFF434343)],
  ),
];

// Global theme notifier - barcha fayllardan shu yerdan import qilinadi
ValueNotifier<int> currentThemeIndex = ValueNotifier<int>(0);