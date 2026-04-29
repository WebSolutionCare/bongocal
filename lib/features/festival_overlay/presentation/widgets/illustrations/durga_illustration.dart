import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Saffron geometric mandala — eight-pointed star + concentric rings.
/// Used for Durga Puja.
class DurgaIllustration extends StatelessWidget {
  const DurgaIllustration({super.key, this.size = 220});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _DurgaPainter()),
    );
  }
}

class _DurgaPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double r = math.min(size.width, size.height) / 2;
    final Paint stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..color = Colors.white.withValues(alpha: 0.85);
    canvas.drawCircle(center, r * 0.92, stroke);
    canvas.drawCircle(center, r * 0.62, stroke);
    canvas.drawCircle(center, r * 0.32, stroke);

    // Eight-pointed star.
    final Paint fill = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white.withValues(alpha: 0.9);
    final Path star = Path();
    const int points = 8;
    for (int i = 0; i < points * 2; i++) {
      final double angle = (math.pi / points) * i - math.pi / 2;
      final double radius = i.isEven ? r * 0.55 : r * 0.22;
      final double x = center.dx + math.cos(angle) * radius;
      final double y = center.dy + math.sin(angle) * radius;
      if (i == 0) {
        star.moveTo(x, y);
      } else {
        star.lineTo(x, y);
      }
    }
    star.close();
    canvas.drawPath(star, fill);
  }

  @override
  bool shouldRepaint(_DurgaPainter oldDelegate) => false;
}
