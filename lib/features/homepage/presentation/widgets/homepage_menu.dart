import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kaisa/theme/text_scheme.dart';

import '../../../../core/constants/image_path_const.dart';
import '../../../../router/route_names.dart';

class HomeMenu extends StatelessWidget {
  const HomeMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: GridView(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.2,
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
          MenuTile(
            onTap: _changePage,
            title: 'Your Stock',
            svg: stock,
          ),
        ],
      ),
    );
  }

  void _toProductsGridList(BuildContext context) {
    context.go(AppNamedRoutes.toSmartPhonesGrid);
  }

  void _changePage(BuildContext context) async {
    
  }
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
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () => onTap(context),
      splashColor: color.primary.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
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
            style: bodyMedium(textTheme),
          )
        ],
      ),
    );
  }
}
