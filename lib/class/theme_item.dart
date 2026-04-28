import 'package:flutter/material.dart';

class ThemeItem {
  final List<Color> colors;
  final int price;
  final String name;

  ThemeItem({required this.colors, required this.price, required this.name});
}

final List<ThemeItem> gameThemes = [
  ThemeItem(
    name: "Deep Ocean",
    price: 0,
    colors: [
      const Color(0xFF0F2027),
      const Color(0xFF203A43),
      const Color(0xFF2C5364),
    ],
  ),
  ThemeItem(
    name: "Midnight",
    price: 250,
    colors: [const Color(0xFF141E30), const Color(0xFF243B55)],
  ),
  ThemeItem(
    name: "Minimalist",
    price: 500,
    colors: [const Color(0xFF000000), const Color(0xFF434343)],
  ),

  ThemeItem(
    name: "Royal Purple", // Qirollik binafsharang gammasi
    price: 1000,
    colors: [const Color(0xFF4A00E0), const Color(0xFF8E2DE2)],
  ),
  ThemeItem(
    name: "Lava", // Issiq olov va lava effekti
    price: 1500,
    colors: [const Color(0xFFe9d022), const Color(0xFFe60b09)],
  ),

  ThemeItem(
    name: "Cyber Neon", // Futuristik neon kombinatsiyasi
    price: 2000,
    colors: [const Color(0xFF00ee6e), const Color(0xFF0c75e6)],
  ),
  ThemeItem(
    name: "Toxic Green", // Yorqin zaharli yashil va qora
    price: 2500,
    colors: [const Color(0xFF0c0c0c), const Color(0xFF0f971c)],
  ),
  ThemeItem(
    name: "Cosmic Blue", // Koinotning chuqur ko'k rangi
    price: 3000,
    colors: [const Color(0xFF000428), const Color(0xFF004e92)],
  ),
  ThemeItem(
    name: "Dark Crimson", // Qora va qizilning agressiv uyg'unligi
    price: 4000,
    colors: [const Color(0xFFe65763), const Color(0xFF080808)],
  ),
];

// Global theme notifier
ValueNotifier<int> currentThemeIndex = ValueNotifier<int>(0);
