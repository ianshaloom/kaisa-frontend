import 'package:flutter/material.dart';

TextStyle bodyRegular(TextTheme textTheme) =>
    textTheme.bodyMedium!.copyWith(fontSize: 12, fontWeight: FontWeight.w400);
TextStyle bodyMedium(TextTheme textTheme) =>
    textTheme.bodyMedium!.copyWith(fontSize: 12, fontWeight: FontWeight.w500);
TextStyle bodyBold(TextTheme textTheme) =>
    bodyMedium(textTheme).copyWith(fontWeight: FontWeight.w600);

TextStyle bodyLarge(TextTheme textTheme) => textTheme.bodyMedium!.copyWith(
      fontSize: 16.5,
      fontWeight: FontWeight.w600,
    );
