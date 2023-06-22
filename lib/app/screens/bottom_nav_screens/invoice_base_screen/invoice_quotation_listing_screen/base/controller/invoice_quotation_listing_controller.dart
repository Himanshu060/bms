import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/local_storage_constants.dart';
import 'package:bms/app/common/model/filters.dart';
import 'package:bms/app/common/route_constants.dart';
import 'package:bms/app/screens/bottom_nav_screens/customer_base_screen/base/model/response/get_customer_response_model.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/base/model/response/summary_data_response.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/invoice/base/controller/invoice_listing_controller.dart';
import 'package:bms/app/services/repository/summary_repository.dart';
import 'package:bms/app/utils/decode_response_data/decode_response_data.dart';
import 'package:bms/app/utils/local_storage.dart';
import 'package:bms/app/utils/logger_utils.dart';
import 'package:get/get.dart';

class InvoiceQuotationListingController extends GetxController {
  RxInt currentTabValue = 1.obs;
  RxBool isFilterApplied = false.obs;

  Rx<AllCustomerData> customerData = AllCustomerData().obs;
  Rx<SummaryData> summaryData = SummaryData().obs;

  /// invoice filter list
  RxList<Filters> invFiltersList = List<Filters>.empty(growable: true).obs;

  RxBool isDataLoading = true.obs;
  RxBool isCustomerUpdated = false.obs;
  var bizId = '';

  @override
  void onInit() {
    Get.lazyPut(() => SummaryRepository(), fenix: true);
    super.onInit();
  }

  Future<void> setIntentData({required dynamic intentData}) async {
    try {
      bizId =
          await Get.find<LocalStorage>().getStringFromStorage(kStorageBizId);
      customerData.value = (intentData[0] as AllCustomerData);
      await getSummaryDataFromServer();
      setInvFilters();
    } catch (e) {
      LoggerUtils.logException('setIntentData', e);
    }
  }

  /// set customer filters
  void setInvFilters() {
    invFiltersList.add(Filters(
        filterName: kLabelPaid, isSelected: false, sortName: kLabelPaid));
    invFiltersList.add(Filters(
        filterName: kLabelUnPaid, isSelected: false, sortName: kLabelUnPaid));
    invFiltersList.add(Filters(
        filterName: kLabelPartialPaid,
        isSelected: false,
        sortName: kLabelPartialPaid));
    invFiltersList.add(Filters(
        filterName: kLabelCancelled,
        isSelected: false,
        sortName: kLabelCancel));
  }

  /// navigate to edit customer screen and onSuccess again call getAllCustomer api
  Future<void> navigateToEditCustomerScreen() async {
    var updatedCustomerData = await Get.toNamed(kRouteEditCustomerScreen,
        arguments: [customerData.value]);
    if (updatedCustomerData[0] != null) {
      customerData.value.name = updatedCustomerData[0];
      isCustomerUpdated.value = true;
    }
    customerData.refresh();
  }

  /// get summary data from server
  Future<void> getSummaryDataFromServer() async {
    try {
      isDataLoading.value = true;
      var response = await Get.find<SummaryRepository>().getServiceDetailsApi(
        bizId: bizId,
        custId: customerData.value.custId.toString(),
      );

      if (response != null && response.statusCode == 100) {
        var res = decodeResponseData(responseData: response.data ?? '');

        if (res != null && res != '') {
          summaryData.value = summaryDataFromJson(res);
        }
      }
      isDataLoading.value = false;
    } catch (e) {
      isDataLoading.value = false;
      LoggerUtils.logException('getSummaryDataFromServer', e);
    }
  }

  void updateFilterStatus({required int i}) {
    int index =
        invFiltersList.indexWhere((element) => element.isSelected == true);
    if (index != -1 && i != index) {
      invFiltersList[index].isSelected = false;
    }
    invFiltersList[i].isSelected = !invFiltersList[i].isSelected;
    invFiltersList.refresh();
  }

  void clearFilter() {
    int i = invFiltersList.indexWhere((element) => element.isSelected == true);
    if (i != -1) {
      invFiltersList[i].isSelected = false;
      Get.find<InvoiceListingController>().clearFilter();
      isFilterApplied.value = false;
    }
    invFiltersList.refresh();
  }

  void applyFilter() {
    Get.find<InvoiceListingController>()
        .applyFilter(invFiltersList: invFiltersList);
    int i = invFiltersList.indexWhere((element) => element.isSelected == true);
    if (i != -1) {
      isFilterApplied.value = true;
    }else{
      Get.find<InvoiceListingController>().clearFilter();
      isFilterApplied.value = false;
    }
  }
}
