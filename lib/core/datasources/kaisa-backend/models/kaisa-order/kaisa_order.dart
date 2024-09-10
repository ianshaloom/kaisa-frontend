import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../../utils/utility_methods.dart';
import '../../../firestore/models/phone-transaction/phone_transaction.dart';

part 'kaisa_order.g.dart';

@JsonSerializable()
class KOrder extends Equatable {
  final String orderId;
  final String smartphone;
  final String imei;
  final String sentBy;
  final String receivedBy;
  final String sentOn;
  final String receivedOn;
  final String orderFrom;
  final String orderTo;
  final bool isSold;

  const KOrder(
      {required this.orderId,
      required this.smartphone,
      required this.imei,
      required this.sentBy,
      required this.receivedBy,
      required this.sentOn,
      required this.receivedOn,
      required this.orderFrom,
      required this.orderTo,
      required this.isSold});

  factory KOrder.fromJson(Map<String, dynamic> json) =>
      _$KOrderFromJson(json);

  Map<String, dynamic> toJson() => _$KOrderToJson(this);

  KOrder copyWith({
    String? orderId,
    String? smartphone,
    String? imei,
    String? sentBy,
    String? receivedBy,
    String? sentOn,
    String? receivedOn,
    String? orderFrom,
    String? orderTo,
    bool? isSold,
  }) {
    return KOrder(
      orderId: orderId ?? this.orderId,
      smartphone: smartphone ?? this.smartphone,
      imei: imei ?? this.imei,
      sentBy: sentBy ?? this.sentBy,
      receivedBy: receivedBy ?? this.receivedBy,
      sentOn: sentOn ?? this.sentOn,
      receivedOn: receivedOn ?? this.receivedOn,
      orderFrom: orderFrom ?? this.orderFrom,
      orderTo: orderTo ?? this.orderTo,
      isSold: isSold ?? this.isSold,
    );
  }

  KOrder.fromPhoneTransaction({
    required PhoneTransaction phoneTransaction}) : this(
    orderId: const Uuid().v4(),
    smartphone: phoneName(phoneTransaction.phoneName, phoneTransaction.ram, phoneTransaction.storage),
    imei: phoneTransaction.imeis,
    sentBy: phoneTransaction.senderName,
    receivedBy: phoneTransaction.receiverName,
    sentOn: formatDate(phoneTransaction.createdAt),
    receivedOn: formatDate(phoneTransaction.receivedAt),
    orderFrom: phoneTransaction.senderAddress,
    orderTo: phoneTransaction.receiverAddress,
    isSold: false,
  );

  @override
  List<Object?> get props => [
        orderId,
        smartphone,
        imei,
        sentBy,
        receivedBy,
        sentOn,
        receivedOn,
        orderFrom,
        orderTo,
        isSold,
      ];
}
