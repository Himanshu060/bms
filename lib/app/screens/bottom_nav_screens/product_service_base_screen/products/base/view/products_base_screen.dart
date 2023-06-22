import 'package:bms/app/common/app_constants.dart';
import 'package:bms/app/common/color_constants.dart';
import 'package:bms/app/common/image_constants.dart';
import 'package:bms/app/screens/bottom_nav_screens/product_service_base_screen/products/base/controller/products_base_controller.dart';
import 'package:bms/app/utils/number_formatter/number_formatter.dart';
import 'package:bms/app/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ProductsBaseScreen extends GetView<ProductsBaseController> {
  ProductsBaseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return controller.isProductDataLoading.value
          ? Container()
          : controller.appliedFilterProductDataList.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(kImgItemsEmptyGraphic),
                    const Text(kNoProductsFound,
                        style: TextStyles.kTextH14MainGreyBold400),
                  ],
                )
              : ListView.builder(
                  itemCount: controller.searchProductName.isNotEmpty
                      ? controller.searchProductDataList.length
                      : controller.appliedFilterProductDataList.length,
                  padding: const EdgeInsets.only(bottom: 6),
                  itemBuilder: (context, index) {
                    var productData = controller.searchProductName.isNotEmpty
                        ? controller.searchProductDataList[index]
                        : controller.appliedFilterProductDataList[index];
                    return GestureDetector(
                      onTap: () {
                        controller.navigateToEditProductScreen(index: index);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 3), // h-10
                        padding: const EdgeInsets.only(
                            top: 8, bottom: 14, left: 11, right: 14),
                        decoration: BoxDecoration(
                          border: Border.all(color: kColorLightGrey),
                        ),
                        child: Column(
                          children: [
                            /// product name and product type
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(productData.name ?? '',
                                    style:
                                        TextStyles.kTextH14DarkGrey3535Bold600),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 1),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: kColorGreyD8,
                                    ),
                                  ),
                                  child: Text(controller.returnCategoryName(index: index),
                                      style: TextStyles.kTextH12Grey8DBold500),
                                ),
                              ],
                            ),

                            /// selling price and unit
                            Padding(
                              padding: const EdgeInsets.only(top: 11),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(
                                            text: kLabelSellingPriceWithColon,
                                            style: TextStyles
                                                .kTextH12Grey8DBold500),
                                        TextSpan(
                                            text:
                                            ' $kRupee${returnFormattedNumber(values: double.parse(productData.sellPrice?.toStringAsFixed(2)??''))}',
                                            style: TextStyles
                                                .kTextH14DarkGrey3535Bold600),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(
                                            text: kLabelUnitWithColon,
                                            style: TextStyles
                                                .kTextH12Grey8DBold500),
                                        TextSpan(
                                            text: controller.returnUnitName(
                                                index: index),
                                            style: TextStyles
                                                .kTextH14DarkGrey3535Bold600),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
    });
  }
}
