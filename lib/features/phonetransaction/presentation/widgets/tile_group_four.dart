import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TileGroupFour extends StatelessWidget {
  final String svgPath;
  const TileGroupFour({super.key, required this.svgPath});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SvgPicture.asset(
        svgPath,
        height: 70,
      ),
    );
  }
}
