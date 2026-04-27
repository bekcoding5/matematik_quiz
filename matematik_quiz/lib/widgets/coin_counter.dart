import 'package:flutter/material.dart';

class CoinCounter extends StatelessWidget {
  final int coins;
  const CoinCounter({super.key, required this.coins});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.monetization_on, color: Colors.amber),
        const SizedBox(width: 5),
        Text(
          "$coins",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}