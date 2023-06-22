import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/local_storage_constants.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/base/controller/invoice_quotation_listing_controller.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/base/model/response/summary_data_response.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/invoice/pay_in/model/request/cancel_pay_in_request_model.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/invoice/pay_in/model/request/offline_pay_in_request_model.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/invoice/pay_in/model/response/get_pay_in_response_model.dart';
import 'package:bms/app/services/repository/invoice_repository.dart';
import 'package:bms/app/utils/calculate_price/calculations.dart';
import 'package:bms/app/utils/decode_response_data/decode_response_data.dart';
import 'package:bms/app/utils/local_storage.dart';
import 'package:bms/app/utils/logger_utils.dart';
import 'package:bms/app/utils/return_string_as_fixed_value.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class InvoicePayInController extends GetxController {
  var bizId = '';
  var custId = 0;
  RxBool isButtonEnable = false.obs;
  RxBool isDataLoading = true.obs;

  RxBool isPayInUpdated = false.obs;

  /// validation bool variables
  RxBool isValidAmount = false.obs;

  /// validation strings
  RxString amountStr = ''.obs;

  // RxBool isDoFullPayment = false.obs;

  TextEditingController remainingPaidAmountController = TextEditingController();
  RxString remainingAmountValue = ''.obs;
  RxDouble remainingAmount = 0.0.obs;

  Rx<InvoiceDetailData> invoiceData = InvoiceDetailData().obs;
  RxList<PayInData> payInDataList = List<PayInData>.empty(growable: true).obs;

  @override
  void onInit() {
    Get.lazyPut(() => InvoiceRepository(), fenix: true);
    // custId = Get.find<InvoiceQuotationListingController>()
    //         .customerData
    //         .value
    //         .custId ??
    //     0;
    super.onInit();
  }

  Future<void> setIntentData({required dynamic intentData}) async {
    try {
      bizId =
          await Get.find<LocalStorage>().getStringFromStorage(kStorageBizId);
      invoiceData.value = (intentData[0] as InvoiceDetailData);
      custId = invoiceData.value.custId ?? 0;
      remainingAmount.value = calculateDueAmount(
          totalSellAmount: invoiceData.value.totalAmount ?? 0.0,
          totalCollectedAmount: invoiceData.value.collected ?? 0.0);
      remainingPaidAmountController.text = remainingAmount.toStringAsFixed(2);
      remainingAmountValue.value = remainingAmount.toStringAsFixed(2);
      isButtonEnable.value=true;
      await getPayInDataFromServer();
    } catch (e) {
      LoggerUtils.logException('setIntentData', e);
    }
  }

  /// get pay-in data from server
  Future<void> getPayInDataFromServer() async {
    try {
      var response = await Get.find<InvoiceRepository>().getPayInDataApi(
        bizId: bizId,
        invoiceId: invoiceData.value.invoiceId.toString(),
      );

      if (response != null && response.statusCode == 100) {
        var res = decodeResponseData(responseData: response.data ?? '');
        payInDataList.addAll(payInDataFromJson(res));
      }
      isDataLoading.value = false;
    } catch (e) {
      isDataLoading.value = false;
      LoggerUtils.logException('getPayInDataFromServer', e);
    }
  }

  /// checking validation for input field
  void validateUserInput() {
    isValidAmount.value = false;
    isButtonEnable.value = false;
    amountStr.value = '';
    if (remainingPaidAmountController.text.trim().isNotEmpty) {
      double paidAmount =
          double.parse(remainingPaidAmountController.text.trim());
      double duaValue =
          double.parse(returnToStringAsFixed(value: remainingAmount.value));
      if (paidAmount > duaValue && paidAmount > 1) {
        amountStr.value = kPaidAmountMustBeLessThenDueAmount;
      } else if (paidAmount < 1) {
        amountStr.value = kPaidAmountMustMoreThenOne;
      } else {
        amountStr.value = '';
        isValidAmount.value = true;
        isButtonEnable.value = true;
      }
    }
  }

  /// check validation isButton enable or not
  void checkValidation() {
    if (isButtonEnable.value) {
      offlinePayInAmount();
    } else if (remainingPaidAmountController.text.trim().isEmpty) {
      amountStr.value = kPaidAmountValidation;
    } else {
      validateUserInput();
    }
  }

  /// set pay-in amount
  Future<void> offlinePayInAmount() async {
    try {
      var requestModel = OfflinePayInRequestModel(
        invoiceId: invoiceData.value.invoiceId,
        bizId: int.parse(bizId),
        custId: custId,
        paidAmount: double.parse(remainingPaidAmountController.text.trim())
            .toPrecision(2),
      );
      var response = await Get.find<InvoiceRepository>()
          .offlinePayInDataApi(requestModel: requestModel);

      if (response != null && response.statusCode == 100) {
        isPayInUpdated.value = true;
        resetPayInData();
        // Get.back(result: true);
      }
      isButtonEnable.value=false;
    } catch (e) {
      isButtonEnable.value=false;
      LoggerUtils.logException('offlinePayInAmount', e);
    }
  }

  /// cancel pay-in amount api call
  Future<void> cancelPayInApiCall({required PayInData payInData}) async {
    try {
      var requestModel = CancelPayInRequestModel(
        custId: custId,
        bizId: int.parse(bizId),
        invoiceId: invoiceData.value.invoiceId,
        payInId: payInData.paymentInId,
      );

      var response = await Get.find<InvoiceRepository>()
          .cancelPayInApi(requestModel: requestModel);

      if (response != null && response.statusCode == 100) {
        remainingAmount.value =
            (remainingAmount.value + (payInData.paidAmount ?? 0.0));
        payInDataList.clear();
        getPayInDataFromServer();
        // payInDataList.remove(payInData);
        isPayInUpdated.value = true;
      }
    } catch (e) {
      LoggerUtils.logException('cancelPayInApiCall', e);
    }
  }

  void resetPayInData() {
    FocusScope.of(Get.overlayContext!).unfocus();
    remainingAmount.value = (remainingAmount.value -
        double.parse(remainingPaidAmountController.text.trim()));
    remainingPaidAmountController.text = '';
    remainingAmountValue.value = '';
    payInDataList.clear();
    getPayInDataFromServer();
  }
}
