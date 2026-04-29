import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Crescent moon plus a sprinkle of stars — drawn in soft gold over the
/// emerald Eid gradient.
class EidIllustration extends StatelessWidget {
  const EidIllustration({super.key, this.size = 220});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _EidPainter()),
    );
  }
}

class _EidPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double r = math.min(size.width, size.height) / 2;
    final Paint moon = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFD4AF37);
    final Paint cutout = Paint()
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut
      ..color = Colors.black;

    canvas.saveLayer(Offset.zero & size, Paint());
    canvas.drawCircle(center, r * 0.55, moon);
    canvas.drawCircle(
      Offset(center.dx + r * 0.18, center.dy - r * 0.05),
      r * 0.5,
      cutout,
    );
    canvas.restore();

    // Stars.
    final List<Offset> stars = <Offset>[
      Offset(center.dx - r * 0.7, center.dy - r * 0.55),
      Offset(center.dx + r * 0.55, center.dy - r * 0.7),
      Offset(center.dx + r * 0.78, center.dy + r * 0.32),
      Offset(center.dx - r * 0.62, center.dy + r * 0.6),
    ];
    final Paint star = Paint()
      ..color = Colors.white.withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;
    for (final Offset s in stars) {
      canvas.drawCircle(s, 3, star);
    }
  }

  @override
  bool shouldRepaint(_EidPainter oldDelegate) => false;
}
