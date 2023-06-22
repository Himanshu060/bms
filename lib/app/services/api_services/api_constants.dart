class ApiConstants {
  static String baseUrl =
      'http://ec2-3-109-32-2.ap-south-1.compute.amazonaws.com/';

  static const String _mPub = 'mpub/';
  static const String _mApi = 'mapi/';

  static const String _cust = '${_mApi}cust/';
  static const String _product = '${_mApi}pr/';
  static const String _service = '${_mApi}sr/';
  static const String _invoice = '${_mApi}inv/';
  static const String _payIn = '${_mApi}pay/';
  static const String _trans = '${_mApi}trans/';
  static const String _item = '${_mApi}item/';
  static const String _business = '${_mApi}biz/';
  static const String _user = '${_mApi}user/';
  // static const String _pref = '${_mApi}biz-pref/';

  static String registerUser = '${_mPub}reg-user';
  static String login = '${_mPub}login';
  static String checkUserExits = '${_mPub}check-user-exits';

  static String registerBusinessDetails = '${_mApi}biz/reg-biz';
  static String updateBusinessDetails = '${_mApi}biz/update';
  static String getPref = '${_mApi}biz-pref';

  static String getUnits = '${_mApi}units';
  static String getGstRates = '${_mApi}gstrates';
  static String getState = '${_mApi}states';
  static String getCities = '${_mApi}cities';
  static String getCategories = '${_item}cat';

  /// customer apis
  static String getAllCustomerList = '${_cust}get/all';
  static String addCustomer = '${_cust}add';
  static String updateCustomer = '${_cust}update';
  static String deleteCustomer = '${_cust}delete';
  static String getCustomerDetails = '${_cust}get';

  /// products apis
  static String getAllProducts = '${_product}all';
  static String addProducts = '${_product}add';
  static String updateProducts = '${_product}update';
  static String deleteProducts = '${_product}delete';
  static String getProductDetails = '${_product}get';

  /// service apis
  static String getAllServices = '${_service}all';
  static String addServices = '${_service}add';
  static String updateServices = '${_service}update';
  static String deleteServices = '${_service}delete';
  static String getServicesDetails = '${_service}get';

  /// summary apis
  static String getCustomerSummaryDetails = '${_cust}get/summary';

  /// invoice apis
  static String getInvoiceDetails = '${_invoice}get';
  static String generateInvoice = '${_invoice}create';
  static String cancelInvoice = '${_invoice}cancel';
  static String updateInvoice = '${_invoice}update';
  static String downloadInvoice = '${_invoice}download';

  /// pay-in apis
  static String getPayIn = '${_payIn}get';
  static String cancelPayIn = '${_payIn}cancel';
  static String offlinePayIn = '${_payIn}offline';

  /// transaction apis
  static String getTrans = '${_trans}get';

  /// setting apis
  static String getBusinessDetails = '${_business}get';
  static String changePassword = '${_user}change-pwd';
  static String invoiceFormats = '${_invoice}formats';

  /// business plan apis
  static String getBusinessPlans = '${_mApi}biz-plan';

  /// forgot password api
  static String forgotPassword = '${_mPub}user/forgot-pwd';
}
