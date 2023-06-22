import 'dart:io';
import 'dart:typed_data';

import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/local_storage_constants.dart';
import 'package:bms/app/common/model/filters.dart';
import 'package:bms/app/common/route_constants.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/base/controller/invoice_quotation_listing_controller.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/base/model/response/summary_data_response.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/invoice/base/model/response/donwload_pdf_response_model.dart';
import 'package:bms/app/services/repository/invoice_repository.dart';
import 'package:bms/app/utils/calculate_price/calculations.dart';
import 'package:bms/app/utils/decode_response_data/decode_response_data.dart';
import 'package:bms/app/utils/local_storage.dart';

import 'package:bms/app/utils/logger_utils.dart';
import 'package:bms/app/utils/number_formatter/number_formatter.dart';
import 'package:bms/app/utils/return_string_as_fixed_value.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class InvoiceListingController extends GetxController {
  var bizId = '';
  var custId = 0;

  RxList<InvoiceDetailData> invoiceDataList =
      List<InvoiceDetailData>.empty(growable: true).obs;
  RxList<InvoiceDetailData> appliedInvoiceFilterList =
      List<InvoiceDetailData>.empty(growable: true).obs;

  RxBool isFilterApplied = false.obs;



  @override
  Future<void> onInit() async {
    Get.lazyPut(() => InvoiceRepository(), fenix: true);
    bizId = await Get.find<LocalStorage>().getStringFromStorage(kStorageBizId);
    super.onInit();
  }

  void setIntentData() {
    try {
      if(isFilterApplied.value==false){
      setInvoiceListData();}
      custId = Get.find<InvoiceQuotationListingController>()
              .summaryData
              .value
              .custId ??
          0;

    } catch (e) {
      LoggerUtils.logException('setIntentData', e);
    }
  }

  setInvoiceListData() {
    invoiceDataList.clear();
    appliedInvoiceFilterList.clear();
    var tempList = Get.find<InvoiceQuotationListingController>()
            .summaryData
            .value
            .invDetail ??
        [];
    invoiceDataList.addAll(tempList);
    appliedInvoiceFilterList.addAll(tempList);
  }


  Future<void> navigateToPayInScreen(
      {required InvoiceDetailData invoiceData}) async {
    InvoiceDetailData invData = InvoiceDetailData(
      invoiceId: invoiceData.invoiceId,
      collected: invoiceData.collected,
      invNo: invoiceData.invNo,
      totalAmount: invoiceData.totalAmount,
      status: invoiceData.status,
      createdOn: invoiceData.createdOn,
      custId: custId,
    );

    bool isUpdated =
        await Get.toNamed(kRouteInvoicePayInScreen, arguments: [invData]);

    if (isUpdated == true) {
      Get.find<InvoiceQuotationListingController>().getSummaryDataFromServer();
      Get.find<InvoiceQuotationListingController>().isCustomerUpdated.value =
          true;
    }
  }

  String returnPaymentTag({required int status}) {
    String paymentTag = '';
    if (status == 1) {
      paymentTag = kLabelPaid;
    } else if (status == 2) {
      paymentTag = kLabelPartialPaid;
    } else if (status == 3) {
      paymentTag = kLabelUnPaid;
    } else if (status == 4) {
      paymentTag = kLabelCancelled;
    }

    return paymentTag;
  }

  void navigateToViewInvoiceScreen({required int index}) {
    Get.toNamed(kRouteViewInvoiceScreen, arguments: [
      Get.find<InvoiceQuotationListingController>().customerData.value,
      appliedInvoiceFilterList[index]
    ]);
  }

  Future<void> navigateToGenerateInvoiceScreen() async {
    bool isAdded = await Get.toNamed(
      kRouteGenerateInvoiceScreen,
      arguments: [
        Get.find<InvoiceQuotationListingController>().customerData.value,
        false,
      ],
    );

    if (isAdded == true) {
      Get.find<InvoiceQuotationListingController>().getSummaryDataFromServer();
    } else {}
  }

  Future<void> navigateToUpdateInvoiceScreen(
      {required InvoiceDetailData invoiceDetailData}) async {
    bool isAdded = await Get.toNamed(
      kRouteGenerateInvoiceScreen,
      arguments: [
        Get.find<InvoiceQuotationListingController>().customerData.value,
        true,
        invoiceDetailData,
      ],
    );

    if (isAdded == true) {
      Get.find<InvoiceQuotationListingController>().getSummaryDataFromServer();
    } else {}
  }

  /// cancel invoice api call
  Future<void> cancelInvoice({required String invoiceId}) async {
    try {
      var response = await Get.find<InvoiceRepository>()
          .cancelInvoiceApi(bizId: bizId, invoiceId: invoiceId);

      if (response != null && response.statusCode == 100) {
        Get.find<InvoiceQuotationListingController>()
            .getSummaryDataFromServer();
      }
    } catch (e) {
      LoggerUtils.logException('cancelInvoice', e);
    }
  }

  /// returning due amount values based on amount and invoice-status
  String returnDueAmountText({required InvoiceDetailData invoiceData}) {
    if (invoiceData.status == 4 || invoiceData.status == 1) {
      return '-';
    } else {
      return '$kRupee${returnFormattedNumber(values: double.parse(returnToStringAsFixed(value: calculateDueAmount(totalSellAmount: invoiceData.totalAmount ?? 0.0, totalCollectedAmount: invoiceData.collected ?? 0.0))))}';
    }
  }

  /// download invoice pdf data from server
  Future<void> downloadInvoicePdfDataFromServer(
      {required String invoiceId,
      required String invoiceNo,
      bool? isShareFile = false}) async {
    try {
      var response = await Get.find<InvoiceRepository>()
          .downloadInvoicePDFApi(bizId: bizId, invoiceId: invoiceId);

      if (response != null && response.data != null) {
        var res = decodeResponseData(responseData: response.data ?? '');

        if (res != null && res != '') {
          List<int> dataByteArray = downloadPdfResponseModelFromJson(res);
          writeByteArrayToFileAndStoreInDevice(
              dataByteArray: dataByteArray,
              invoiceId: invoiceId,
              invoiceNo: invoiceNo,
              isShareFile: isShareFile ?? false);
        }
      }
    } catch (e) {
      LoggerUtils.logException('downloadInvoicePdfDataFromServer', e);
    }
  }

  /// write byte array to file and storing file to user device
  Future<void> writeByteArrayToFileAndStoreInDevice(
      {required List<int> dataByteArray,
      required String invoiceNo,
      required String invoiceId,
      required bool isShareFile}) async {
    try {
      Uint8List uInt8list = Uint8List.fromList(dataByteArray);
      final directory = Directory('/storage/emulated/0/Download');
      final path = directory.path;
      final file = File('$path/invoice $invoiceNo.pdf');
      file.writeAsBytes(uInt8list);
      if (isShareFile) {
        shareInvoicePdf(invoiceId: invoiceId, invoiceNo: invoiceNo);
      }else{
        Get.toNamed(kRoutePreviewInvPdfScreen,arguments: [file]);
      }
    } catch (e) {
      LoggerUtils.logException('writeByteArrayToFileAndStoreInDevice', e);
    }
  }

