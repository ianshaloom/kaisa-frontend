import 'package:kaisa/core/datasources/firestore/models/phone-transaction/phone_transaction.dart';

extension TodaysPhoneTranscs on List<PhoneTransaction> {
  List<PhoneTransaction> todaysPhoneTransactions() {
    return where((element) => element.createdAt.day == DateTime.now().day)
        .toList();
  }
}


extension PFilters on List<PhoneTransaction> {
  List<PhoneTransaction> filterByStatus(String requiredStatus) {
    return where((purchase) => purchase.status == requiredStatus).toList();
  }
}


extension PhoneTransactionObjSwap on PhoneTransaction {
  PhoneTransaction swap(String newExchangesId) {
    return PhoneTransaction(
      transferId: transferId,
      exchangesId: newExchangesId,
      senderId: senderId,
      senderName: senderName,
      senderAddress: senderAddress,
      receiverId: receiverId,
      receiverName: receiverName,
      receiverAddress: receiverAddress,
      phoneName: phoneName,
      imgUrl: imgUrl,
      ram: ram,
      storage: storage,
      imeis: imeis,
      status: status,
      createdAt: createdAt,
      receivedAt: receivedAt,
      processedBy: processedBy,
      participants: participants,
    );
  }
}
