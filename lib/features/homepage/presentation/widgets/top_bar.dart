import 'package:flutter/material.dart';


class TopLeading extends StatefulWidget {
  final Function(int) onPressed;

  const TopLeading({super.key, required this.onPressed});

  @override
  State<TopLeading> createState() => _TopLeadingState();
}

class _TopLeadingState extends State<TopLeading> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final color1 = color.primary;
    final color2 = color.onSurface.withOpacity(0.3);
    final font = Theme.of(context).textTheme.bodyLarge;
    final font1 = font!.copyWith(
      fontWeight: FontWeight.w900,
      color: color1,
      fontFamily: 'SF-Pro-Display',
    );

    final font2 = font.copyWith(
      fontWeight: FontWeight.w900,
      color: color2,
      fontFamily: 'SF-Pro-Display',
    );

    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
      child: Column(
        children: [
          Row(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      widget.onPressed(0);
                      setState(() {
                        index = 0;
                      });
                    },
                    child: Text(
                      'Sales',
                      style: index == 0 ? font1 : font2,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.onPressed(1);
                      setState(() {
                        index = 1;
                      });
                    },
                    child: Text(
                      'Purchases',
                      style: index == 1 ? font1 : font2,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.onPressed(2);
                      setState(() {
                        index = 2;
                      });
                    },
                    child: Text(
                      'Orders',
                      style: index == 2 ? font1 : font2,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              /* GestureDetector(
            child: brightness == Brightness.dark
                ? SvgPicture.asset(filter)
                : SvgPicture.asset(filterDark),
          ), */
            ],
          ),
        ],
      ),
    );
  }
}
