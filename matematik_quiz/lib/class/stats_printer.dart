import 'package:flutter/material.dart';

class StatsPainter extends CustomPainter {
  final double percent;
  StatsPainter(this.percent);

  @override
  void paint(Canvas canvas, Size size) {
    Paint bgPaint = Paint()
      ..color = Colors.white10
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;

    Paint progressPaint = Paint()
      ..color = Colors.cyanAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2, bgPaint);
    double sweepAngle = 2 * 3.1415926535 * (percent / 100);
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      -3.1415 / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}