import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaisa/features/receipt/presentation/views/home_analytics.dart';

import '../../../../router/route_names.dart';
import '../../../../theme/text_scheme.dart';
import '../widgets/recent_orders_list.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        const SizedBox(height: 10),
        const HomeAnalytics(),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: color.surfaceBright,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              // top box shadow
              boxShadow: [
                BoxShadow(
                  color: color.primary.withOpacity(0.05),
                  offset: const Offset(0, -5),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  height: 4,
                  width: 50,
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    color: color.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "Recent Orders",
                      style: bodyBold(textTheme).copyWith(
                        fontSize: 13,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () =>
                          context.go(AppNamedRoutes.toTransHistory),
                      child: Text(
                        "View All",
                        style: bodyMedium(textTheme).copyWith(
                          color: color.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Expanded(
                  child: RecentOrders(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
