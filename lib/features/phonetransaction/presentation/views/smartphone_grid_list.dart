import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../core/constants/image_path_const.dart';
import '../../../../theme/text_scheme.dart';
// import '../../data/provider/network/firestore_smartphone_ds.dart';
import '../controller/smartphones_ctrl.dart';
import '../widgets/smartphone_gridtile.dart';

final _ctrl = Get.find<SmartphonesCtrl>();

class SmartphonesGridList extends StatelessWidget {
  const SmartphonesGridList({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    _ctrl.fetchSmartphones();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(CupertinoIcons.back),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              /* final FirestoreSmartPhoneDs firestoreSmartPhoneDs =
                  FirestoreSmartPhoneDs();

              for (var smart in smartps) {
                await firestoreSmartPhoneDs.createSmartPhone(smart);
              }

              _ctrl.fetchSmartphones(); */
            },
            icon: SvgPicture.asset(filter),
          )
        ],
        // scrolledUnderElevation: 0,

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            margin:
                const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: color.onSurface.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                const Icon(CupertinoIcons.search),
                const SizedBox(width: 5),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      _ctrl.searchSmartphones(value);
                    },
                    decoration: InputDecoration(
                      hintText: ' Search',
                      hintStyle: bodyMedium(textTheme),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Obx(
        () {
          if (_ctrl.isProcessingRequest.value) {
            return Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: color.primary,
                size: 50,
              ),
            );
          }

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
              mainAxisSpacing: 2,
              crossAxisSpacing: 5,
            ),
            itemCount: _ctrl.searchResult.length,
            padding: const EdgeInsets.only(top: 8),
            itemBuilder: (context, index) {
              return SmartphoneGridTile(
                smartphone: _ctrl.searchResult[index],
                index: index,
              );
            },
          );
        },
      ),
    );
  }
}
