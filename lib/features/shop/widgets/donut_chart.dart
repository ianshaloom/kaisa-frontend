import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../shared/shared_models.dart';
import '../../../theme/text_scheme.dart';

class AnimatedPieChart extends StatelessWidget {
  final double? pieRadius;
  final double? stokeWidth;
  final double? padding;
  final int? animatedSpeed;
  final int totalSales;
  final List<DonutData> segments;

  const AnimatedPieChart({
    super.key,
    this.pieRadius = 60.0,
    this.stokeWidth = 8.0,
    this.padding = 3.0,
    this.animatedSpeed = 800,
    required this.totalSales,
    required this.segments,
  });

  @override
  Widget build(BuildContext context) {
    // print('pieData: $pieData');
    final textTheme = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
      child: Center(
        child: Stack(
          children: [
            AnimatedRotation(
              duration: Duration(milliseconds: animatedSpeed!),
              turns: 0.43,
              child: PieChart(
                data: segments,
                radius: pieRadius!,
                padding: padding!,
                strokeWidth: stokeWidth!,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 0,
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /* Text('Your Savings', style: bodyMedium(textTheme)),
                    const SizedBox(height: 10), */
                    Text(
                      NumberFormat('00').format(totalSales),
                      style: bodyBold(textTheme).copyWith(
                        fontSize: 25,
                        color: color.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// our pie chart widget
class PieChart extends StatelessWidget {
  PieChart({
    required this.data,
    required this.radius,
    this.strokeWidth = 8,
    this.padding = 3,
    this.child,
    super.key,
  }) : // make sure sum of data is never ovr 100 percent
        assert(data.fold<double>(0, (sum, data) => sum + data.percent) <= 100);

  final List<DonutData> data;

  // radius of chart
  final double radius;

  // width of stroke
  final double strokeWidth;

  final double padding;

  // optional child; can be used for text for example
  final Widget? child;

  @override
  Widget build(context) {
    return CustomPaint(
      painter: _Painter(strokeWidth, data, padding),
      size: Size.square(radius),
      child: SizedBox.square(
        // calc diameter
        dimension: radius * 2.5,
        child: Center(
          child: child,
        ),
      ),
    );
  }
}

// responsible for painting our chart
class _PainterData {
  _PainterData(this.paint, this.radians);

  final Paint paint;
  final double radians;
}

class _Painter extends CustomPainter {
  _Painter(double strokeWidth, List<DonutData> data, double padding) {
    // convert chart data to painter data
    dataList = data
        .map((e) => _PainterData(
              Paint()
                ..color = e.color
                ..style = PaintingStyle.stroke
                ..strokeWidth = strokeWidth
                ..strokeCap = StrokeCap.round,
              // remove padding from stroke
              (e.percent - padding) * _percentInRadians,
            ))
        .toList();
    paddingInRadians = _percentInRadians * padding;
    startAngle = -1.570796 + paddingInRadians / 2;
  }

  static const _percentInRadians = 0.062831853071796;

  late final List<_PainterData> dataList;
  late final double paddingInRadians;
  late final double startAngle;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    // keep track of start angle for next stroke
    double currentAngle = startAngle;

    // draw each stroke
    for (final data in dataList) {
      final path = Path()..addArc(rect, currentAngle, data.radians);

      currentAngle += data.radians + paddingInRadians;

      canvas.drawPath(path, data.paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
