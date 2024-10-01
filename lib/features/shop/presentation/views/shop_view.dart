import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShopView extends StatelessWidget {
  const ShopView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Text('Feature Coming Soon'),
        const SizedBox(
          height: 20,
        ),
        CachedNetworkImage(
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/kaisa-341a6.appspot.com/o/coomingsoon.png?alt=media&token=722a7b38-5cf2-478f-85c8-15d85e4f9b50',
          placeholder: (context, url) => Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              color: Colors.grey[300]!,
            ),
          ),
        ),
      ],
    );
  }
}
