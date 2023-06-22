import 'package:bms/app/common/base_controller.dart';
import 'package:bms/app/screens/authentication/business_sign_up/controller/business_sign_up_controller.dart';
import 'package:bms/app/screens/authentication/forgot_password/controller/forgot_password_controller.dart';
import 'package:bms/app/screens/authentication/login/controller/login_controller.dart';
import 'package:bms/app/screens/authentication/user_sign_up/controller/user_sign_up_controller.dart';
import 'package:bms/app/screens/authentication/verify_otp/controller/verify_otp_controller.dart';
import 'package:bms/app/screens/bottom_nav_screens/customer_base_screen/add_customer/controller/add_customer_controller.dart';
import 'package:bms/app/screens/bottom_nav_screens/customer_base_screen/base/controller/customer_base_controller.dart';
import 'package:bms/app/screens/bottom_nav_screens/customer_base_screen/edit_customer/controller/edit_customer_controller.dart';
import 'package:bms/app/screens/bottom_nav_screens/customer_base_screen/import_device_contacts/controller/import_device_contacts_controller.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/base/controller/invoice_base_controller.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/generate_invoice_with_customer_selection/controller/generate_invoice_with_customer_selection_controller.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/base/controller/invoice_quotation_listing_controller.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/invoice/base/controller/invoice_listing_controller.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/invoice/generate_invoice/controller/generate_invoice_controller.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/invoice/pay_in/controller/invoice_pay_in_controller.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/invoice/preview_invoice_pdf/controller/preview_inv_pdf_controller.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/invoice/search_items/controller/search_items_controller.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/invoice/view_invoice/controller/view_invoice_controller.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/quotation/base/controller/quotation_listing_controller.dart';
import 'package:bms/app/screens/bottom_nav_screens/product_service_base_screen/add_product_service_tab_screen/controller/add_product_service_tab_controller.dart';
import 'package:bms/app/screens/bottom_nav_screens/product_service_base_screen/base/controller/product_service_base_controller.dart';
import 'package:bms/app/screens/bottom_nav_screens/product_service_base_screen/products/add_product/controller/add_product_controller.dart';
import 'package:bms/app/screens/bottom_nav_screens/product_service_base_screen/products/base/controller/products_base_controller.dart';
import 'package:bms/app/screens/bottom_nav_screens/product_service_base_screen/products/edit_product/controller/edit_product_controller.dart';
import 'package:bms/app/screens/bottom_nav_screens/product_service_base_screen/services/add_service/controller/add_service_controller.dart';
import 'package:bms/app/screens/bottom_nav_screens/product_service_base_screen/services/base/controller/services_base_controller.dart';
import 'package:bms/app/screens/bottom_nav_screens/product_service_base_screen/services/edit_service/controller/edit_service_controller.dart';
import 'package:bms/app/screens/bottom_nav_screens/settings_base_screen/base/controller/settings_base_controller.dart';
import 'package:bms/app/screens/bottom_nav_screens/settings_base_screen/change_password/controller/change_password_controller.dart';
import 'package:bms/app/screens/bottom_nav_screens/settings_base_screen/edit_business_details/controller/edit_business_details_controller.dart';
import 'package:bms/app/screens/bottom_nav_screens/settings_base_screen/preference/base/controller/pref_base_controller.dart';
import 'package:bms/app/screens/bottom_nav_screens/settings_base_screen/preference/date_formats/controller/date_formats_controller.dart';
import 'package:bms/app/screens/bottom_nav_screens/settings_base_screen/preference/invoice_format/base/controller/invoice_formats_controller.dart';
import 'package:bms/app/screens/bottom_nav_screens/settings_base_screen/preference/invoice_format/view_inv_format/controller/view_inv_format_controller.dart';
import 'package:bms/app/screens/bottom_navigation/base/controller/bottom_nav_base_controller.dart';
import 'package:bms/app/screens/splash/controller/splash_controller.dart';
import 'package:bms/app/utils/local_storage.dart';
import 'package:get/get.dart';

