import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../core/constants/image_path_const.dart';
import '../../shared/shared_models.dart';
import '../../theme/text_scheme.dart';
import 'shop_ctrl.dart';
import 'shop_detail_view.dart';

class ShopTile extends StatelessWidget {
  final KaisaShop shop;
  const ShopTile({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final c = Get.find<ShopCtrl>();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: color.onSurface.withOpacity(0.04),
        borderRadius: BorderRadius.circular(7),
      ),
      child: InkWell(
        onTap: () {
          c.reset();
          c.kaisaShop = shop;
          c.fetchOrders();
          Navigator.of(context).push(toReceitView());
        },
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  backgroundColor: color.primary.withOpacity(0.1),
                  child: SvgPicture.asset(
                    location,
                    colorFilter: ColorFilter.mode(
                      color.primary,
                      BlendMode.srcIn,
                    ),
                    height: 30,
                    width: 30,
                  ),
                ),
                title: Text(
                  shop.shopName.toUpperCase(),
                  style: bodyBold(textTheme),
                ),
              ),
              Divider(
                color: color.primary.withOpacity(0.5),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  children: [
                    ...shop.attendants.map(
                      (attendant) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: [
                              /* Icon(
                                Icons.person,
                                color: color.primary,
                                size: 20,
                              ), */
                              SvgPicture.asset(
                                userProfile,
                                colorFilter: ColorFilter.mode(
                                  color.primary,
                                  BlendMode.srcIn,
                                ),
                                height: 25,
                                width: 25,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                attendant.fullName,
                                style: bodyRegular(textTheme),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                attendant.phoneNumber,
                                style: bodyRegular(textTheme).copyWith(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ).toList(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Navigation Routes
  Route toReceitView() {
    return PageRouteBuilder<SlideTransition>(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const ShopDetailedView(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        //  create a slide animation that brings the new page from right to left
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}
