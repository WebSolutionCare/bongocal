import 'package:flutter/material.dart';

import '../../../../../shared/theme/theme.dart';

/// A subtly waving Bangladesh flag — green field with the off-centre red
/// disc. Used for Independence + Victory days.
class BdFlagIllustration extends StatelessWidget {
  const BdFlagIllustration({super.key, this.size = 220});

  final double size;

  @override
  Widget build(BuildContext context) {
    final double width = size;
    final double height = size * 0.6;
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          children: <Widget>[
            const ColoredBox(color: AppColors.brandEmerald),
            Positioned.fill(
              child: CustomPaint(painter: _FlagShadingPainter()),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(right: width * 0.08),
                child: Container(
                  width: height * 0.55,
                  height: height * 0.55,
                  decoration: const BoxDecoration(
                    color: AppColors.accentRed,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FlagShadingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Soft diagonal highlight to imply fabric folds.
    final Paint highlight = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          Color(0x33FFFFFF),
          Color(0x00FFFFFF),
          Color(0x33000000),
        ],
        stops: <double>[0.0, 0.5, 1.0],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, highlight);
  }

  @override
  bool shouldRepaint(_FlagShadingPainter oldDelegate) => false;
}
