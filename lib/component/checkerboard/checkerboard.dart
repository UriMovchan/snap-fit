import 'package:flutter/material.dart';

class Checkerboard extends StatelessWidget {
  final Widget child;

  const Checkerboard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    Paint lightPaint = Paint()..color = Colors.grey.shade100;
    Paint darkPaint = Paint()..color = Colors.grey.shade200;

    if (Theme.of(context).brightness == Brightness.dark) {
      lightPaint = Paint()..color = const Color.fromRGBO(49, 49, 49, 1);
      darkPaint = Paint()..color = const Color.fromRGBO(55, 55, 55, 1);
    }

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: CustomPaint(
        size: MediaQuery.of(context).size,
        painter: CheckerboardPainter(lightPaint: lightPaint, darkPaint: darkPaint),
        child: child,
      ),
    );
  }
}

class CheckerboardPainter extends CustomPainter {
  final double squareSize = 11.0;
  final Paint lightPaint;
  final Paint darkPaint;

  CheckerboardPainter({required this.lightPaint, required this.darkPaint});

  @override
  void paint(Canvas canvas, Size size) {
    for (double y = 0; y < size.height; y += squareSize) {
      for (double x = 0; x < size.width; x += squareSize) {
        final isEvenRow = (y / squareSize).floor().isEven;
        final isEvenCol = (x / squareSize).floor().isEven;

        final paint = (isEvenRow == isEvenCol) ? lightPaint : darkPaint;

        canvas.drawRect(Rect.fromLTWH(x, y, squareSize, squareSize), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
