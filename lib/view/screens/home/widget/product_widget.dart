import 'package:efood_table_booking/controller/cart_controller.dart';
import 'package:efood_table_booking/controller/product_controller.dart';
import 'package:efood_table_booking/controller/splash_controller.dart';
import 'package:efood_table_booking/data/model/response/product_model.dart';
import 'package:efood_table_booking/helper/price_converter.dart';
import 'package:efood_table_booking/helper/route_helper.dart';
import 'package:efood_table_booking/util/dimensions.dart';
import 'package:efood_table_booking/util/styles.dart';
import 'package:efood_table_booking/view/base/custom_image.dart';
import 'package:efood_table_booking/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:efood_table_booking/view/screens/home/widget/price_stack_tag.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';



class ProductWidget extends StatefulWidget {
  final Product product;

  ProductWidget({required this.product,});

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {

  @override
  Widget build(BuildContext context) {


    return GetBuilder<CartController>(builder: (_cartController) {

        return GetBuilder<ProductController>(builder: (productController) {
          late int _cartIndex;

          DateTime _currentTime = Get.find<SplashController>().currentTime;
          DateTime _start = DateFormat('hh:mm:ss').parse(widget.product.availableTimeStarts!);
          DateTime _end = DateFormat('hh:mm:ss').parse(widget.product.availableTimeEnds!);
          DateTime _startTime =
          DateTime(_currentTime.year, _currentTime.month, _currentTime.day, _start.hour, _start.minute, _start.second);
          DateTime _endTime = DateTime(_currentTime.year, _currentTime.month, _currentTime.day, _end.hour, _end.minute, _end.second);
          if (_endTime.isBefore(_startTime)) {
            _endTime = _endTime.add(Duration(days: 1));
          }
          bool _isAvailable = _currentTime.isAfter(_startTime) && _currentTime.isBefore(_endTime);


          _cartIndex = _cartController.getCartIndex(widget.product.id!);



          return InkWell(
            onTap:() => RouteHelper.openDialog(context, ProductBottomSheet(
              product: widget.product,
              cartIndex: _cartIndex != -1 ? _cartIndex : null,),
            ),
            child: Stack(
              children: [

                Container(
                  decoration: BoxDecoration(
                    color: _cartIndex != -1 ? Theme.of(context).primaryColor : Theme.of(context).cardColor, borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color:  _cartIndex != -1 ? Theme.of(context).primaryColor.withOpacity(0.1) :Get.isDarkMode ?  Theme.of(context).cardColor.withOpacity(0.1) : Colors.black.withOpacity(0.1),
                        offset: Offset(0, 3.75), blurRadius: 9.29,
                      )
                    ],
                  ),
                  child: Column(
                      children: [

                        SizedBox(height: 3),

                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                              child: Text(widget.product.name ?? '', style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeLarge,
                                color: _cartIndex != -1 ? Colors.white : Theme.of(context).textTheme.titleLarge!.color,
                              ),
                                  maxLines: 2, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 3),

                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                            child: Stack(
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                      child: CustomImage(
                                        height: double.infinity, width: double.infinity,
                                        image: '${Get.find<SplashController>().configModel?.baseUrls?.productImageUrl}/${widget.product.image}',
                                        fit: BoxFit.cover,
                                      ),
                                    ),

                                    if(_cartIndex != -1) Positioned(
                                      child: Container(
                                        width: double.infinity, height: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.3),
                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                        ),

                                        padding: EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),

                                        child: Center(
                                          child: Text('${'qty'.tr} : ${_cartController.cartList[_cartIndex].quantity}',
                                            style: robotoBold.copyWith(
                                              fontSize: Dimensions.fontSizeLarge, color: Colors.white,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),

                                    PriceStackTag(value: PriceConverter.convertPrice(double.parse('${widget.product.price ?? '0'}')),)
                                  ],
                                ),


                              ],
                            ),
                          ),
                        ),



                      ]),
                ),

               if(!_isAvailable)  Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all( Radius.circular(5),
                    ),
                    color: Colors.black.withOpacity(0.7),
                    // color:Theme.of(context).textTheme.bodyText1?.color?.withOpacity(0.7),
                    boxShadow: [BoxShadow(
                      // color: Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.1),
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 9.23,
                      offset: Offset(0,3.71),
                    )],
                  ),
                  child: Center(child: Text(
                    'not_available'.tr.replaceAll(' ', '\n'), style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Colors.white,),
                    textAlign: TextAlign.center,
                  )),
                ),
              ],
            ),
          );

        });
      }
    );
  }
}



