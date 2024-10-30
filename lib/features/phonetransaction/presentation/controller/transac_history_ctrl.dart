import 'package:get/get.dart';
import 'package:kaisa/core/utils/extension_methods.dart';

import '../../../../core/datasources/firestore/models/phone-transaction/phone_transaction.dart';
import '../../../../core/errors/failure_n_success.dart';
import '../../domain/usecase/phone_transaction_usecase.dart';

class TransacHistoryCtrl extends GetxController {
  final PhoneTransactionUsecase _phoneTransactionUseCase;
  TransacHistoryCtrl(this._phoneTransactionUseCase);

  var navIndex = 0.obs;
  var isProcessingRequest = false.obs;
  var requestFailure = <Failure>[].obs;
  var allPhoneTransactions = <PhoneTransaction>[].obs;
  var filteredPurchases = <PhoneTransaction>[].obs;

  void navOnPressed(int i, String status) {
    navIndex.value = i;
    allPhoneTransactions.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    filteredPurchases.assignAll(allPhoneTransactions.filterByStatus(status));
  }

  // fetch all phone transactions
  Future<void> fetchPhoneTransactions(String uuid) async {
    reset();
    isProcessingRequest.value = true;

    final result = await _phoneTransactionUseCase.fetchPhoneTransactions(uuid);

    result.fold(
      (failure) {
        requestFailure.add(failure);
      },
      (transactions) {
        allPhoneTransactions.assignAll(transactions);
        filteredPurchases.assignAll(transactions.filterByStatus('Pending'));
      },
    );
    isProcessingRequest.value = false;
  }

  void reset() {
    navIndex.value = 0;
    requestFailure.clear();
    allPhoneTransactions.clear();
    filteredPurchases.clear();
  }
}
