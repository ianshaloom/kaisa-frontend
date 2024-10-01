import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaisa/core/utils/extension_methods.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/datasources/firestore/models/phone-transaction/phone_transaction.dart';
import '../../../../theme/text_scheme.dart';
import '../../../phonetransaction/presentation/controller/phone_transaction_ctrl.dart';
import 'recent_order_tile.dart';

final _ctrl = Get.find<PhoneTransactionCtrl>();

class RecentOrders extends StatelessWidget {
  const RecentOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<PhoneTransaction>>(
      stream: _ctrl.streamKOrderTranscById(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: bodyMedium(Theme.of(context).textTheme),
            ),
          );
        }

        if (snapshot.hasData) {
          var data = snapshot.data as List<PhoneTransaction>;
          data.sort((a, b) => b.dateTime.compareTo(a.dateTime));

          data = data.last24Hours();

          return data.isEmpty
              ? Center(
                  child: Text(
                    'No recent orders',
                    style: bodyMedium(Theme.of(context).textTheme),
                  ),
                )
              : ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final order = data[index];
                    return RecentOrderListTile(phoneTransaction: order);
                  },
                );
        } else {
          return ListView.builder(
            itemCount: 4,
            itemBuilder: (context, index) {
              return _shimmerTile(context);
            },
          );
        }
      },
    );
  }

  Widget _shimmerTile(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Container(
      height: 100,
      margin: const EdgeInsets.only(bottom: 5, top: 5),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Shimmer.fromColors(
              baseColor: color.primary.withOpacity(0.1),
              highlightColor: color.primary.withOpacity(0.2),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.primary.withOpacity(0.2),
                      color.primary.withOpacity(0.02),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: Shimmer.fromColors(
              baseColor: color.primary.withOpacity(0.1),
              highlightColor: color.primary.withOpacity(0.2),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.primary.withOpacity(0.2),
                      color.primary.withOpacity(0.02),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
