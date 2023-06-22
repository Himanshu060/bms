import 'package:bms/app/common/local_storage_constants.dart';
import 'package:bms/app/screens/bottom_nav_screens/customer_base_screen/base/model/response/get_customer_response_model.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/base/model/response/summary_data_response.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/invoice/view_invoice/model/response/total_product_service_data.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/invoice/view_invoice/model/response/view_invoice_response_model.dart';
import 'package:bms/app/screens/bottom_navigation/base/controller/bottom_nav_base_controller.dart';
import 'package:bms/app/screens/bottom_navigation/base/model/response/drop_down_common_data.dart';
import 'package:bms/app/services/repository/invoice_repository.dart';
import 'package:bms/app/utils/calculate_price/calculations.dart';
import 'package:bms/app/utils/decode_response_data/decode_response_data.dart';
import 'package:bms/app/utils/local_storage.dart';
import 'package:bms/app/utils/logger_utils.dart';
import 'package:bms/app/utils/number_formatter/number_formatter.dart';
import 'package:bms/app/utils/return_string_as_fixed_value.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ViewInvoiceController extends GetxController {
  var bizId = '';
  int invoiceId = 0;
  RxList<DropdownCommonData> gstList =
      List<DropdownCommonData>.empty(growable: true).obs;

  Rx<InvoiceDetailData> intentInvoiceData = InvoiceDetailData().obs;
  Rx<AllCustomerData> customerData = AllCustomerData().obs;
  Rx<ViewInvoiceData> viewInvoiceData = ViewInvoiceData().obs;
  RxList<ViewItemList> itemsList = List<ViewItemList>.empty(growable: true).obs;

  TextEditingController totalController = TextEditingController();
  TextEditingController payableAmountController = TextEditingController();
  TextEditingController receivedAmountController = TextEditingController();
  TextEditingController discInAmountController = TextEditingController();
  TextEditingController discInPercentageController = TextEditingController();
  TextEditingController additionalChargesController = TextEditingController();

  @override
  void onInit() {
    Get.lazyPut(() => InvoiceRepository(), fenix: true);
    setGSTRateValues();
    super.onInit();
  }

  setGSTRateValues() async {
    var res = await Get.find<LocalStorage>()
        .getStringFromStorage(kStorageGstRateList);
    gstList.addAll(dropdownCommonDataFromJson(res));
  }

  Future<void> setIntentData({required dynamic intentData}) async {
    try {
      bizId =
          await Get.find<LocalStorage>().getStringFromStorage(kStorageBizId);
      customerData.value = (intentData[0] as AllCustomerData);
      intentInvoiceData.value = (intentData[1] as InvoiceDetailData);
      invoiceId = intentInvoiceData.value.invoiceId ?? 0;
      getInvoiceDetailsFromServer();
    } catch (e) {
      LoggerUtils.logException('setIntentData', e);
    }
  }

  /// get invoice details data from server
  Future<void> getInvoiceDetailsFromServer() async {
    try {
      var response = await Get.find<InvoiceRepository>()
          .getInvoiceDetailsApi(bizId: bizId, invoiceId: invoiceId);

      if (response != null && response.statusCode == 100) {
        var res = decodeResponseData(responseData: response.data ?? '');
        if (res != null && res != '') {
          viewInvoiceData.value = viewInvoiceDataFromJson(res);
          itemsList.addAll(viewInvoiceData.value.itemList ?? []);
          // getTotalItemsList();
          getTotalAmount();
          getDiscountPercentage();
          getReceivedAmount();
          totalController.text = returnFormattedAmount(
              values: returnToStringAsFixed(
                  value: (viewInvoiceData.value.totalAmount ?? 0.0)));
          payableAmountController.text = returnFormattedAmount(
              values: returnToStringAsFixed(
                  value: (viewInvoiceData.value.payableAmount ?? 0.0)));
          receivedAmountController.text = returnFormattedAmount(
              values: returnToStringAsFixed(
                  value: (viewInvoiceData.value.totalReceivedAmount ?? 0.0)));
          discInAmountController.text = returnFormattedAmount(
              values: returnToStringAsFixed(
                  value: (viewInvoiceData.value.discountAmount ?? 0.0)));
          discInPercentageController.text = returnFormattedAmount(
              values: returnToStringAsFixed(
                  value: (viewInvoiceData.value.discountPercentage ?? 0.0)));
          additionalChargesController.text = returnFormattedAmount(
              values: returnToStringAsFixed(
                  value: (viewInvoiceData.value.additionalCharge ?? 0.0)));
        }
      }
    } catch (e) {
      LoggerUtils.logException('getInvoiceDetailsFromServer', e);
    }
  }

  /// adding products and services into single list
  // void getTotalItemsList() {
  //   try {
  //     for (Product productData in viewInvoiceData.value.products ?? []) {
  //       totalItemsList.add(
  //         TotalProductServiceData(
  //           qty: productData.qty,
  //           name: productData.name,
  //           gstRateId: productData.gstRateId,
  //           categoryId: productData.categoryId,
  //           itemId: productData.productId,
  //           sellPrice: productData.sellPrice,
  //           unitId: productData.unitId,
  //         ),
  //       );
  //     }
  //     for (Service serviceData in viewInvoiceData.value.services ?? []) {
  //       totalItemsList.add(
  //         TotalProductServiceData(
  //           qty: serviceData.qty,
  //           name: serviceData.name,
  //           gstRateId: serviceData.gstRateId,
  //           categoryId: serviceData.categoryId,
  //           itemId: serviceData.serviceId,
  //           sellPrice: serviceData.sellPrice,
  //           unitId: serviceData.unitId,
  //         ),
  //       );
  //     }
  //     totalItemsList.refresh();
  //   } catch (e) {
  //     LoggerUtils.logException('getTotalItemsList', e);
  //   }
  // }

  getTotalAmount() {
    viewInvoiceData.value.totalAmount = calculateTotalAmount(
        payableAmount: viewInvoiceData.value.payableAmount ?? 0.0,
        discountPrice: viewInvoiceData.value.discountAmount ?? 0.0,
        additionalCharge: viewInvoiceData.value.additionalCharge ?? 0.0);
    viewInvoiceData.refresh();
    // return viewInvoiceData.value.totalAmount ?? 0.0;
  }

  //  getDiscountAmount() {
  //   viewInvoiceData.value.discountAmount= calculateDiscountAmount(
  //       totalAmount: viewInvoiceData.value.totalAmount ?? 0.0,
  //       additionalCharges: viewInvoiceData.value.additionalCharge ?? 0.0,
  //       discountPercentage: 0.0);
  //   viewInvoiceData.refresh();
  //
  // }

  getDiscountPercentage() {
    viewInvoiceData.value.discountPercentage = calculateDiscountPercentage(
        discountPrice: viewInvoiceData.value.discountAmount ?? 0.0,
        totalAmount: viewInvoiceData.value.totalAmount ?? 0.0);

    viewInvoiceData.refresh();
    // return viewInvoiceData.value.discountPercentage ?? 0.0;
  }

  getReceivedAmount() {
    double dueAmount = calculateDueAmount(
        totalSellAmount: intentInvoiceData.value.totalAmount ?? 0.0,
        totalCollectedAmount: intentInvoiceData.value.collected ?? 0.0);
    viewInvoiceData.value.totalReceivedAmount = calculateTotalReceivedAmount(
        payableAmount: viewInvoiceData.value.payableAmount ?? 0.0,
        dueAmount: dueAmount);
    viewInvoiceData.refresh();
  }

  /// return match gst rate from gstRateList
  String returnGstRate({required ViewItemList itemData}) {
    String gstRate = '0.0';

    if (itemData.gstRateId != null) {
      gstRate =
          (((BottomNavBaseController.gstRateList[(itemData.gstRateId ?? 0) - 1])
                      .value) ??
                  0.0)
              .toStringAsFixed(2);
    }

    return '$gstRate %';
  }

  returnFormattedAmount({values}) {
    return returnFormattedNumber(values: double.parse(values));
  }

 String returnItemTotalValues({required ViewItemList itemData}) {
    double gst = 0;
    int i = gstList.indexWhere((element) => element.id == itemData.gstRateId);
    if (i != -1) {
      gst = gstList[i].value ?? 0;
    }
   return returnToStringAsFixed(
      value: calculateItemTotal(
        sellPrice: itemData.sellingPrice ?? 0.0,
        qty: itemData.qty ?? 0.0,
        gstValue: gst,
        isTaxInc: itemData.isTaxInc ?? false,
      ),
    );
  }
}