// Future<String> get _localPath async {
//   // final directory = await getApplicationDocumentsDirectory();
//   final directory = Directory('/storage/emulated/0/Download');
//   return directory.path;
// }
//
// Future<File> get _localFile async {
//   final path = await _localPath;
//   print("_localFile == ${path}");
//   return File('$path/.pdf');
// }

  Future<void> shareInvoicePdf(
      {required String invoiceId, required String invoiceNo}) async {
    try {
      final directory = Directory('/storage/emulated/0/Download');
      final path = directory.path;

      bool isExist = await File('$path/invoice $invoiceNo.pdf').exists();
      if (isExist) {
        Share.shareFiles(['$path/invoice $invoiceNo.pdf']);
      } else {
        downloadInvoicePdfDataFromServer(
          invoiceId: invoiceId,
          invoiceNo: invoiceNo,
          isShareFile: true,
        );
      }
    } catch (e) {
      LoggerUtils.logException('shareInvoicePdf', e);
    }
  }


  void applyFilter({required List<Filters> invFiltersList}) {
    String appliedFilter = '';

    int i =
        invFiltersList.indexWhere((element) => element.isSelected == true);
    if (i != -1) {
      appliedFilter = invFiltersList[i].sortName;
      isFilterApplied.value=true;
    }
    if (appliedFilter == kLabelPaid) {
      appliedInvoiceFilterList.clear();
      for (var invData in invoiceDataList) {
        if (invData.status == 1) {
          appliedInvoiceFilterList.add(invData);
        }
      }
      appliedInvoiceFilterList.refresh();
    } else if (appliedFilter == kLabelPartialPaid) {
      appliedInvoiceFilterList.clear();
      for (var invData in invoiceDataList) {
        if (invData.status == 2) {
          appliedInvoiceFilterList.add(invData);
        }
      }
      appliedInvoiceFilterList.refresh();
    } else if (appliedFilter == kLabelUnPaid) {
      appliedInvoiceFilterList.clear();
      for (var invData in invoiceDataList) {
        if (invData.status == 3) {
          appliedInvoiceFilterList.add(invData);
        }
      }
      appliedInvoiceFilterList.refresh();
    } else if (appliedFilter == kLabelCancel) {
      appliedInvoiceFilterList.clear();
      for (var invData in invoiceDataList) {
        if (invData.status == 4) {
          appliedInvoiceFilterList.add(invData);
        }
      }
      appliedInvoiceFilterList.refresh();
      // isFilterApplied.value=true;
    }
    Get.back();
  }

  void clearFilter() {
    appliedInvoiceFilterList.clear();
    setInvoiceListData();


  }
}
