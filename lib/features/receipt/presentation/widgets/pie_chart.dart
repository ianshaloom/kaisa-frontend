// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


import '../../../../shared/shared_ctrl.dart';
import '../../../../shared/shared_models.dart';

final _rCtrl = Get.find<SharedCtrl>();

/// A colored piece of the [RallyPieChart].
class RallyPieChartSegment {
  const RallyPieChartSegment({
    required this.color,
    required this.value,
  });

  final Color color;
  final int value;
}

/// The max height and width of the [RallyPieChart].
const pieChartMaxSize = 500.0;

List<RallyPieChartSegment> buildSegmentsFromAccountItems(
    List<DailySales> items) {
  return List<RallyPieChartSegment>.generate(
    items.length,
    (i) {
      return RallyPieChartSegment(
        color: ChartColors.salesColor(i),
        value: items[i].totalSales,
      );
    },
  );
}

/// An animated circular pie chart to represent pieces of a whole, which can
/// have empty space.
class RallyPieChart extends StatefulWidget {
  const RallyPieChart({
    super.key,
    required this.heroLabel,
    required this.heroAmount,
    required this.wholeAmount,
    required this.segments,
  });

  final String heroLabel;
  final int heroAmount;
  final int wholeAmount;
  final List<RallyPieChartSegment> segments;

  @override
  State<RallyPieChart> createState() => _RallyPieChartState();
}

class _RallyPieChartState extends State<RallyPieChart>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    animation = CurvedAnimation(
        parent: TweenSequence<double>(<TweenSequenceItem<double>>[
          TweenSequenceItem<double>(
            tween: Tween<double>(begin: 0, end: 0),
            weight: 1,
          ),
          TweenSequenceItem<double>(
            tween: Tween<double>(begin: 0, end: 1),
            weight: 1.5,
          ),
        ]).animate(controller),
        curve: Curves.decelerate);
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: _AnimatedRallyPieChart(
        animation: animation,
        centerLabel: widget.heroLabel,
        centerAmount: widget.heroAmount,
        total: widget.wholeAmount,
        segments: widget.segments,
      ),
    );
  }
}

class _AnimatedRallyPieChart extends AnimatedWidget {
  const _AnimatedRallyPieChart({
    required this.animation,
    required this.centerLabel,
    required this.centerAmount,
    required this.total,
    required this.segments,
  }) : super(listenable: animation);

  final Animation<double> animation;
  final String centerLabel;
  final int centerAmount;
  final int total;
  final List<RallyPieChartSegment> segments;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;
    final labelTextStyle = textTheme.bodyMedium!.copyWith(
      fontSize: 12,
    );

    return LayoutBuilder(builder: (context, constraints) {
      // When the widget is larger, we increase the font size.
      var headlineStyle = constraints.maxHeight >= pieChartMaxSize
          ? textTheme.headlineSmall!.copyWith(fontSize: 30)
          : textTheme.headlineSmall!.copyWith(fontSize: 20);

      return DecoratedBox(
        decoration: _RallyPieChartOutlineDecoration(
          maxFraction: animation.value,
          total: total,
          segments: segments,
          surface: color.surface,
        ),
        child: Container(
          height: constraints.maxHeight,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                centerLabel,
                overflow: TextOverflow.clip,
                style: labelTextStyle,
              ),
              const SizedBox(height: 4),
              Text(
                amount(),
                overflow: TextOverflow.clip,
                style: headlineStyle,
              ),
            ],
          ),
        ),
      );
    });
  }

  String amount() {
    if (_rCtrl.pageIndex.value == 0) {
      return NumberFormat('#,##0.00', 'en_US')
          .format(_rCtrl.watuTotalSalesInAmount);
    }

    // format with leading 0 e.g. if 1 -> 01
    final formated = centerAmount.toString().padLeft(2, '0');

    return formated;
  }
}

class _RallyPieChartOutlineDecoration extends Decoration {
  const _RallyPieChartOutlineDecoration({
    required this.maxFraction,
    required this.total,
    required this.segments,
    required this.surface,
  });

  final double maxFraction;
  final int total;
  final List<RallyPieChartSegment> segments;
  final Color surface;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _RallyPieChartOutlineBoxPainter(
      maxFraction: maxFraction,
      wholeAmount: total,
      segments: segments,
      surface: surface,
    );
  }
}

class _RallyPieChartOutlineBoxPainter extends BoxPainter {
  _RallyPieChartOutlineBoxPainter({
    required this.maxFraction,
    required this.wholeAmount,
    required this.segments,
    required this.surface,
  });

  final double maxFraction;
  final int wholeAmount;
  final List<RallyPieChartSegment> segments;
  final Color surface;
  static const double wholeRadians = 2 * math.pi;
  static const double spaceRadians = wholeRadians / 180;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    // Create two padded reacts to draw arcs in: one for colored arcs and one for
    // inner bg arc.
    const strokeWidth = 7.0;
    final outerRadius = math.min(
          configuration.size!.width,
          configuration.size!.height,
        ) /
        2;
    final outerRect = Rect.fromCircle(
      center: configuration.size!.center(offset),
      radius: outerRadius - strokeWidth * 1,
    );
    final innerRect = Rect.fromCircle(
      center: configuration.size!.center(offset),
      radius: outerRadius - strokeWidth * 2,
    );

    // Paint each arc with spacing.
    var cumulativeSpace = 0.0;
    var cumulativeTotal = 0.0;
    for (final segment in segments) {
      final paint = Paint()..color = segment.color;
      final startAngle = _calculateStartAngle(cumulativeTotal, cumulativeSpace);
      final sweepAngle = _calculateSweepAngle(segment.value.toDouble(), 0);
      canvas.drawArc(outerRect, startAngle, sweepAngle, true, paint);
      cumulativeTotal += segment.value;
      cumulativeSpace += spaceRadians;
    }

    // Paint any remaining space black (e.g. budget amount remaining).
    final remaining = wholeAmount - cumulativeTotal;
    if (remaining > 0) {
      final paint = Paint()..color = Colors.black;
      final startAngle =
          _calculateStartAngle(cumulativeTotal, spaceRadians * segments.length);
      final sweepAngle = _calculateSweepAngle(remaining, -spaceRadians);
      canvas.drawArc(outerRect, startAngle, sweepAngle, true, paint);
    }

    // Paint a smaller inner circle to cover the painted arcs, so they are
    // display as segments.
    final bgPaint = Paint()..color = surface;
    canvas.drawArc(innerRect, 0, 3 * math.pi, true, bgPaint);
  }

  double _calculateAngle(double amount, double offset) {
    final wholeMinusSpacesRadians =
        wholeRadians - (segments.length * spaceRadians);
    return maxFraction *
        (amount / wholeAmount * wholeMinusSpacesRadians + offset);
  }

  double _calculateStartAngle(double total, double offset) =>
      _calculateAngle(total, offset) - math.pi / 2;

  double _calculateSweepAngle(double total, double offset) =>
      _calculateAngle(total, offset);
}
