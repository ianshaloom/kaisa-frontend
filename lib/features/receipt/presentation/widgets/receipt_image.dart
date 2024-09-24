import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/constants/image_path_const.dart';
import '../../../../theme/text_scheme.dart';
import '../controller/receipt_ctrl.dart';

final _ctrl = Get.find<ReceiptCtrl>();

class ReceiptImage extends StatelessWidget {
  final String imei;
  ReceiptImage({super.key, required this.imei});

  final controller = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Expanded(
          child: Obx(
            () => _ctrl.images.isEmpty
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(60),
                    decoration: BoxDecoration(
                      color: color.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SvgPicture.asset(
                      imagePlaceholder,
                      height: 100,
                      colorFilter: ColorFilter.mode(
                        color.primary.withOpacity(0.5),
                        BlendMode.srcATop,
                      ),
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          controller: controller,
                          itemCount: _ctrl.images.length,
                          itemBuilder: (context, index) {
                            return Container(
                              alignment: Alignment.center,
                              child: Stack(
                                children: [
                                  Image.file(
                                    _ctrl.images[index],
                                    fit: BoxFit.fitHeight,
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: CircleAvatar(
                                      radius: 15,
                                      backgroundColor: color.surface,
                                      child: IconButton(
                                        onPressed: () =>
                                            _ctrl.removeImage(index),
                                        icon: Icon(
                                          CupertinoIcons.delete,
                                          color: color.error,
                                          size: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 5),
                      SmoothPageIndicator(
                        controller: controller,
                        count: _ctrl.images.length,
                        effect: WormEffect(
                          dotWidth: 5,
                          dotHeight: 5,
                          activeDotColor: color.primary,
                          dotColor: color.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
          ),
        ),

        const SizedBox(height: 10),
        // select image button
        Row(
          children: [
            Expanded(
              child: Obx(
                () => _ctrl.images.isEmpty
                    ? TextButton.icon(
                        onPressed: () => _ctrl.pickImage(),
                        icon: const Icon(Icons.image),
                        label: Text(
                          'Select Image',
                          style: bodyRegular(textTheme).copyWith(
                            color: color.primary,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          elevation: 0.5,
                        ),
                      )
                    : TextButton.icon(
                        onPressed: () => _ctrl.pickImage(),
                        icon: const Icon(Icons.image),
                        label: Text(
                          'Select More Images',
                          style: bodyRegular(textTheme).copyWith(
                            color: color.primary,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          elevation: 0.5,
                        ),
                      ),
              ),
            ),
            /* const SizedBox(width: 10),
             Expanded(
              child: ElevatedButton.icon(
                onPressed: () =>
                    CloudStorageDs().uploadImage(_ctrl.images[1], imei),
                icon: const Icon(Icons.upload),
                label: Text(
                  'Upload Image',
                  style: bodyRegular(textTheme).copyWith(
                    color: color.primary,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  elevation: 0.5,
                ),
              ),
            ), */
          ],
        )
      ],
    );
  }
}
