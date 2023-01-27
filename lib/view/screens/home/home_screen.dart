import 'dart:async';

import 'package:efood_table_booking/controller/order_controller.dart';
import 'package:efood_table_booking/controller/product_controller.dart';
import 'package:efood_table_booking/controller/theme_controller.dart';
import 'package:efood_table_booking/helper/responsive_helper.dart';
import 'package:efood_table_booking/helper/route_helper.dart';
import 'package:efood_table_booking/util/dimensions.dart';
import 'package:efood_table_booking/util/images.dart';
import 'package:efood_table_booking/view/base/bodyTemplate.dart';
import 'package:efood_table_booking/view/base/confirmation_dialog.dart';
import 'package:efood_table_booking/view/base/custom_app_bar.dart';
import 'package:efood_table_booking/view/base/custom_loader.dart';
import 'package:efood_table_booking/view/base/custom_rounded_button.dart';
import 'package:efood_table_booking/view/screens/home/widget/category_view.dart';
import 'package:efood_table_booking/view/screens/home/widget/filter_button_widget.dart';
import 'package:efood_table_booking/view/screens/home/widget/page_view_product.dart';
import 'package:efood_table_booking/view/screens/home/widget/product_shimmer_list.dart';
import 'package:efood_table_booking/view/screens/home/widget/product_widget.dart';
import 'package:efood_table_booking/view/screens/home/widget/search_bar_view.dart';
import 'package:efood_table_booking/view/screens/order/widget/order_success_screen.dart';
import 'package:efood_table_booking/view/screens/promotional_page/widget/setting_widget.dart';
import 'package:efood_table_booking/view/screens/root/no_data_screen.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  final _scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  late String type;
  final GlobalKey<FabCircularMenuState> _fabKey = GlobalKey();
  Timer? _timer;


  @override
  void initState() {
    final _productController = Get.find<ProductController>();

    Get.find<OrderController>().getOrderList();
    type = _productController.productTypeList.first;
    _productController.getCategoryList(true);
    _productController.getProductList(false, false);

    searchController.addListener(() {
      if(searchController.text.trim().isNotEmpty) {
        _productController.isSearchChange(false);

      }else{
        _productController.isSearchChange(true);
        FocusScope.of(context).unfocus();
      }
    });




    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        int totalSize = (_productController.totalSize! / 10).ceil();

        if (_productController.productOffset < totalSize) {
          _productController.productOffset++;

          _productController.getProductList(
            false, true, offset: _productController.productOffset, productType: type,
            categoryId: _productController.selectedCategory,
            searchPattern: searchController.text.trim().isEmpty ? null : searchController.text,

          );
        }
      }

    });


    super.initState();
  }

  @override
  void dispose() {
   _scrollController.dispose();
   searchController.dispose();
   changeButtonState();
    super.dispose();
  }

  void changeButtonState() {
    if (_fabKey.currentState != null && _fabKey.currentState!.isOpen) {
      _fabKey.currentState?.close();
      _timer?.cancel();
      _timer = null;
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
    changeButtonState();
    timer.cancel();
    });

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if(searchController.text.trim().isEmpty) {
          RouteHelper.openDialog(
              context, ConfirmationDialog(
            title: '${'exit'.tr} !',
            icon: Icons.question_mark_sharp,
            description: 'are_you_exit_the_app'.tr,
            onYesPressed: () => SystemNavigator.pop(),
            onNoPressed: ()=> Get.back(),
          ));
        }else{
          searchController.clear();
        }


        return Future.value(false);
      },
      child: RefreshIndicator(
        onRefresh: () async {
          type = Get.find<ProductController>().productTypeList.first;
          Get.find<ProductController>().setSelectedCategory(null);
          await Get.find<ProductController>().getProductList(
            true, true, offset: 1,
          );
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: ResponsiveHelper.isTab(context) ? null : CustomAppBar(
            isBackButtonExist: false, onBackPressed: null, showCart: true,
          ),
          body: ResponsiveHelper.isTab(context) ? BodyTemplate(
            body: _bodyWidget(),
            showSetting: true,
            showOrderButton: true,
          ) : homeMobileView(),
          floatingActionButton: ResponsiveHelper.isTab(context) ? null : Padding(
            padding:  EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: FabCircularMenu(
              onDisplayChange: (isOpen) {
                if(isOpen){
                  _startTimer();
                }
              },
              key: _fabKey,
              ringColor: Theme.of(context).cardColor.withOpacity(0.2),
              fabSize: 50,
              ringWidth: 90,
              ringDiameter: 300,
              fabOpenIcon: Icon(Icons.settings, color: Colors.white),
              children: [
                CustomRoundedButton(
                  image: Images.theme_icon,
                  onTap: ()=> Get.find<ThemeController>().toggleTheme(),
                ),

                CustomRoundedButton(image: Images.setting_icon, onTap: (){
                  Get.bottomSheet(
                    SettingWidget(formSplash: false), backgroundColor: Colors.transparent,
                  );

                }),


                CustomRoundedButton(
                  image: Images.order,
                  onTap: ()=> Get.to(()=> OrderSuccessScreen()),
                ),

              ],
            ),
          ),

        ),
      ),
    );
  }

  Widget homeMobileView() {
    return GetBuilder<ProductController>(
      builder: (productController) {
        return Column(
            children: <Widget>[
              SizedBox(height: Dimensions.paddingSizeDefault,),

              Padding(
                padding:  EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                child: SearchBarView(controller: searchController, type: type),
              ),


              SizedBox(
                height: 90,
                child: CategoryView(onSelected: (id){
                  if(productController.selectedCategory == id) {
                    productController.setSelectedCategory(null);
                  }else{
                    productController.setSelectedCategory(id);
                  }
                  productController.getProductList(
                    true, true, categoryId: productController.selectedCategory,
                    productType:  type,
                    searchPattern: searchController.text.trim().isEmpty ? null : searchController.text,
                  );

                }),
              ),
              SizedBox(height: Dimensions.paddingSizeSmall,),

              IgnorePointer(
                ignoring: productController.productList == null,
                child: FilterButtonWidget(
                  items: productController.productTypeList, type: type, onSelected: (_type){
                  type = _type;
                  productController.setSelectedProductType = _type;
                  productController.getProductList(
                    true, true, categoryId: productController.selectedCategory,
                    productType:  type,
                    searchPattern: searchController.text.trim().isEmpty ? null : searchController.text,
                  );

                },),
              ),
              SizedBox(height: Dimensions.paddingSizeSmall,),



              Expanded(
                child: GetBuilder<ProductController>(
                  builder: (productController) {
                    final _isBig = (Get.height / Get.width) > 1 && (Get.height / Get.width) < 1.7;

                    return productController.productList == null ?
                    ProductShimmerList() : productController.productList!.isNotEmpty ?
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child:  GridView.builder(
                            controller : _scrollController,
                            padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                            itemCount: productController.productList?.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:  _isBig ? 3 : 2,
                              crossAxisSpacing: Dimensions.paddingSizeDefault,
                              mainAxisSpacing: Dimensions.paddingSizeDefault,
                            ),

                            itemBuilder: (context, index) {
                              return  productController.productList?[index] != null
                                  ? ProductWidget(product: productController.productList![index]!)
                                  : Center(child: CustomLoader(color: Theme.of(context).primaryColor));
                            },
                          ),
                        ),

                        if(productController.isLoading) Container(
                          color: Colors.transparent,
                          padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                          child: CustomLoader(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ) : SingleChildScrollView(child: NoDataScreen(text: 'no_food_available'.tr,));
                  }
                ),
              ),

            ],);
      }
    );
  }


  Widget _bodyWidget() {
    return GetBuilder<ProductController>(
        builder: (productController) {
          int _totalPage = 0;
          if(productController.productList != null) {
            _totalPage = (productController.productList!.length / ResponsiveHelper.getLen(context)).ceil();
            print('get len : ${ResponsiveHelper.getLen(context)}');
          }
          return Flexible(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SearchBarView(controller: searchController, type: type),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                    child: IgnorePointer(
                       ignoring: productController.productList == null,
                       child: FilterButtonWidget(
                        items: productController.productTypeList, type: type,
                        onSelected: (_type){
                          type = _type;
                          productController.setSelectedProductType = _type;
                          productController.getProductList(
                            true, true, categoryId: productController.selectedCategory,
                            productType:  type,
                            searchPattern: searchController.text.trim().isEmpty ? null : searchController.text,
                          );

                        },
                       ),
                     ),
                  ),
                ],
              ),

              SizedBox(height: ResponsiveHelper.isSmallTab() ? 80 : 100,child: CategoryView(onSelected: (id){
                if(productController.selectedCategory == id) {
                  productController.setSelectedCategory(null);

                }else{
                  productController.setSelectedCategory(id);
                }
                productController.getProductList(
                  true, true, categoryId: productController.selectedCategory,
                  productType:  type,
                  searchPattern: searchController.text.trim().isEmpty ? null : searchController.text,
                );

              })),

              Expanded(
                child: PageViewProduct(totalPage: _totalPage, search: searchController.text.isEmpty ? null : searchController.text),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                  child: GetBuilder<ProductController>(
                      builder: (productController) {
                        int _totalPage = 0;
                        if(productController.productList != null) {
                          _totalPage = (productController.totalSize! / ResponsiveHelper.getLen(context)).ceil();
                        }
                        List _list = [for (var i = 0; i <= _totalPage -1; i++) i];
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _list.map((index) =>
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 2),
                                  decoration: BoxDecoration(
                                    color:  index == productController.pageViewCurrentIndex
                                        ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
                                    borderRadius: BorderRadius.all(Radius.circular(Dimensions.RADIUS_SMALL)),
                                  ),
                                  height: 5, width: Dimensions.paddingSizeExtraLarge,
                                ),

                            ).toList(),
                          ),
                        );
                      }
                  ),
                ),),
            ],),
          );
        }
    );
  }

}









