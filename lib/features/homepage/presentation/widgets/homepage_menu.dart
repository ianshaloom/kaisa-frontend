import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/image_path_const.dart';
import '../../../../router/route_names.dart';

class HomeMenu extends StatelessWidget {
  const HomeMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: GridView(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 15,
        ),
        children: [
          MenuTile(
            onTap: _toProductsGridList,
            title: 'Send Order',
            svg: newOder,
          ),
          MenuTile(
            onTap: _changePage,
            title: 'Post Receipt',
            svg: receipt,
          ),
        ],
      ),
    );
  }

  void _toProductsGridList(BuildContext context) {
    context.go(AppNamedRoutes.toSmartPhonesGrid);
  }

  void _changePage() {}
}

class MenuTile extends StatelessWidget {
  final Function onTap;
  final String title;
  final String svg;
  const MenuTile(
      {super.key, required this.onTap, required this.title, required this.svg});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => onTap(context),
      splashColor: color.primary.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.primary.withOpacity(0.1),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
                radius: 30,
                backgroundColor: color.primary.withOpacity(0.05),
                child: SvgPicture.asset(
                  svg,
                  height: 40,
                  colorFilter: ColorFilter.mode(color.primary, BlendMode.srcIn),
                )),
            Text(
              title,
              style: Theme.of(context).textTheme.labelMedium,
            )
          ],
        ),
      ),
    );
  }
}
