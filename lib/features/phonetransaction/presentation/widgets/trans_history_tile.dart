import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/datasources/firestore/models/phone-transaction/phone_transaction.dart';
import '../../../../core/utils/utility_methods.dart';
import '../../../../router/route_names.dart';
import '../../../../theme/text_scheme.dart';
import '../controller/phone_transaction_ctrl.dart';

final _ctrl = Get.find<PhoneTransactionCtrl>();

class TransHistoryTile extends StatelessWidget {
  final PhoneTransaction phoneTransaction;
  const TransHistoryTile({super.key, required this.phoneTransaction});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        _ctrl.actionFromTH = true;
        _ctrl.selectedTransaction = phoneTransaction;
        context.go(AppNamedRoutes.toTransHistoryDetails);
      },
      child: Container(
        height: 100,
        margin: const EdgeInsets.only(bottom: 5, top: 5),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(10),
                  ),
                  border: Border(
                    top: border(color),
                    bottom: border(color),
                    left: border(color),
                  ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            phoneTransaction.phoneName.toUpperCase(),
                            style: bodyMedium(textTheme).copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          details(context),
                        ],
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: bgColor(color),
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(10),
                  ),
                ),
                child: CachedNetworkImage(
                  imageUrl: generateImageUrl(phoneTransaction.imgUrl),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  BorderSide border(ColorScheme color) {
    return BorderSide(
      color: color.onSurface.withOpacity(0.07),
      width: 1,
    );
  }

  Color bgColor(ColorScheme color) {
    if (phoneTransaction.isCancelled) {
      return Colors.black.withOpacity(0.2);
    } else if (phoneTransaction.isDelivered) {
      return Colors.green.withOpacity(0.2);
    } else {
      return color.primary.withOpacity(0.2);
    }
  }

  Widget details(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;
    final bolded = bodyMedium(textTheme)
        .copyWith(fontWeight: FontWeight.w500, fontSize: 10);

    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(
        style: bodyMedium(textTheme).copyWith(
          fontSize: 11,
          color: color.onSurface.withOpacity(0.7),
          fontWeight: FontWeight.w300,
        ),
        children: <TextSpan>[
          const TextSpan(
            text: 'RAM',
          ),
          TextSpan(
            text: ' ${phoneTransaction.ram}',
            style: bolded,
          ),
          const TextSpan(
            text: '  ~  Internal storage ',
          ),
          TextSpan(
            text: ' ${phoneTransaction.storage}',
            style: bolded,
          ),
          phoneTransaction.isSender
              ? TextSpan(
                  text:
                      '\nTo ${phoneTransaction.receiverAddress} on ${customDate(phoneTransaction.createdAt)}',
                )
              : TextSpan(
                  text:
                      '\nFrom ${phoneTransaction.senderAddress} on ${customDate(phoneTransaction.createdAt)} ',
                ),
          const TextSpan(
            text: ' \nIMEI ',
            style: TextStyle(fontSize: 10),
          ),
          TextSpan(
            text: ' ${phoneTransaction.imeis}',
            style: bolded,
          ),
        ],
      ),
    );
  }
}
