import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/custom_filled_btn.dart';
import '../../../../theme/text_scheme.dart';
import '../controller/shop_ctrl.dart';

final _ctrl = Get.find<ShopCtrl>();

class MbsFilter extends StatelessWidget {
  const MbsFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      width: double.infinity,
      child: Column(
        children: [
          Container(
            height: 3,
            width: 50,
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SizedBox(
              child: Obx(
                () {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
                          _ctrl.days.value = _ctrl.days.value + 7;
                          _ctrl.changeWeek();
                        },
                        icon: const Icon(
                          CupertinoIcons.back,
                        ),
                      ),
                      Text(
                          getWeekString(
                            _ctrl.firstDayOfTheWeek.value,
                          ),
                          style: bodyMedium(Theme.of(context).textTheme)),
                      _ctrl.days.value == 0
                          ? const SizedBox(
                              height: 50,
                              width: 50,
                            )
                          : IconButton(
                              onPressed: () {
                                _ctrl.days.value = _ctrl.days.value - 7;
                                _ctrl.changeWeek();
                              },
                              icon: const Icon(
                                CupertinoIcons.forward,
                              ),
                            ),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          CustomFilledBtn(
            title: 'Apply Filter',
            onPressed: () {
              _ctrl.getFilteredAnalysis();
              Navigator.pop(context);
            },
            pad: 5,
          ),
        ],
      ),
    );
  }
}

class AnimatedPageSwitcher extends StatelessWidget {
  const AnimatedPageSwitcher({
    super.key,
    required this.index,
    required this.children,
  });

  final int index;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) => ScaleTransition(
        scale: animation,
        child: child,
      ),
      child: children[index],
    );
  }
}
