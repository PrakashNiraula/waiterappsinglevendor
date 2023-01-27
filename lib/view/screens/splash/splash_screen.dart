import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:efood_table_booking/controller/cart_controller.dart';
import 'package:efood_table_booking/controller/promotional_controller.dart';
import 'package:efood_table_booking/controller/splash_controller.dart';
import 'package:efood_table_booking/helper/responsive_helper.dart';
import 'package:efood_table_booking/helper/route_helper.dart';
import 'package:efood_table_booking/util/images.dart';
import 'package:efood_table_booking/view/screens/promotional_page/promotional_page_screen.dart';
import 'package:efood_table_booking/view/screens/promotional_page/widget/setting_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with WidgetsBindingObserver{
  late StreamSubscription<ConnectivityResult> _onConnectivityChanged;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    bool _firstTime = true;
    _onConnectivityChanged = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(!_firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi && result != ConnectivityResult.mobile;
        isNotConnected ? SizedBox() : ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected ? 'no_connection' : 'connected',
            textAlign: TextAlign.center,
          ),
        ));
        if(!isNotConnected) {
          _route();
        }
      }
      _firstTime = false;
    });

    Get.find<SplashController>().initSharedData();
    // Get.find<SplashController>().removeSharedData();

    Get.find<CartController>().getCartData();
    try{

    }catch(e) {

    }
    _route();

  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('state change $state');
    if(AppLifecycleState.resumed == state) {
      if(Get.find<SplashController>().getBranchId() < 1) {

        RouteHelper.openDialog(
            context, SettingWidget(formSplash: true),
            isDismissible: false
        );

      }
    }

  }


  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);
    _onConnectivityChanged.cancel();
  }

  void _route() {
    Get.find<SplashController>().getConfigData().then((value) {
      Timer(Duration(seconds: 2), () async {
        if(Get.find<SplashController>().getBranchId() < 1) {
          RouteHelper.openDialog(
            context, SettingWidget(formSplash: true),
            isDismissible: false
          );

        }else{
          if(ResponsiveHelper.isTab(context)
              && (Get.find<PromotionalController>().getPromotion('', all: true).isNotEmpty)
          ) {
            Get.offAll(()=> PromotionalPageScreen());
          }else {
            Get.offNamed(RouteHelper.home);
          }
        }

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print('size : ${Get.height} || ${Get.width}');
    return Scaffold(
      body: InkWell(
        onTap: Get.find<SplashController>().getBranchId() < 1 ? () {
          RouteHelper.openDialog(
            context, SettingWidget(formSplash: true),
            isDismissible: false,
          );
        } : null,

        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(Images.splash_image, width: Get.height * 0.1),

                  Image.asset(Images.logo, width: Get.height * 0.2),
                ],
              ),
            ),

            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: Get.width,
                  child: Lottie.asset(
                    fit: BoxFit.fitWidth,
                    Images.wave_loading,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
