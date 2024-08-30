// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:go_router/go_router.dart';
// import 'package:intl/intl.dart';

// import '../../features/purchase/domain/entity/purchase_entity.dart';
// import '../../router/route_names.dart';
// import '../utils/utility_methods.dart';
// import '../../theme/text_scheme.dart';

// class PurchaseTileHm extends StatelessWidget {
//   final PurchaseEntity purchase;
//   final String page;
//   const PurchaseTileHm({super.key, required this.purchase, required this.page});

//   @override
//   Widget build(BuildContext context) {
//     final color = Theme.of(context).colorScheme;
//     final font = Theme.of(context).textTheme;

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 17),
//       child: GestureDetector(
//         onTap: () {
//           FocusScope.of(context).unfocus();
//           fromHome(page)
//               ? context.go(
//                   '${AppNamedRoutes.fromHomeToPurchaseDetail}/${purchase.rno}')
//               : context
//                   .go('${AppNamedRoutes.toPurchaseDetail}/${purchase.rno}');
//         },
//         child: Stack(
//           children: [
//             Positioned(
//               right: 0,
//               top: 0,
//               child: Text(
//                 elapsedTime(purchase.pdate, purchase.ptime),
//                 style: bodyDefault(font).copyWith(
//                   color: color.onSurface.withOpacity(0.3),
//                   fontSize: 11,
//                 ),
//               ),
//             ),
//             Positioned(
//               right: 0,
//               bottom: 10,
//               child: Container(
//                 alignment: Alignment.center,
//                 padding: const EdgeInsets.all(3),
//                 decoration: BoxDecoration(
//                   color: color.primary.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(5),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(
//                       Icons.person_4_outlined,
//                       size: 15,
//                       color: color.primary,
//                     ),
//                     const SizedBox(width: 5),
//                     Text(
//                       purchase.status == 'Pending'
//                           ? purchase.user
//                           : purchase.approvedby,
//                       style: bodyDefault(font).copyWith(
//                         color: color.onSurface.withOpacity(0.3),
//                         fontSize: 11,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Container(
//               height: 70,
//               // color: Colors.black26,
//               decoration: BoxDecoration(
//                 border: Border(
//                   bottom: BorderSide(
//                     color: color.onSurface.withOpacity(0.07),
//                     width: 0.5,
//                   ),
//                 ),
//               ),
//               child: ListTile(
//                 contentPadding: EdgeInsets.zero,
//                 leading: CircleAvatar(
//                   backgroundColor: color.onSurface.withOpacity(0.00),
//                   radius: 30,
//                   child: SvgPicture.asset(
//                     purchase.svgPath2,
//                     height: 60,
//                   ),
//                 ),
//                 title: Text(
//                   '# ${purchase.rno} ~ ${purchase.pname.toUpperCase()}',
//                   style: bodyDefaultBold(font).copyWith(
//                     fontWeight: FontWeight.w600,
//                     color: color.onSurface,
//                   ),
//                 ),
//                 subtitle: Row(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Text(
//                       'KES ',
//                       style: bodyDefault(font).copyWith(
//                         fontSize: 10,
//                       ),
//                     ),
//                     Text(
//                       NumberFormat('#,##0.00').format(purchase.cost),
//                       style: bodyDefaultBold(font).copyWith(
//                           fontWeight: FontWeight.w400,
//                           color: color.onSurface.withOpacity(0.7)),
//                     ),
//                     Text(
//                       ' || ',
//                       style: bodyDefaultBold(font).copyWith(
//                         fontWeight: FontWeight.w300,
//                         color: color.onSurface.withOpacity(0.3),
//                       ),
//                     ),
//                     Text(
//                       '${purchase.qty} ',
//                       style: bodyDefaultBold(font).copyWith(
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     Text(
//                       'Pieces',
//                       style: bodyDefault(font).copyWith(
//                         fontSize: 10,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
