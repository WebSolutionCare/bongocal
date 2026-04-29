import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Stylized alpana — concentric petalled mandala drawn in white over the
/// Boishakh red gradient. Pure paint; no rasters required.
class BoishakhIllustration extends StatelessWidget {
  const BoishakhIllustration({super.key, this.size = 220});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _BoishakhPainter()),
    );
  }
}

class _BoishakhPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double r = math.min(size.width, size.height) / 2;
    final Paint stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..color = Colors.white.withValues(alpha: 0.85);

    // Outer guide ring.
    canvas.drawCircle(center, r * 0.95, stroke);

    // 12 petals around the centre.
    const int petalCount = 12;
    for (int i = 0; i < petalCount; i++) {
      final double angle = (math.pi * 2 / petalCount) * i;
      final Offset tip = Offset(
        center.dx + math.cos(angle) * r * 0.8,
        center.dy + math.sin(angle) * r * 0.8,
      );
      final Path petal = Path()
        ..moveTo(center.dx, center.dy)
        ..quadraticBezierTo(
          center.dx + math.cos(angle - 0.18) * r * 0.45,
          center.dy + math.sin(angle - 0.18) * r * 0.45,
          tip.dx,
          tip.dy,
        )
        ..quadraticBezierTo(
          center.dx + math.cos(angle + 0.18) * r * 0.45,
          center.dy + math.sin(angle + 0.18) * r * 0.45,
          center.dx,
          center.dy,
        );
      canvas.drawPath(petal, stroke);
    }

    // Inner solid disc.
    final Paint fill = Paint()..color = Colors.white.withValues(alpha: 0.92);
    canvas.drawCircle(center, r * 0.18, fill);
  }

  @override
  bool shouldRepaint(_BoishakhPainter oldDelegate) => false;
}
