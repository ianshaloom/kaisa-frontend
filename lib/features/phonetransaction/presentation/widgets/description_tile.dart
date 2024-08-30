import 'package:flutter/material.dart';

import '../../../../theme/text_scheme.dart';

class DescriptionTile extends StatelessWidget {
  final String description;
  const DescriptionTile({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;

    return ListTile(
      minTileHeight: 10,
      minLeadingWidth: 10,
      minVerticalPadding: 7,
      leading: CircleAvatar(
        radius: 3,
        backgroundColor: color.primary,
      ),
      title: Text(
        description,
        style: bodyDefaultBold(textTheme).copyWith(
          fontSize: 12,
          color: color.onSurface.withOpacity(0.8),
        ),
      ),
    );
  }
}
