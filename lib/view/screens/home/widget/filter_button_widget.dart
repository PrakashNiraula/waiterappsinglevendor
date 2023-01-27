import 'package:efood_table_booking/controller/localization_controller.dart';
import 'package:efood_table_booking/controller/product_controller.dart';
import 'package:efood_table_booking/helper/responsive_helper.dart';
import 'package:efood_table_booking/util/dimensions.dart';
import 'package:efood_table_booking/util/images.dart';
import 'package:efood_table_booking/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterButtonWidget extends StatelessWidget {
  final String type;
  final List<String> items;
  final bool isBorder;
  final bool isSmall;
  final Function(String value) onSelected;

  FilterButtonWidget({
    required this.type, required this.onSelected, required this.items,  this.isBorder = false, this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool _ltr = Get.find<LocalizationController>().isLtr;
    bool _isVegFilter = Get.find<ProductController>().productTypeList == items;

    return  Align(alignment: Alignment.center, child: Container(
      height:  ResponsiveHelper.isSmallTab() ? 35 : ResponsiveHelper.isTab(context) ?  50 : 40,
      margin: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
      decoration: isBorder ? null : BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(Dimensions.RADIUS_SMALL)),
        border: Border.all(color: Theme.of(context).primaryColor),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => onSelected(items[index]),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              margin: isBorder ? EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall) : EdgeInsets.zero,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: isBorder ? BorderRadius.all(Radius.circular(Dimensions.RADIUS_SMALL)) : BorderRadius.horizontal(
                  left: Radius.circular(
                    _ltr ? index == 0 && items[index] != type ? Dimensions.RADIUS_SMALL : 0
                        : index == items.length-1
                        ? Dimensions.RADIUS_SMALL : 0,
                  ),
                  right: Radius.circular(
                    _ltr ? index == items.length-1 &&  items[index] != type
                        ? Dimensions.RADIUS_SMALL : 0 : index == 0
                        ? Dimensions.RADIUS_SMALL : 0,
                  ),
                ),
                color: items[index] == type ? Theme.of(context).primaryColor
                    : Theme.of(context).canvasColor,

              border: isBorder ?  Border.all(width: 1.3, color: Theme.of(context).primaryColor.withOpacity(0.4)) : null ,
              ),
              child: Row(
                children: [
                  items[index] != items[0] && _isVegFilter ? Padding(
                    padding: EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    child: Image.asset(
                      Images.getImageUrl(items[index]),
                    ),
                  ) : SizedBox(),
                  Text(
                    items[index].tr,
                    style: items[index] == type
                        ? robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Colors.white)
                        : robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),
                  ),

                ],
              ),
            ),
          );
        },
      ),
    ));
  }
}

