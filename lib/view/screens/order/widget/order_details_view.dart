import 'package:efood_table_booking/controller/order_controller.dart';
import 'package:efood_table_booking/controller/splash_controller.dart';
import 'package:efood_table_booking/data/model/response/order_details_model.dart';
import 'package:efood_table_booking/helper/price_converter.dart';
import 'package:efood_table_booking/util/dimensions.dart';
import 'package:efood_table_booking/util/styles.dart';
import 'package:efood_table_booking/view/base/custom_divider.dart';
import 'package:efood_table_booking/view/base/custom_loader.dart';
import 'package:efood_table_booking/view/screens/cart/widget/cart_detais.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderDetailsView extends StatelessWidget {
  const OrderDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(
      builder: (orderController) {

        return orderController.currentOrderDetails == null ? Center(child: CustomLoader(
            color: Theme.of(context).primaryColor
        )) : Builder(
          builder: (context) {
            double _itemsPrice = 0;
            double _discount = 0;
            double _tax = 0;
            double _addOnsPrice = 0;
            List<Details> _orderDetails = orderController.currentOrderDetails?.details ?? [];
            if(orderController.currentOrderDetails?.details != null) {
              for(Details orderDetails in _orderDetails) {
                _itemsPrice = _itemsPrice + (orderDetails.price! * orderDetails.quantity!.toInt());
                _discount = _discount + (orderDetails.discountOnProduct! * orderDetails.quantity!.toInt());
                _tax = _tax + (orderDetails.taxAmount! * orderDetails.quantity!.toInt());

              }
            }

            // double _subTotal = _itemsPrice + _tax + _addOns;
            double _total = _itemsPrice  - _discount  + _tax ;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
              child: Column(children: [
                Row(children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                         Column( children: [
                          Text('order_summary'.tr, style: robotoBold.copyWith(
                            fontSize: Dimensions.fontSizeLarge,color: Theme.of(context).primaryColor,
                          ),),
                          SizedBox(height: Dimensions.paddingSizeSmall,),

                          Text('${'order'.tr}# ${orderController.currentOrderDetails?.order?.id}', style: robotoBold.copyWith(
                            fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).textTheme.bodyText1!.color,
                          ),),

                        ],),


                        Text.rich(
                          TextSpan(children: [
                            TextSpan(
                              text: '${'table'.tr} ${
                                  Get.find<SplashController>().getTable(
                                    orderController.currentOrderDetails?.order?.tableId,
                                    branchId:  orderController.currentOrderDetails?.order?.branchId,
                                  )?.number
                              } |',
                              style: robotoMedium.copyWith(
                                fontSize: Dimensions.fontSizeLarge,color: Theme.of(context).textTheme.bodyText1!.color,
                              ),
                            ),

                            TextSpan(text: '${orderController.currentOrderDetails?.order?.numberOfPeople
                                ?? 'add'.tr} ${'people'.tr}',
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeLarge,color: Theme.of(context).textTheme.bodyText1!.color,
                              ),
                            ),

                          ],),

                        ),

                      ],
                    ),
                  ),


                ],),
                SizedBox(height: 40),


                Expanded(child: ListView.builder(
                    itemCount: orderController.currentOrderDetails?.details?.length,
                    itemBuilder: (context, index) {
                      late Details _details;
                      int a = 0;
                      if(orderController.currentOrderDetails?.details != null) {
                         _details = orderController.currentOrderDetails!.details![index];
                      }

                      String _addonsName = '';
                      Variations? _variations = orderController.currentOrderDetails?.details?[index].variation;

                      List<AddOns> _addons = _details.productDetails  == null
                          ? [] : _details.productDetails!.addOns == null
                          ? [] : _details.productDetails!.addOns!;
                      List _addQty = _details.addOnQtys ?? [];
                      List _ids = _details.addOnIds ?? [];


                      try{
                        for(AddOns addOn in _addons) {
                          if(_ids.contains(addOn.id)) {
                            _addonsName = _addonsName + ('${addOn.name} (${(_addQty[a])}), ');
                            _addOnsPrice = _addOnsPrice + (addOn.price! * _addQty[a]);
                            a++;
                          }
                        }

                      }catch(e) {

                      }


                      if(_addonsName.isNotEmpty) {
                       _addonsName = _addonsName.substring(0, _addonsName.length - 2);
                      }


                      return Column(
                        children: [

                          Row(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center, children: [
                            Expanded(flex: 3,child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_details.productDetails?.name ?? '' }',
                                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.titleLarge!.color!,),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: Dimensions.paddingSizeExtraSmall,),

                                Text('${PriceConverter.convertPrice(_details.productDetails!.price!)}',
                                  style: robotoRegular.copyWith(
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                                SizedBox(height: Dimensions.paddingSizeExtraSmall,),




                                if(_addonsName.isNotEmpty) Text('${'addons'.tr}: $_addonsName', style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor,
                                )),
                                SizedBox(height: Dimensions.paddingSizeExtraSmall,),

                                if(_variations != null)
                                  Text('${'variations'.tr}: ${_variations.type ?? ''}', style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor,
                                )),


                              ],
                            )),

                            Expanded(child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                              child: Text(
                                '${_details.quantity}', textAlign: TextAlign.center,
                                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.titleLarge!.color!),
                              ),
                            )),



                            Expanded(flex: 2,child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                              child: Text('${PriceConverter.convertPrice(
                                _details.price!  * _details.quantity!,
                              )}',
                                textAlign: TextAlign.end, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.titleLarge!.color!),
                                maxLines: 1,
                              ),
                            )),

                          ],),
                          SizedBox(height: Dimensions.paddingSizeSmall,),

                          Builder(
                              builder: (context) {
                                bool _render = false;
                                if(orderController.currentOrderDetails?.details != null) {
                                  _render = orderController.currentOrderDetails!.details!.isNotEmpty && orderController.currentOrderDetails!.details!.length == index +1;
                                }

                                return _render ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 50,),

                                    Text.rich(
                                      textAlign: TextAlign.start,
                                      maxLines: 2,
                                      TextSpan(children:  orderController.currentOrderDetails?.order?.orderNote != null  ? [

                                        TextSpan(
                                          text: 'note'.tr,
                                          style: robotoMedium.copyWith(
                                            fontSize: Dimensions.fontSizeLarge,color: Theme.of(context).textTheme.bodyText1!.color,
                                          ),
                                        ),

                                        TextSpan(text: ' ${orderController.currentOrderDetails?.order?.orderNote ?? ''}',
                                          style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeLarge,
                                            color: Theme.of(context).textTheme.bodyText1!.color,
                                              overflow: TextOverflow.ellipsis
                                          ),
                                        ),

                                      ] : [
                                      ],),

                                    ),



                                    SizedBox(height: Dimensions.paddingSizeDefault,),

                                    CustomDivider(color: Theme.of(context).disabledColor,),
                                    SizedBox(height: Dimensions.paddingSizeDefault,),

                                    PriceWithType(type: 'items_price'.tr,amount: PriceConverter.convertPrice(_itemsPrice),),
                                    PriceWithType(type:'discount'.tr,amount: '- ${PriceConverter.convertPrice(_discount)}'),
                                    PriceWithType(type: 'vat_tax'.tr, amount :'+ ${PriceConverter.convertPrice(_tax)}'),
                                    PriceWithType(type: 'addons'.tr, amount :'+ ${PriceConverter.convertPrice(_addOnsPrice)}'),
                                    PriceWithType(type:'total'.tr,amount : PriceConverter.convertPrice(_total + _addOnsPrice), isTotal: true),

                                    PriceWithType(
                                      type:  '${'paid_amount'.tr}${orderController.currentOrderDetails?.order?.paymentMethod != null ?
                                      //'(${orderController.currentOrderDetails?.order?.paymentMethod})' : ' (${'un_paid'.tr}) '}',
                                      '(${orderController.currentOrderDetails?.order?.paymentMethod})' : ''}',
                                      amount : PriceConverter.convertPrice(
                                        orderController.currentOrderDetails?.order?.paymentStatus != 'unpaid' ?
                                          orderController.currentOrderDetails?.order?.orderAmount ?? 0 : 0),
                                    ),

                                    PriceWithType(type:'change'.tr,
                                      amount : PriceConverter.convertPrice(orderController.getOrderSuccessModel()?.firstWhere((order) =>
                                      order.orderId == orderController.currentOrderDetails?.order?.id.toString()).changeAmount ?? 0),
                                    ),

                                    SizedBox(height: Dimensions.paddingSizeDefault,),
                                  ],
                                ):
                                Column(children: [
                                  CustomDivider(color: Theme.of(context).disabledColor),
                                  SizedBox(height: Dimensions.paddingSizeSmall,),
                                ],);
                              }
                          ),

                        ],
                      );
                    }
                ),),
              ],),
            );
          }
        );
      }
    );
  }
}
