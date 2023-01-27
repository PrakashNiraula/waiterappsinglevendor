import 'package:efood_table_booking/controller/cart_controller.dart';
import 'package:efood_table_booking/controller/order_controller.dart';
import 'package:efood_table_booking/controller/splash_controller.dart';
import 'package:efood_table_booking/data/model/response/cart_model.dart';
import 'package:efood_table_booking/data/model/response/place_order_body.dart';
import 'package:efood_table_booking/data/model/response/product_model.dart';
import 'package:efood_table_booking/helper/date_converter.dart';
import 'package:efood_table_booking/helper/price_converter.dart';
import 'package:efood_table_booking/helper/responsive_helper.dart';
import 'package:efood_table_booking/helper/route_helper.dart';
import 'package:efood_table_booking/util/dimensions.dart';
import 'package:efood_table_booking/util/images.dart';
import 'package:efood_table_booking/util/styles.dart';
import 'package:efood_table_booking/view/base/confirmation_dialog.dart';
import 'package:efood_table_booking/view/base/custom_button.dart';
import 'package:efood_table_booking/view/base/custom_divider.dart';
import 'package:efood_table_booking/view/base/custom_snackbar.dart';
import 'package:efood_table_booking/view/screens/cart/widget/order_note_view.dart';
import 'package:efood_table_booking/view/screens/cart/widget/table_input_view.dart';
import 'package:efood_table_booking/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:efood_table_booking/view/screens/order/payment_screen.dart';
import 'package:efood_table_booking/view/screens/root/no_data_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CartDetails extends StatelessWidget {
  final bool showButton;
  CartDetails({
    Key? key, required this.showButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return ResponsiveHelper.isTab(context) ? Expanded(
      child: _body(context),
    ) : _body(context);
  }
  Widget _body(BuildContext context){
    // bool _isPortrait = context.height < context.width;
    return Padding(
      padding:  EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSizeLarge,
        vertical: Dimensions.paddingSizeDefault,
      ),
      child: GetBuilder<SplashController>(builder: (splashController) {
          return GetBuilder<OrderController>(builder: (orderController) {
              return GetBuilder<CartController>(builder: (cartController) {
                DateTime _dateTime  = DateTime.now();
                List<List<AddOn>> _addOnsList = [];
                List<bool> _availableList = [];
                double _itemPrice = 0;
                double _discount = 0;
                double _tax = 0;
                double _addOns = 0;
                final orderController =  Get.find<OrderController>();

                List<CartModel> _cartList = cartController.cartList;







                _cartList.forEach((cartModel) {

                  List<AddOn> _addOnList = [];
                  cartModel.addOnIds?.forEach((addOnId) {
                    if(cartModel.product != null && cartModel.product?.addOns! != null) {
                      for(AddOn addOns in cartModel.product!.addOns!) {
                        if(addOns.id == addOnId.id) {
                          _addOnList.add(addOns);
                          break;
                        }
                      }
                    }
                  });
                  _addOnsList.add(_addOnList);

                  _availableList.add(DateConverter.isAvailable(cartModel.product?.availableTimeStarts, cartModel.product?.availableTimeEnds));

                  for(int index=0; index<_addOnList.length; index++) {
                    _addOns = _addOns + (_addOnList[index].price! * cartModel.addOnIds![index].quantity!.toDouble());
                  }
                  _itemPrice = _itemPrice + (cartModel.price! * cartModel.quantity!);
                  _discount = _discount + (cartModel.discountAmount! * cartModel.quantity!.toDouble());
                  _tax = _tax + (cartModel.taxAmount! * cartModel.quantity!.toDouble());
                });
                // double _subTotal = _itemPrice + _tax + _addOns;
                double _total = _itemPrice - _discount + orderController.previousDueAmount() + _tax + _addOns;

                cartController.setTotalAmount = _total;
                return _cartList.isEmpty ? NoDataScreen(text: 'please_add_food_to_order'.tr) : Column(
                  children: [

                    Row(children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            splashController.getTable(splashController.getTableId())?.number == null ?
                            Center(
                              child: Text('add_table_number'.tr, style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).secondaryHeaderColor,
                              ),),
                            ) :

                            Text.rich(
                              TextSpan(children: [
                                TextSpan(
                                  text: '${'table'.tr} ${splashController.getTable(splashController.getTableId())?.number } | ',
                                  style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeLarge,color: Theme.of(context).textTheme.bodyText1!.color,
                                  ),
                                ),

                                TextSpan(text: '${cartController.peopleNumber ?? 'add'.tr} ${'people'.tr}',
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeLarge,color: Theme.of(context).textTheme.bodyText1!.color,
                                  ),
                                ),

                              ],),

                            ),

                          ],
                        ),
                      ),

                      InkWell(
                        onTap: (){
                          RouteHelper.openDialog(context, TableInputView(),);
                        },

                        child: Image.asset(
                          Images.edit_icon,
                          color: Theme.of(context).secondaryHeaderColor,
                          width: Dimensions.paddingSizeExtraLarge,
                        ),
                      )
                    ],),
                    SizedBox(height: ResponsiveHelper.isSmallTab() ? 20 : 40),


                    Expanded(child: ListView.builder(
                        itemCount: _cartList.length,
                        itemBuilder: (context, index) {
                          CartModel _cart = _cartList[index];

                          String? _variationText = '';
                          String _addonsName = '';
                          if(_cart.variation != null && _cart.variation!.length > 0 ) {
                            List<String> _variationTypes = _cart.variation![0].type !=
                                null ? _cart.variation![0].type!.split('-') : [];
                            if (_variationTypes.length ==
                                _cart.product?.choiceOptions!.length) {
                              int _index = 0;
                              _cart.product?.choiceOptions?.forEach((choice) {
                                _variationText = '$_variationText' +
                                    '${(_index == 0) ? '' : ',  '}${choice
                                        .title} - ${_variationTypes[_index]}';
                                _index = _index + 1;
                              });
                            } else {
                              _variationText = _cart.product?.variations?[0].type;
                            }


                            _cart.addOnIds?.forEach((addOn) {
                              _addonsName = _addonsName + '${addOn.name} (${addOn.quantity}), ';
                            });
                            if(_addonsName.isNotEmpty) {
                             _addonsName = _addonsName.substring(0, _addonsName.length -2);
                            }
                          }

                          return InkWell(
                            onTap:() => RouteHelper.openDialog(context, ProductBottomSheet(
                              product: _cart.product!,
                              cart: _cart,
                              cartIndex: index,
                            ),
                            ),
                            child: Column(
                              children: [

                                Row(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center, children: [
                                  Expanded(flex: 5,child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${_cart.product!.name ?? '' } ${_variationText != null && _variationText!.isNotEmpty ? '($_variationText)' : ''}',
                                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.titleLarge!.color!,),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: Dimensions.paddingSizeExtraSmall,),

                                      Text('${PriceConverter.convertPrice(_cart.discountedPrice ?? 0)}',
                                        style: robotoRegular.copyWith(
                                          color: Theme.of(context).hintColor,
                                        ),
                                      ),
                                      SizedBox(height: Dimensions.paddingSizeExtraSmall,),


                                     if(_addonsName.isNotEmpty) Text('${'addons'.tr}: $_addonsName', style: robotoRegular.copyWith(
                                       fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor,
                                     )),


                                    ],
                                  )),

                                  Expanded(child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                                    child: Text(
                                      '${_cart.quantity}', textAlign: TextAlign.center,
                                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.titleLarge!.color!),
                                    ),
                                  )),



                                  Expanded(flex: 2,child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                                    child: Text('${PriceConverter.convertPrice(
                                       _cart.price!  * _cart.quantity!,
                                    )}',
                                      textAlign: TextAlign.end, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.titleLarge!.color!),
                                      maxLines: 1,
                                    ),
                                  )),

                                  Expanded(child: IconButton(
                                    onPressed: (){
                                      cartController.removeFromCart(index);
                                      showCustomSnackBar('cart_item_delete_successfully'.tr, isError: false);
                                    },
                                    icon: Icon(Icons.delete, color: Theme.of(context).errorColor),
                                    alignment: Alignment.topRight,
                                    padding: EdgeInsets.zero,
                                    iconSize: Dimensions.paddingSizeLarge,
                                  )),
                                ],),
                                SizedBox(height: Dimensions.paddingSizeSmall,),

                                Builder(
                                  builder: (context) {
                                    bool _render = false;
                                    _render = _cartList.isNotEmpty && _cartList.length == index + 1;
                                    return !_render ?
                                    Column(children: [
                                      CustomDivider(color: Theme.of(context).disabledColor),
                                      SizedBox(height: Dimensions.paddingSizeSmall,),
                                    ],) : ResponsiveHelper.isSmallTab() ? _calculationView(
                                      context, _itemPrice,
                                      _discount, _tax, _addOns,
                                      orderController, _total,
                                    ): SizedBox();
                                  }
                                ),

                              ],
                            ),
                          );
                        }
                    ),),

                    Column(
                      children: [

                        if(!ResponsiveHelper.isSmallTab() ) _calculationView(
                          context, _itemPrice,
                          _discount, _tax, _addOns,
                          orderController, _total,
                        ),

                        if(showButton) Row(
                          children: [
                            if(cartController.cartList.isNotEmpty) Expanded(child: CustomButton(
                              height: ResponsiveHelper.isSmallTab() ? 40 : 50,
                              transparent: true,
                              buttonText: 'clear_cart'.tr, onPressed: (){
                              RouteHelper.openDialog(
                                context, ConfirmationDialog(
                                title: '${'clear_cart'.tr} !',
                                icon: Icons.cleaning_services_rounded,
                                description: 'are_you_want_to_clear'.tr,
                                onYesPressed: (){
                                  cartController.clearCartData();
                                  Get.back();
                                },
                                onNoPressed: ()=> Get.back(),
                              ),
                              );

                              //cartController.clearCartData();
                            },)),

                            if(cartController.cartList.isNotEmpty) SizedBox(width: Dimensions.paddingSizeDefault,),

                            Expanded(
                              child: CustomButton(
                                height: ResponsiveHelper.isSmallTab() ? 40 : 50,
                                buttonText: 'place_order'.tr,
                                onPressed: (){

                                  if(splashController.getTableId() == -1) {
                                    showCustomSnackBar('please_input_table_number'.tr);
                                  }else if(cartController.peopleNumber == null) {
                                    showCustomSnackBar('please_enter_people_number'.tr);
                                  }else if(cartController.cartList.length < 1) {
                                    showCustomSnackBar('please_add_food_to_order'.tr);
                                  }else{
                                    List<Cart> carts = [];
                                    for (int index = 0; index < cartController.cartList.length; index++) {
                                      CartModel cart = cartController.cartList[index];
                                      List<int> _addOnIdList = [];
                                      List<int> _addOnQtyList = [];
                                      cart.addOnIds?.forEach((addOn) {
                                        _addOnIdList.add(addOn.id!);
                                        _addOnQtyList.add(addOn.quantity!);
                                      });
                                      carts.add(Cart(
                                        cart.product!.id!.toString(), cart.discountedPrice.toString(), '', cart.variation!,
                                        cart.discountAmount!, cart.quantity!, cart.taxAmount!, _addOnIdList, _addOnQtyList,
                                      ));
                                    }


                                    PlaceOrderBody _placeOrderBody = PlaceOrderBody(
                                      carts, _total, Get.find<OrderController>().selectedMethod,
                                      '${Get.find<OrderController>().orderNote ?? ''}', 'now', DateFormat('yyyy-MM-dd').format(_dateTime),
                                      splashController.getTableId(), cartController.peopleNumber,
                                      '${splashController.getBranchId()}',
                                      '', Get.find<OrderController>().getOrderSuccessModel()?.first.branchTableToken ?? '',
                                    );


                                    Get.find<OrderController>().setPlaceOrderBody = _placeOrderBody;

                                    Get.to(
                                      PaymentScreen(), transition: Transition.leftToRight,
                                      duration: Duration(milliseconds: 300),
                                    );
                                  }





                                },),
                            ),



                            // CustomRoundedButton(onTap: (){}, image: Images.edit_icon, widget: Icon(Icons.delete)),
                          ],
                        ),
                      ],
                    ),




                  ],
                );
              }
              );
            }
          );
        }
      ),
    );
  }

  Column _calculationView(
      BuildContext context, double _itemPrice, double _discount, double _tax,
      double _addOns, OrderController orderController, double _total,
      ) {
    return Column(
      children: [
        SizedBox(height: Dimensions.paddingSizeDefault,),

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          GetBuilder<OrderController>(
              builder: (orderController) {

                return Flexible(
                  child: Text.rich(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    TextSpan(children:  orderController.orderNote != null ? [

                      TextSpan(
                        text: 'note'.tr,
                        style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeLarge,color: Theme.of(context).textTheme.bodyText1!.color,
                        ),
                      ),

                      TextSpan(text: ' ${orderController.orderNote!}',
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeLarge,
                          color: Theme.of(context).textTheme.bodyText1!.color,
                        ),
                      ),

                    ] : [
                      TextSpan(text: 'add_spacial_note_here'.tr,
                        style: robotoRegular.copyWith(
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                      ),
                    ],),

                  ),
                );
              }
          ),

          InkWell(
            onTap: (){
              RouteHelper.openDialog(context, OrderNoteView(
                note: Get.find<OrderController>().orderNote,
                onChange: (note){
                  Get.find<OrderController>().updateOrderNote(
                    note.trim().isEmpty ? null : note,
                  );
                },
              ));
            },
            child: Image.asset(
              Images.edit_icon,
              color: Theme.of(context).secondaryHeaderColor,
              width: Dimensions.paddingSizeExtraLarge,
            ),
          ),




        ],),

        SizedBox(height: ResponsiveHelper.isSmallTab()  ? Dimensions.paddingSizeSmall :Dimensions.paddingSizeDefault,),

        CustomDivider(color: Theme.of(context).disabledColor,),
        SizedBox(height: Dimensions.paddingSizeDefault,),

        PriceWithType(type: 'items_price'.tr,amount: PriceConverter.convertPrice(_itemPrice),),
        PriceWithType(type:'discount'.tr,amount: '- ${PriceConverter.convertPrice(_discount)}'),
        PriceWithType(type: 'vat_tax'.tr, amount :'+ ${PriceConverter.convertPrice(_tax)}'),
        PriceWithType(type: 'addons'.tr, amount :'+ ${PriceConverter.convertPrice(_addOns)}'),
        PriceWithType(type: 'previous_due'.tr, amount :'+ ${PriceConverter.convertPrice(orderController.previousDueAmount())}'),
        PriceWithType(type:'total'.tr,amount : PriceConverter.convertPrice(_total), isTotal: true),





        SizedBox(height: Dimensions.paddingSizeDefault,),
      ],
    );
  }





}

class PriceWithType extends StatelessWidget {
  final String type;
  final String amount;
  final bool isTotal;
  const PriceWithType({Key? key, required this.type, required this.amount, this.isTotal = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.isSmallTab() ? 4 : 8),
      child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(type,  style: isTotal ? robotoBold.copyWith(
          fontSize: Dimensions.fontSizeLarge,
        ) : robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge),),

        Text(amount, style: isTotal ? robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge,
        ) : robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
      ],),
    );
  }
}

