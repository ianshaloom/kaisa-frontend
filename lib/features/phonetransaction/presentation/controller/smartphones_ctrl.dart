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
  var activeList = <SmartphoneEntity>[].obs;

  var searchResult = <SmartphoneEntity>[].obs;

  // get all smartphones
  Future<void> fetchSmartphones() async {
    requestFailure.clear();
    isProcessingRequest.value = true;

    final phonesOrFailure = await _smartphonesUsecase.fetchSmartphones();

    phonesOrFailure.fold(
      (failure) => requestFailure.add(failure),
      (phones) async {
        phones.sort((a, b) => a.name.compareTo(b.name));

        smartPhones.assignAll(phones);
        searchResult.assignAll(phones);
      },
    );

    isProcessingRequest.value = false;
  }

  // search smartphones
  Future<void> searchSmartphones(String query) async {
    searchResult.clear();

    final result = smartPhones.where((element) {
      final name = element.name.toLowerCase();
      final brand = element.brand.toLowerCase();
      final model = element.model.toLowerCase();
      final queryLower = query.toLowerCase();

      return name.contains(queryLower) ||
          brand.contains(queryLower) ||
          model.contains(queryLower);
    }).toList();

    searchResult.assignAll(result);
  }

  // clear search result
  void clearSearchResult() {
    searchResult.clear();
    searchResult.assignAll(smartPhones);
  }
}
