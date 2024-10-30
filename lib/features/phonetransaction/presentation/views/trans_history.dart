import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../shared/shared_ctrl.dart';
import '../../../../theme/text_scheme.dart';
import '../controller/transac_history_ctrl.dart';
import '../widgets/trans_history_tile.dart';

final _ctrl = Get.find<TransacHistoryCtrl>();

class TransHistoryView extends StatelessWidget {
  const TransHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final uuid = Get.find<SharedCtrl>().userData.uuid;

    _ctrl.fetchPhoneTransactions(uuid);

    return Scaffold(
      body: Obx(
        () => _ctrl.isProcessingRequest.value
            ? Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: color.primary,
                  size: 50,
                ),
              )
            : CustomScrollView(
                slivers: [
                  SliverAppBar(
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_sharp),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    scrolledUnderElevation: 0,
                    floating: true,
                    pinned: true,
                    bottom: const PreferredSize(
                      preferredSize: Size.fromHeight(40),
                      child: TopNav(),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    sliver: _ctrl.filteredPurchases.isEmpty
                        ? SliverFillRemaining(
                            child: Center(
                              child: Text(
                                'No purchase(s) found',
                                style: bodyMedium(textTheme),
                              ),
                            ),
                          )
                        // ignore: dead_code
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return TransHistoryTile(
                                    phoneTransaction:
                                        _ctrl.filteredPurchases[index]);
                              },
                              childCount: _ctrl.filteredPurchases.length,
                            ),
                          ),
                  ),
                ],
              ),
      ),
    );
  }
}

class TopNav extends StatelessWidget {
  const TopNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 0),
      alignment: Alignment.centerLeft,
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildButton('Pending', 0, context),
            _buildButton('Delivered', 1, context),
            _buildButton('Cancelled', 2, context),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String title, int index, BuildContext context) {
    final font = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          _ctrl.navOnPressed(index, title);
        },
        child: AnimatedContainer(
          height: 35,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: _ctrl.navIndex.value == index
                    ? color.primary
                    : color.surface,
                width: 3,
              ),
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 10),
              CircleAvatar(
                backgroundColor: title == 'Delivered'
                    ? Colors.green
                    : title == 'Cancelled'
                        ? Colors.black54
                        : color.primary,
                radius: 5,
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: bodyBold(font),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
