import 'package:flutter/material.dart';

import '../../../../../../theme/text_scheme.dart';
import '../../../../core/constants/network_const.dart';
import '../../../../core/datasources/firestore/models/phone-transaction/phone_transaction.dart';

class TileGroupOne extends StatelessWidget {
  final PhoneTransaction phoneTrans;
  const TileGroupOne({super.key, required this.phoneTrans});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    // subtract a hozintal padding of 24 from width
    final width = size.width - 24;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: (width * 0.68) - 40,
          height: 100,
          padding: const EdgeInsets.only(left: 10, top: 10),
          alignment: Alignment.bottomLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                phoneTrans.phoneName,
                // overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: bodyBold(textTheme).copyWith(
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 150,
          width: (width * 0.32) + 20,
          margin: const EdgeInsets.only(left: 20, bottom: 8),
          padding: const EdgeInsets.symmetric(
            horizontal: 7,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('$kBaseUrlImages${phoneTrans.imgUrl}'),
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
      ],
    );
  }
}
