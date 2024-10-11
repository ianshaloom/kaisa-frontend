import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/image_path_const.dart';
import '../../../../router/route_names.dart';
import '../../../profile/presentation/views/profile_view.dart';
import '../../../analytics/presentation/controller/analytics_ctrl.dart';
import '../../../analytics/presentation/views/analytics_view.dart';
import '../../../shops/shops_view.dart';
import '../../../stock/presentation/views/stock_view.dart';
import '../controller/homepagectrl.dart';
import 'home_view.dart';

final _ctrl = Get.find<HomePageCtrl>();

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.only(top: 25),
          child: AnimatedPageSwitcher(
            index: _ctrl.navIndex.value,
            children: const [
              HomeView(),
              StockView(),
              AnalyticsView(),
              ShopsView(),
            ],
          ),
        ),
      ),
      floatingActionButton: Obx(
        () => _ctrl.navIndex.value != 0
            ? const SizedBox.shrink()
            : FloatingActionButton(
                elevation: 5,
                onPressed: () => _toProductsGridList(context),
                shape: const CircleBorder(),
                child: SvgPicture.asset(
                  newOder,
                  height: 40,
                  colorFilter: ColorFilter.mode(color.primary, BlendMode.srcIn),
                ),
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: const BtmNavigationBar(),
      drawer: const Drawer(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
        child: ProfileView(),
      ),
    );
  }

  void _toProductsGridList(BuildContext context) {
    context.go(AppNamedRoutes.toSmartPhonesGrid);
  }
}

class BtmNavigationBar extends StatelessWidget {
  const BtmNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Obx(
      () => NavigationBar(
        // indicatorColor: Colors.transparent,
        height: 40,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        selectedIndex: _ctrl.navIndex.value,
        onDestinationSelected: (int index) {
          _ctrl.navOnPressed(index);

          if (index == 2) {
            final c = Get.find<AnalyticsCtlr>();
            c.resetFilters();
          }
        },
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: SvgPicture.asset(
              home,
              height: 30,
              colorFilter: ColorFilter.mode(color.primary, BlendMode.modulate),
            ),
            icon: SvgPicture.asset(
              home,
              height: 30,
              colorFilter: ColorFilter.mode(color.primary, BlendMode.srcIn),
            ),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: SvgPicture.asset(
              stock,
              height: 30,
              colorFilter: ColorFilter.mode(color.primary, BlendMode.modulate),
            ),
            icon: SvgPicture.asset(
              stock,
              height: 30,
              colorFilter: ColorFilter.mode(color.primary, BlendMode.srcIn),
            ),
            label: 'Stock',
          ),
          NavigationDestination(
            selectedIcon: SvgPicture.asset(
              rank,
              height: 30,
              colorFilter: ColorFilter.mode(color.primary, BlendMode.modulate),
            ),
            icon: SvgPicture.asset(
              rank,
              height: 30,
              colorFilter: ColorFilter.mode(color.primary, BlendMode.srcIn),
            ),
            label: 'Profile',
          ),
          NavigationDestination(
            selectedIcon: SvgPicture.asset(
              shop,
              height: 30,
              colorFilter: ColorFilter.mode(color.primary, BlendMode.modulate),
            ),
            icon: SvgPicture.asset(
              shop,
              height: 30,
              colorFilter: ColorFilter.mode(color.primary, BlendMode.srcIn),
            ),
            label: 'Shops',
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
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      child: children[index],
    );
  }
}
