import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/color_constants.dart';
import 'package:bms/app/common/controller_bindings.dart';
import 'package:bms/app/common/route_constants.dart';
import 'package:bms/app/screens/authentication/business_sign_up/view/business_sign_up_screen.dart';
import 'package:bms/app/screens/authentication/forgot_password/view/forgot_password_screen.dart';
import 'package:bms/app/screens/authentication/login/view/login_screen.dart';
import 'package:bms/app/screens/authentication/user_sign_up/view/user_sign_up_screen.dart';
import 'package:bms/app/screens/authentication/verify_otp/view/verify_otp_screen.dart';
import 'package:bms/app/screens/bottom_nav_screens/customer_base_screen/add_customer/view/add_customer_screen.dart';
import 'package:bms/app/screens/bottom_nav_screens/customer_base_screen/edit_customer/view/edit_customer_screen.dart';
import 'package:bms/app/screens/bottom_nav_screens/customer_base_screen/import_device_contacts/view/import_device_contacts_screen.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/generate_invoice_with_customer_selection/view/generate_invoice_with_customer_selection.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/base/view/invoice_quotation_listing_screen.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/invoice/generate_invoice/view/generate_invoice_screen.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/invoice/pay_in/view/invoice_pay_in_screen.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/invoice/preview_invoice_pdf/view/preview_inv_pdf_screen.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/invoice/search_items/view/search_items_screen.dart';
import 'package:bms/app/screens/bottom_nav_screens/invoice_base_screen/invoice_quotation_listing_screen/invoice/view_invoice/view/view_invoice_screen.dart';
import 'package:bms/app/screens/bottom_nav_screens/product_service_base_screen/add_product_service_tab_screen/view/add_product_service_tab_screen.dart';
import 'package:bms/app/screens/bottom_nav_screens/product_service_base_screen/products/edit_product/view/edit_product_screen.dart';
import 'package:bms/app/screens/bottom_nav_screens/product_service_base_screen/services/edit_service/view/edit_service_screen.dart';
import 'package:bms/app/screens/bottom_nav_screens/settings_base_screen/change_password/view/change_password_screen.dart';
import 'package:bms/app/screens/bottom_nav_screens/settings_base_screen/edit_business_details/view/edit_business_details_screen.dart';
import 'package:bms/app/screens/bottom_nav_screens/settings_base_screen/preference/base/view/pref_base_screen.dart';
import 'package:bms/app/screens/bottom_nav_screens/settings_base_screen/preference/date_formats/view/date_formats_screen.dart';
import 'package:bms/app/screens/bottom_nav_screens/settings_base_screen/preference/invoice_format/base/view/invoice_formats_screen.dart';
import 'package:bms/app/screens/bottom_nav_screens/settings_base_screen/preference/invoice_format/view_inv_format/view/view_inv_format_screen.dart';
import 'package:bms/app/screens/bottom_navigation/base/view/bottom_nav_base_screen.dart';
import 'package:bms/app/screens/splash/splash_screen_new.dart';
import 'package:bms/app/screens/splash/view/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

Future<void> main() async {

  /// firebase initialization
  WidgetsFlutterBinding.ensureInitialized();
  /// initialize firebase object
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: kColorBlack, // status bar color
  ));
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: appName,
      initialBinding: ControllerBindings(),
      home: SplashScreenNew(),
      debugShowCheckedModeBanner: false,
      smartManagement: SmartManagement.full,
      theme: ThemeData(
        textSelectionTheme:
            const TextSelectionThemeData(cursorColor: kColorPrimary),
        dividerColor: Colors.transparent,
      ),
      routingCallback: (value) {
        AppConstants().currentRoute = value?.current ?? '';
        debugPrint(' ############# routing callback : ${value?.current}');
      },
      getPages: [
        GetPage(
          name: kRouteSplashScreen,
          page: () => SplashScreen(),
        ),
        GetPage(
          name: kRouteSplashScreenNew,
          page: () => SplashScreenNew(),
        ),
        GetPage(
          name: kRouteLoginScreen,
          page: () => LoginScreen(),
        ),
        GetPage(
          name: kRouteForgotPasswordScreen,
          page: () => ForgotPasswordScreen(),
        ),
        GetPage(
          name: kRouteBusinessSignUpScreen,
          page: () => BusinessSignUpScreen(),
        ),
        GetPage(
          name: kRouteUserSignUpScreen,
          page: () => UserSignUpScreen(),
        ),
        GetPage(
          name: kRouteVerifyOtpScreen,
          page: () => VerifyOtpScreen(),
        ),
        GetPage(
          name: kRouteEditCustomerScreen,
          page: () => EditCustomerScreen(),
        ),
        GetPage(
          name: kRouteBottomNavBaseScreen,
          page: () => BottomNavBaseScreen(),
        ),
        GetPage(
          name: kRouteAddCustomerScreen,
          page: () => AddCustomerScreen(),
        ),
        GetPage(
          name: kRouteImportDeviceContactsScreen,
          page: () => ImportDeviceContactsScreen(),
        ),
        GetPage(
          name: kRouteEditProductScreen,
          page: () => EditProductScreen(),
        ),
        GetPage(
          name: kRouteEditServiceScreen,
          page: () => EditServiceScreen(),
        ),
        GetPage(
          name: kRouteAddProductServiceTabScreen,
          page: () => AddProductServiceTabScreen(),
        ),
        GetPage(
          name: kRouteInvoiceQuotationListingScreen,
          page: () => InvoiceQuotationListingScreen(),
        ),
        GetPage(
          name: kRouteInvoicePayInScreen,
          page: () => InvoicePayInScreen(),
        ),
        GetPage(
          name: kRouteViewInvoiceScreen,
          page: () => ViewInvoiceScreen(),
        ),
        GetPage(
          name: kRoutePreviewInvPdfScreen,
          page: () => PreviewInvPdfScreen(),
        ),
        GetPage(
          name: kRouteGenerateInvoiceScreen,
          page: () => GenerateInvoiceScreen(),
        ),
        GetPage(
          name: kRouteSearchItemsScreen,
          page: () => SearchItemsScreen(),
        ),
        GetPage(
          name: kRouteGenerateInvoiceWithCustomerSelection,
          page: () => GenerateInvoiceWithCustomerSelection(),
        ),
        GetPage(
          name: kRouteEditBusinessDetailsScreen,
          page: () => EditBusinessDetailsScreen(),
        ),
        GetPage(
          name: kRouteChangePasswordScreen,
          page: () => ChangePasswordScreen(),
        ),
        GetPage(
          name: kRoutePrefBaseScreen,
          page: () => PrefBaseScreen(),
        ),
        GetPage(
          name: kRouteInvoiceFormatsScreen,
          page: () => InvoiceFormatsScreen(),
        ),
        GetPage(
          name: kRouteViewInvFormatScreen,
          page: () => ViewInvFormatScreen(),
        ),
        GetPage(
          name: kRouteDateFormatsScreen,
          page: () => DateFormatsScreen(),
        ),
      ],
    );
  }
}
