import 'package:efood_table_booking/controller/cart_controller.dart';
import 'package:efood_table_booking/controller/product_controller.dart';
import 'package:efood_table_booking/controller/splash_controller.dart';
import 'package:efood_table_booking/data/model/response/cart_model.dart' as cart;
import 'package:efood_table_booking/data/model/response/cart_model.dart';
import 'package:efood_table_booking/data/model/response/product_model.dart';
import 'package:efood_table_booking/helper/price_converter.dart';
import 'package:efood_table_booking/helper/responsive_helper.dart';
import 'package:efood_table_booking/util/dimensions.dart';
import 'package:efood_table_booking/util/images.dart';
import 'package:efood_table_booking/util/styles.dart';
import 'package:efood_table_booking/view/base/custom_button.dart';
import 'package:efood_table_booking/view/base/custom_image.dart';
import 'package:efood_table_booking/view/base/custom_rounded_button.dart';
import 'package:efood_table_booking/view/base/custom_snackbar.dart';
import 'package:efood_table_booking/view/screens/home/widget/price_stack_tag.dart';
import 'package:efood_table_booking/view/screens/home/widget/quantity_button.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProductBottomSheet extends StatefulWidget {
  final Product product;
  final CartModel? cart;
  final int? cartIndex;
  ProductBottomSheet({required this.product, this.cart, this.cartIndex});

  @override
  State<ProductBottomSheet> createState() => _ProductBottomSheetState();
}

class _ProductBottomSheetState extends State<ProductBottomSheet> {

  @override
  void initState() {
    super.initState();

    Get.find<ProductController>().initData(widget.product, widget.cart);
  }

