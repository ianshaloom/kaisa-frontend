import 'package:kaisa/core/datasources/firestore/models/phone-transaction/phone_transaction.dart';

extension TodaysPhoneTranscs on List<PhoneTransaction> {
  List<PhoneTransaction> todaysPhoneTransactions() {
    return where((element) => element.dateTime.day == DateTime.now().day).toList();
  }
}

extension PFilters on List<PhoneTransaction> {
  List<PhoneTransaction> filterByStatus(String requiredStatus) {
    return where((purchase) => purchase.status == requiredStatus).toList();
  }
}

extension Last24Hours on List<PhoneTransaction> {
  List<PhoneTransaction> last24Hours() {
    return where((element) => DateTime.now().difference(element.dateTime).inHours <= 24).toList();
  }
}