class ControllerBindings implements Bindings {
  @override
  void dependencies() {
    /// controller that will not cleared from memory until app is live.
    Get.put<BaseController>(
      BaseController(),
      permanent: true,
    );

    Get.put<LocalStorage>(
      LocalStorage(),
      permanent: true,
    );

    Get.lazyPut<SplashController>(
      () => SplashController(),
      fenix: true,
    );
    Get.lazyPut<LoginController>(
      () => LoginController(),
      fenix: true,
    );
    Get.lazyPut<ForgotPasswordController>(
      () => ForgotPasswordController(),
      fenix: true,
    );
    Get.lazyPut<BusinessSignUpController>(
      () => BusinessSignUpController(),
      fenix: true,
    );
    Get.lazyPut<UserSignUpController>(
      () => UserSignUpController(),
      fenix: true,
    );
    Get.lazyPut<VerifyOtpController>(
      () => VerifyOtpController(),
      fenix: true,
    );
    Get.lazyPut<BottomNavBaseController>(
      () => BottomNavBaseController(),
      fenix: true,
    );
    Get.lazyPut<CustomerBaseController>(
      () => CustomerBaseController(),
      fenix: true,
    );
    Get.lazyPut<AddCustomerController>(
      () => AddCustomerController(),
      fenix: true,
    );
    Get.lazyPut<ImportDeviceContactsController>(
      () => ImportDeviceContactsController(),
      fenix: true,
    );
    Get.lazyPut<EditCustomerController>(
      () => EditCustomerController(),
      fenix: true,
    );
    Get.lazyPut<ProductServiceBaseController>(
      () => ProductServiceBaseController(),
      fenix: true,
    );
    Get.lazyPut<ServicesBaseController>(
      () => ServicesBaseController(),
      fenix: true,
    );
    Get.lazyPut<ProductsBaseController>(
      () => ProductsBaseController(),
      fenix: true,
    );
    Get.lazyPut<AddProductServiceTabController>(
      () => AddProductServiceTabController(),
      fenix: true,
    );
    Get.lazyPut<AddServiceController>(
      () => AddServiceController(),
      fenix: true,
    );
    Get.lazyPut<AddProductController>(
      () => AddProductController(),
      fenix: true,
    );
    Get.lazyPut<EditProductController>(
      () => EditProductController(),
      fenix: true,
    );
    Get.lazyPut<EditServiceController>(
      () => EditServiceController(),
      fenix: true,
    );
    Get.lazyPut<InvoiceQuotationListingController>(
      () => InvoiceQuotationListingController(),
      fenix: true,
    );
    Get.lazyPut<QuotationListingController>(
      () => QuotationListingController(),
      fenix: true,
    );
    Get.lazyPut<InvoiceListingController>(
      () => InvoiceListingController(),
      fenix: true,
    );
    Get.lazyPut<InvoicePayInController>(
      () => InvoicePayInController(),
      fenix: true,
    );
    Get.lazyPut<ViewInvoiceController>(
      () => ViewInvoiceController(),
      fenix: true,
    );
    Get.lazyPut<PreviewInvPdfController>(
      () => PreviewInvPdfController(),
      fenix: true,
    );
    Get.lazyPut<GenerateInvoiceController>(
      () => GenerateInvoiceController(),
      fenix: true,
    );
    Get.lazyPut<SearchItemsController>(
      () => SearchItemsController(),
      fenix: true,
    );
    Get.lazyPut<InvoiceBaseController>(
      () => InvoiceBaseController(),
      fenix: true,
    );
    Get.lazyPut<GenerateInvoiceWithCustomerSelectionController>(
      () => GenerateInvoiceWithCustomerSelectionController(),
      fenix: true,
    );
    Get.lazyPut<SettingsBaseController>(
      () => SettingsBaseController(),
      fenix: true,
    );
    Get.lazyPut<EditBusinessDetailsController>(
      () => EditBusinessDetailsController(),
      fenix: true,
    );
    Get.lazyPut<ChangePasswordController>(
      () => ChangePasswordController(),
      fenix: true,
    );
    Get.lazyPut<PrefBaseController>(
      () => PrefBaseController(),
      fenix: true,
    );
    Get.lazyPut<InvoiceFormatsController>(
      () => InvoiceFormatsController(),
      fenix: true,
    );
    Get.lazyPut<ViewInvFormatController>(
      () => ViewInvFormatController(),
      fenix: true,
    );
    Get.lazyPut<DateFormatsController>(
      () => DateFormatsController(),
      fenix: true,
    );
  }
}
