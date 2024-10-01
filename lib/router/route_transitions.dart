/* import 'package:flutter/material.dart';

import '../features/receipt/presentation/views/frm_stock_receipt_form.dart';

Route toReceitForm() {
  return PageRouteBuilder<SlideTransition>(
    pageBuilder: (context, animation, secondaryAnimation) =>
        FrmStockReceiptForm(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      //  create a slide animation that brings the new page from right to left
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
} */
