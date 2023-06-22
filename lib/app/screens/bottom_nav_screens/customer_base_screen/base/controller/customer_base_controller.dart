import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/local_storage_constants.dart';
import 'package:bms/app/common/route_constants.dart';
import 'package:bms/app/common/model/filters.dart';
import 'package:bms/app/screens/bottom_nav_screens/customer_base_screen/base/model/response/get_customer_response_model.dart';
import 'package:bms/app/screens/bottom_navigation/base/controller/bottom_nav_base_controller.dart';
import 'package:bms/app/services/repository/customer_repository.dart';
import 'package:bms/app/utils/alert_message_utils.dart';
import 'package:bms/app/utils/calculate_price/calculations.dart';
import 'package:bms/app/utils/decode_response_data/decode_response_data.dart';
import 'package:bms/app/utils/local_storage.dart';
import 'package:bms/app/utils/logger_utils.dart';
import 'package:bms/app/utils/number_formatter/number_formatter.dart';
import 'package:bms/app/utils/return_string_as_fixed_value.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CustomerBaseController extends GetxController {
  TextEditingController searchCustomerController = TextEditingController();

  String bizId = '';
  String token = '';

  // RxInt pageNumber = 0.obs;
  RxBool isDataLoading = true.obs;
  RxBool isFilterApplied = false.obs;

  RxString searchCustomerValue = ''.obs;

  /// search customer data list
  RxList<AllCustomerData> searchCustomerDataList =
      List<AllCustomerData>.empty(growable: true).obs;

  /// all customer data list
  RxList<AllCustomerData> customerDataList =
      List<AllCustomerData>.empty(growable: true).obs;
  RxList<AllCustomerData> appliedCustomerDataList =
      List<AllCustomerData>.empty(growable: true).obs;

  /// customer filter list
  RxList<Filters> custFiltersList = List<Filters>.empty(growable: true).obs;
  RxList<Filters> custFiltersList2 = List<Filters>.empty(growable: true).obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    Get.lazyPut(() => CustomerRepository(), fenix: true);

    bizId = await Get.find<LocalStorage>().getStringFromStorage(kStorageBizId);
    token = await Get.find<LocalStorage>().getStringFromStorage(kStorageToken);
    await getAllCustomerListFromServer();
    setCustFilters();

    Get.find<BottomNavBaseController>().tabIndex.listen((p0) {
      if (p0 == 0) {
        clearCustomerLists();
        getAllCustomerListFromServer();
        setCustFilters();
      }
    });
  }

  /// set customer filters
  void setCustFilters() {
    custFiltersList.add(
        Filters(filterName: kAscOrder, isSelected: false, sortName: kAToZ));
    custFiltersList.add(
        Filters(filterName: kDscOrder, isSelected: false, sortName: kZToA));
    custFiltersList2
        .add(Filters(filterName: kMinDue, isSelected: false, sortName: kMin));
    custFiltersList2
        .add(Filters(filterName: kMaxDue, isSelected: false, sortName: kMax));
  }

  /// get all customer list from server
  Future<void> getAllCustomerListFromServer() async {
    isDataLoading.value = true;
    try {
      var response = await Get.find<CustomerRepository>().getAllCustomerList(
        bizId: bizId,
        pageNumber: '-1',
        // pageNumber: pageNumber.value.toString(),
      );

      if (response != null) {
        if (response.statusCode == 100) {
          var res = decodeResponseData(responseData: response.data ?? '');
          if (res != null && res != '') {
            var tempList = allCustomerDataFromJson(res);
            customerDataList.addAll(tempList);
            appliedCustomerDataList.addAll(tempList);
            calcDueAmount();
          }
        } else {
          Get.find<AlertMessageUtils>().showErrorSnackBar(response?.msg ?? '');
        }
      }
      isDataLoading.value = false;
    } catch (e) {
      isDataLoading.value = false;
      LoggerUtils.logException('getAllCustomerListFromServer', e);
    }
  }

  calcDueAmount() {
    for (var custData in customerDataList) {
      custData.dueAmount = calculateDueAmount(
          totalSellAmount: custData.totalSellAmount ?? 0.0,
          totalCollectedAmount: custData.collected ?? 0.0);
      // .toStringAsFixed(2);
    }
  }

  /// navigate to add customer screen and onSuccess again call getAllCustomer api
  Future<void> navigateToAddCustomerScreen() async {
    bool isSuccessFullyAddedCustomer =
        await Get.toNamed(kRouteAddCustomerScreen);
    if (isSuccessFullyAddedCustomer) {
      clearCustomerLists();
      // pageNumber.value = 0;
      getAllCustomerListFromServer();
    }
  }

  /// navigate to invoice/quotation listing screen and onSuccess again call getAllCustomer api
  Future<void> navigateToInvoiceQuotationListingScreen(
      {required AllCustomerData customerDetailData}) async {
    bool isUpdated = await Get.toNamed(kRouteInvoiceQuotationListingScreen,
        arguments: [customerDetailData]);
    if (isUpdated) {
      clearCustomerLists();
      // pageNumber.value = 0;
      getAllCustomerListFromServer();
    }
  }

  /// onChange customer search value
  void onSearchValueChange() {
    try {
      searchCustomerDataList.clear();
      for (var custData in customerDataList) {
        if ((custData.name ?? '')
            .toLowerCase()
            .contains(searchCustomerValue.toLowerCase())) {
          searchCustomerDataList.add(custData);
        }
      }
      searchCustomerDataList.refresh();
    } catch (e) {
      LoggerUtils.logException('onSearchValueChange', e);
    }
  }

  String returnFormattedAmountValues({required AllCustomerData customerData}) {
    // double dueAmount = calculateDueAmount(
    //     totalSellAmount: customerData.totalSellAmount ?? 0.0,
    //     totalCollectedAmount: customerData.collected ?? 0.0);
    double calculatedDueAmount = double.parse(
        returnToStringAsFixed(value: customerData.dueAmount ?? 0.0)
            .replaceAll('-', ''));

    return returnFormattedNumber(values: calculatedDueAmount);
  }

  void updateOrderingFilterStatus({required int i}) {
    int index =
        custFiltersList.indexWhere((element) => element.isSelected == true);
    if (index != -1 && i != index) {
      custFiltersList[index].isSelected = false;
    }
    custFiltersList[i].isSelected = !custFiltersList[i].isSelected;
    custFiltersList.refresh();
  }

  void updateDueFilterStatus({required int i}) {
    int index =
        custFiltersList2.indexWhere((element) => element.isSelected == true);
    if (index != -1 && i != index) {
      custFiltersList2[index].isSelected = false;
    }
    custFiltersList2[i].isSelected = !custFiltersList2[i].isSelected;
    custFiltersList2.refresh();
  }

  void applyFilter() {
    String appliedFilter = '';

    int i = custFiltersList.indexWhere((element) => element.isSelected == true);
    if (i != -1) {
      appliedFilter = custFiltersList[i].sortName;
    }

    if (appliedFilter == kAToZ) {
      appliedCustomerDataList.clear();
      appliedCustomerDataList.addAll(customerDataList);
      appliedCustomerDataList
          .sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
      appliedCustomerDataList.refresh();
    } else if (appliedFilter == kZToA) {
      appliedCustomerDataList.clear();
      appliedCustomerDataList.addAll(customerDataList);
      appliedCustomerDataList
          .sort((a, b) => (b.name ?? '').compareTo(a.name ?? ''));
      appliedCustomerDataList.refresh();
    }

    /// due filter apply
    int j =
        custFiltersList2.indexWhere((element) => element.isSelected == true);
    List<AllCustomerData> tempCustList = [];
    if (j != -1) {
      appliedFilter = custFiltersList2[j].sortName;
    }

    /// managing first filter apply values
    if (i != -1) {
      tempCustList.addAll(appliedCustomerDataList);
      appliedCustomerDataList.clear();
    } else if (i == -1 || i == 0) {
      // appliedFilter = transFiltersList2[j].sortName;
      tempCustList.addAll(customerDataList);
      appliedCustomerDataList.clear();
    }

    if (appliedFilter == kMin) {
      tempCustList
          .sort((a, b) => (a.dueAmount ?? 0.0).compareTo(b.dueAmount ?? 0.0));
      appliedCustomerDataList.addAll(tempCustList);
      appliedCustomerDataList.refresh();
    } else if (appliedFilter == kMax) {
      appliedCustomerDataList
          .sort((a, b) => (b.dueAmount ?? 0.0).compareTo(a.dueAmount ?? 0.0));
      appliedCustomerDataList.addAll(tempCustList);
      appliedCustomerDataList.refresh();
    } else {
      appliedCustomerDataList.addAll(tempCustList);
    }

    if (i != -1 || j != -1) {
      isFilterApplied.value = true;
    } else {
      isFilterApplied.value = false;
    }
    Get.back();
  }

  void clearFilter() {
    int i = custFiltersList.indexWhere((element) => element.isSelected == true);
    int j =
        custFiltersList2.indexWhere((element) => element.isSelected == true);
    if (i != -1) {
      custFiltersList[i].isSelected = false;
    }
    if (j != -1) {
      custFiltersList2[j].isSelected = false;
    }
    isFilterApplied.value = false;

    isFilterApplied.value = false;
    // transList.clear();
    appliedCustomerDataList.clear();
    // getTransactionDataFromServer();
    custFiltersList.refresh();
    custFiltersList2.refresh();
    appliedCustomerDataList.addAll(customerDataList);
    // Get.back();
  }

  /// clear all list when come back from inner screens
  void clearCustomerLists() {
    isFilterApplied.value = false;
    searchCustomerController.text = '';
    searchCustomerValue.value = '';
    searchCustomerDataList.value = [];
    customerDataList.clear();
    appliedCustomerDataList.clear();
    custFiltersList.clear();
    custFiltersList2.clear();
  }
}
