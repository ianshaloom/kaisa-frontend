import 'package:get/get.dart';

import '../../../../core/errors/failure_n_success.dart';
import '../../domain/entity/smartphone_entity.dart';
import '../../domain/usecase/smartphones_usecase.dart';

class SmartphonesCtrl {
  final SmartphonesUsecase _smartphonesUsecase;
  SmartphonesCtrl(this._smartphonesUsecase);

  var isProcessingRequest = false.obs;
  var requestFailure = <Failure>[].obs;
  var smartPhones = <SmartphoneEntity>[].obs;

  // get all smartphones
  Future<void> fetchSmartphones() async {
    requestFailure.clear();
    isProcessingRequest.value = true;

    final phonesOrFailure = await _smartphonesUsecase.fetchSmartphones();

    phonesOrFailure.fold(
      (failure) => requestFailure.add(failure),
      (phones) async {
        smartPhones.assignAll(phones);
      },
    );

    isProcessingRequest.value = false;
  }

}