  @override
  Widget build(BuildContext context) {
    final bool _isTab = ResponsiveHelper.isTab(context);
    Variation _variation = Variation();
    print('size is : ${Get.width}');
    late int _cartIndex;
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Stack(
        children: [
          Container(
            width: ResponsiveHelper.isSmallTab() ? 550 : ResponsiveHelper.isTab(context) ? 700 : 550,
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.only(
                topLeft:  Radius.circular( Dimensions.radiusExtraLarge),
                topRight:  Radius.circular(Dimensions.radiusExtraLarge),
                bottomLeft: _isTab ? Radius.circular(Dimensions.radiusExtraLarge) : Radius.zero,
                bottomRight: _isTab ? Radius.circular(Dimensions.radiusExtraLarge) : Radius.zero,
              ),
            ),
            child: GetBuilder<CartController>(builder: (cartController) {
                return GetBuilder<ProductController>(builder: (productController) {
                  double _startingPrice;
                  double? _endingPrice;
                  if (widget.product.choiceOptions!.length != 0) {
                    List<double> _priceList = [];
                    widget.product.variations?.forEach((variation) => _priceList.add(variation.price!));
                    _priceList.sort((a, b) => a.compareTo(b));
                    _startingPrice = _priceList[0];
                    if (_priceList[0] < _priceList[_priceList.length - 1]) {
                      _endingPrice = _priceList[_priceList.length - 1];
                    }
                  } else {
                    _startingPrice = widget.product.price!;
                  }

                  List<String> _variationList = [];
                  for (int index = 0; index < widget.product.choiceOptions!.length; index++) {
                    _variationList.add(widget.product.choiceOptions![index].options![productController.variationIndex![index]].replaceAll(' ', ''));
                  }
                  String variationType = '';
                  bool isFirst = true;
                  _variationList.forEach((variation) {
                    if (isFirst) {
                      variationType = '$variationType$variation';
                      isFirst = false;
                    } else {
                      variationType = '$variationType-$variation';
                    }
                  });


                  double price = widget.product.price ?? 0;
                  for (Variation variation in widget.product.variations!) {
                    if (variation.type == variationType) {
                      price = variation.price ?? 0;
                      _variation = variation;
                      break;
                    }
                  }
                  double priceWithDiscount = PriceConverter.convertWithDiscount(
                    price, widget.product.discount!, widget.product.discountType.toString(),
                  );

                  double addonsCost = 0;
                  List<AddOn> _addOnIdList = [];
                  int _addonLen = widget.product.addOns != null ? widget.product.addOns!.length : 0;
                  for (int index = 0; index < _addonLen; index++) {
                    if (productController.addOnActiveList[index]) {
                      addonsCost = addonsCost + (widget.product.addOns![index].price! * productController.addOnQtyList[index]);
                      _addOnIdList.add(AddOn(
                        id: widget.product.addOns![index].id,
                        quantity: productController.addOnQtyList[index],
                        name: widget.product.addOns![index].name,
                      ));
                    }
                  }

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



                  cart.CartModel _cartModel = CartModel(
                    price:  price,
                    discountedPrice: priceWithDiscount,
                    variation:  [_variation],
                    discountAmount: price - PriceConverter.convertWithDiscount(
                      price, widget.product.discount!, widget.product.discountType.toString(),
                    ),
                    quantity:  productController.quantity,
                    taxAmount:   price - PriceConverter.convertWithDiscount(price, widget.product.tax!, widget.product.taxType!),
                    addOnIds:  _addOnIdList,
                    product:  widget.product,
                  );


                  _cartIndex = cartController.isExistInCart(widget.product.id!, variationType.isEmpty ? null : variationType, false, null) ;
                  print('cart index $_cartIndex');


                  double priceWithQuantity = priceWithDiscount * productController.quantity;
                  double priceWithAddons = priceWithQuantity + addonsCost;


                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(_isTab ? Dimensions.paddingSizeExtraLarge : Dimensions.paddingSizeLarge),
                                child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end, children: [

                                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                    //Product
                                    Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [

                                      (widget.product.image != null && widget.product.image!.isNotEmpty) ? Stack(children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                                          child: CustomImage(
                                            image: '${Get.find<SplashController>().configModel?.baseUrls?.productImageUrl}/${widget.product.image ?? ''}',
                                            width: ResponsiveHelper.isSmallTab() ? 100 :  _isTab ? 170 : 100,
                                            height: ResponsiveHelper.isSmallTab() ? 100 : _isTab ? 170 : 100,
                                            fit: BoxFit.cover,
                                          ),
                                        ),

                                       if(widget.product.discount != null && widget.product.discount! > 0)
                                         PriceStackTag(value: PriceConverter.percentageCalculation(
                                          widget.product.price.toString(), widget.product.discount.toString(), widget.product.discountType!,
                                        )),

                                      ]) : SizedBox.shrink(),

                                      SizedBox(width: Dimensions.paddingSizeDefault,),

                                      Expanded(
                                        child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [
                                          Text(
                                            widget.product.name ?? '', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, ),
                                            maxLines: 2, overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: Dimensions.paddingSizeSmall,),

                                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                            Text(
                                              '${PriceConverter.convertPrice(
                                                _startingPrice, discount: widget.product.discount, discountType: widget.product.discountType,
                                              )}''${_endingPrice != null ? ' - ${PriceConverter.convertPrice(
                                                _endingPrice, discount: widget.product.discount, discountType: widget.product.discountType,
                                              )}' : ''}',
                                              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                                            ),

                                            SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                            price > priceWithDiscount ? Text(
                                              '${PriceConverter.convertPrice(_startingPrice)} ${ _endingPrice != null ?  ' - ${PriceConverter.convertPrice(_endingPrice)}' : ''} ',
                                              style: robotoMedium.copyWith(color: Theme.of(context).primaryColor, decoration: TextDecoration.lineThrough),
                                            ) : SizedBox(),

                                          ]),

                                         if(_isTab)  _productDescription(),

                                        ]),
                                      ),

                                    ]),
                                    if(!ResponsiveHelper.isSmallTab()) SizedBox(height: Dimensions.paddingSizeSmall),


                                    if(!_isTab)  _productDescription(),
                                    SizedBox(height: Dimensions.paddingSizeDefault),

                                    _variationView(_cartIndex),

                                    // Variation

                                   SizedBox(height: widget.product.choiceOptions!.length > 0 ? Dimensions.paddingSizeDefault : 0),

                                    // Addons
                                    widget.product.addOns != null  && widget.product.addOns!.length > 0 ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Row(
                                        children: [
                                          Text('${'addons'.tr}', style: robotoMedium.copyWith(
                                            fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyText1!.color,
                                          ),),
                                          SizedBox(width: Dimensions.paddingSizeExtraSmall,),

                                          Text('(${'optional'.tr})', style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).hintColor,
                                          ),),
                                        ],
                                      ),
                                      SizedBox(height: Dimensions.paddingSizeDefault),

                                      Container(
                                        height: 100,
                                        child: ListView.builder(
                                          // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          //   crossAxisCount: 1,
                                          //   mainAxisExtent: 5,
                                          //   crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: (0.5),
                                          // ),
                                          scrollDirection: Axis.horizontal,
                                          itemCount: widget.product.addOns!.length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () {
                                                if (!productController.addOnActiveList[index]) {
                                                  productController.addAddOn(true, index);
                                                } else if (productController.addOnQtyList[index] == 1) {
                                                  productController.addAddOn(false, index);
                                                }
                                              },
                                              child: Container(
                                                width: 100, height: 100,
                                                margin: EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: productController.addOnActiveList[index] ? Theme.of(context).primaryColor : Theme.of(context).hintColor.withOpacity(0.15),
                                                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                                                  boxShadow: productController.addOnActiveList[index]
                                                      ? [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300]!, blurRadius: 5, spreadRadius: 1)] : null,
                                                ),

                                                child: Column(children: [
                                                  Expanded(
                                                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                      Text(widget.product.addOns![index].name ?? '',
                                                        maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
                                                        style: robotoMedium.copyWith(
                                                          color: productController.addOnActiveList[index] ? Colors.white : Theme.of(context).textTheme.bodyText1!.color,
                                                          fontSize: Dimensions.fontSizeSmall,
                                                        ),
                                                      ),
                                                      SizedBox(height: 5),

                                                      Text(
                                                        widget.product.addOns![index].price! > 0 ? PriceConverter.convertPrice(widget.product.addOns![index].price!) : 'free'.tr,
                                                        maxLines: 1, overflow: TextOverflow.ellipsis,
                                                        style: robotoRegular.copyWith(
                                                          color: productController.addOnActiveList[index] ? Colors.white : Theme.of(context).textTheme.bodyText1!.color,
                                                          fontSize: Dimensions.fontSizeExtraSmall,
                                                        ),
                                                      ),
                                                    ]),
                                                  ),

                                                  productController.addOnActiveList[index] ? Container(
                                                    padding: EdgeInsets.symmetric(vertical: 6),
                                                    margin: EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL), color: Theme.of(context).canvasColor,
                                                    ),
                                                    child: Row(children: [
                                                      Expanded(
                                                        child: InkWell(
                                                          onTap: () {
                                                            if (productController.addOnQtyList[index] > 1) {
                                                              productController.setAddOnQuantity(false, index);
                                                            } else {
                                                              productController.addAddOn(false, index);
                                                            }
                                                          },

                                                          child: Center(child: Icon(Icons.remove, size: Dimensions.paddingSizeLarge)),
                                                        ),
                                                      ),
                                                      Text(
                                                        productController.addOnQtyList[index].toString(),
                                                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                                                      ),

                                                      Expanded(
                                                        child: InkWell(
                                                          onTap: () => productController.setAddOnQuantity(true, index),
                                                          child: Center(child: Icon(Icons.add, size: Dimensions.paddingSizeLarge)),
                                                        ),
                                                      ),
                                                    ]),
                                                  ) : SizedBox(),

                                                ]),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                     // SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                    ]) : SizedBox(),

                                  ]),
                                ]),
                              ),
                              if(!ResponsiveHelper.isSmallTab()) SizedBox(height: Dimensions.paddingSizeSmall),




                            ],
                          ),
                        ),
                      ),

                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(Dimensions.radiusExtraLarge),
                            bottomLeft: Radius.circular(Dimensions.radiusExtraLarge),
                          ),
                          color: Theme.of(context).canvasColor,
                          boxShadow: [BoxShadow(
                            color: Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.1),
                            blurRadius: 4, offset: Offset(0, -4),
                          )],
                        ),

                        child: Padding(
                          padding:  EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                          child: Row(

                            children: [
                              _isTab ? Flexible(
                                flex: 2,
                                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                  Text('total'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                                  SizedBox(width: Dimensions.paddingSizeSmall),

                                  Text('${PriceConverter.convertPrice(priceWithAddons)}', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
                                ],),
                              ) : Padding(
                                padding:  EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text('total'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                                  SizedBox(width: Dimensions.paddingSizeExtraSmall),


                                  Text('${PriceConverter.convertPrice(priceWithAddons)}', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
                                ]),
                              ),

                              Flexible(
                                flex: 3,
                                child: CustomButton(
                                  margin: EdgeInsets.all(ResponsiveHelper.isSmallTab() ? 5 : Dimensions.paddingSizeSmall),
                                  buttonText: _isAvailable ?
                                  (_cartIndex != -1) ? 'update_in_cart'.tr : 'add_to_cart'.tr : 'not_available'.tr,
                                  onPressed: _isAvailable ? () {
                                    Get.back();
                                    print('cart index $_cartIndex');

                                    // if(productController.cartIndex != -1) {
                                    //   cartController.removeFromCart(productController.cartIndex);
                                    // }

                                    cartController.addToCart(_cartModel, _cartIndex != -1 ? _cartIndex : null);

                                    showCustomSnackBar('Item added to cart', isError: false, isToast: true);

                                    productController.update();

                                  } : null,
                                ),
                              )
                            ],),
                        ),
                      ),
                    ],
                  );
                });
              }
            ),
          ),

          Positioned.fill(
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomRoundedButton(
                widget: Icon(Icons.close_outlined, size: 15), image: '', onTap: () => Get.back(),
              ),
            ),
          ),
        ),


        ],
      ),
    );
  }

 Widget _productDescription() {
    return Column(children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          'description'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
        ),


        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [BoxShadow(blurRadius: 5, color: Theme.of(context).cardColor.withOpacity(0.05))],
          ),

          child: widget.product.productType == null ? SizedBox() :
          SizedBox(height: ResponsiveHelper.isSmallTab() ? 25 : 30,
            child: Row(
              children: [
                Padding(
                  padding:  EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  child: Image.asset(
                    fit: BoxFit.fitHeight,
                    Images.getImageUrl(widget.product.productType!),
                  ),
                ),
                SizedBox(width: Dimensions.paddingSizeSmall),

                Text(
                  widget.product.productType!.tr,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                ),
                SizedBox(width: Dimensions.paddingSizeExtraSmall),
              ],
            ),
          ),
        ),


      ],),
      SizedBox(height: Dimensions.paddingSizeSmall,),

      Align(
        alignment: Alignment.topLeft,
        child: ExpandableText(
          '${widget.product.description ?? ''}',
          expandText: 'show_more'.tr,
          collapseText: 'show_less'.tr,
          maxLines: 2,
          linkColor: Colors.blue,
          animation: true,
          animationDuration: Duration(milliseconds: 500),
          collapseOnTextTap: true,

          urlStyle: TextStyle(
            decoration: TextDecoration.underline,
          ),
        ),
      )
    ],);
  }

  Widget _variationView(int _cartIndex) {
    return GetBuilder<ProductController>(
      builder: (productController) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.product.choiceOptions?.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(widget.product.choiceOptions?[index].title ?? '',
                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                ),

                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.product.choiceOptions?[index].options?.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, i){
                      return RadioListTile(
                        activeColor: Theme.of(context).primaryColor,
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        visualDensity: VisualDensity(
                          horizontal: VisualDensity.minimumDensity,
                          vertical: VisualDensity.minimumDensity,
                        ),


                        title: Text(widget.product.choiceOptions![index].options![i].trim()),
                        value: i,
                        groupValue: Get.find<ProductController>().variationIndex![index],
                        onChanged: (int? value) {
                          Get.find<ProductController>().setCartVariationIndex(index, i, widget.product);
                        },
                      );
                    },
                  ),

                  SizedBox(height: index != widget.product.choiceOptions!.length - 1 ? ResponsiveHelper.isSmallTab() ? Dimensions.paddingSizeSmall : Dimensions.paddingSizeLarge : 0),
                ]);
              },
            ),
          ),

           Row(
            children: [
              QuantityButton(isIncrement: false, onTap: () {
                if(productController.quantity == 1 && _cartIndex != -1) {
                  Get.find<CartController>().removeFromCart(_cartIndex);
                  Get.back();

                }else if(productController.quantity > 1){
                  productController.setQuantity(false);
                }

              }),

              Text( productController.quantity.toString() , style: robotoBold.copyWith(color: Theme.of(context).primaryColor),),

              QuantityButton(
                isIncrement: true,
                onTap: () => productController.setQuantity(true),
              ),
            ],
          )

        ],);
      }
    );
  }
}

