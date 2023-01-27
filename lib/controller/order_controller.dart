import 'dart:async';
import 'package:efood_table_booking/controller/splash_controller.dart';
import 'package:efood_table_booking/data/api/api_checker.dart';
import 'package:efood_table_booking/data/model/response/order_details_model.dart';
import 'package:efood_table_booking/data/model/response/order_success_model.dart';
import 'package:efood_table_booking/data/model/response/place_order_body.dart';
import 'package:efood_table_booking/data/repository/order_repo.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


class OrderController extends GetxController implements GetxService {
  final OrderRepo orderRepo;
  OrderController({required this.orderRepo});

  bool _isLoading = false;
  List<String> _paymentMethodList = ['cash', 'card'];
  String _selectedMethod = 'cash';
  PlaceOrderBody? _placeOrderBody;
  String? _orderNote;
  String? _currentOrderId;
  String? _currentOrderToken;
  OrderDetails? _currentOrderDetails;
  OrderSuccessModel? _orderSuccessModel;
  Duration _duration = Duration();
  Timer? _timer;
  List<Order>? _orderList;

  String get selectedMethod => _selectedMethod;

  List<String> get paymentMethodList => _paymentMethodList;
  bool get isLoading => _isLoading;
  PlaceOrderBody? get placeOrderBody => _placeOrderBody;
  String? get orderNote => _orderNote;
  String? get currentOrderId => _currentOrderId;
  String? get currentOrderToken => _currentOrderToken;
  OrderDetails? get currentOrderDetails => _currentOrderDetails;
  OrderSuccessModel? get orderSuccessModel => _orderSuccessModel;
  Duration get duration => _duration;
  List<Order>? get orderList => _orderList;

  set setPlaceOrderBody(PlaceOrderBody value) {
    _placeOrderBody = value;
  }
  set isLoadingUpdate(bool isLoad) {
    _isLoading = isLoad;
  }

  set setCurrentOrderId(String? value) {
    _currentOrderId = value;
  }

  void setSelectedMethod(String value, {bool isUpdate = true}) {
    _selectedMethod = value;
   if(isUpdate) {
     update();
   }
  }

  void updateOrderNote(String? value) {
    _orderNote = value;
    update();
  }




  Future<void> placeOrder(PlaceOrderBody placeOrderBody, Function callback, String paidAmount, double changeAmount) async {
    _isLoading = true;
    update();
    print(placeOrderBody.toJson());
    Response response = await orderRepo.placeOrder(placeOrderBody);
    _isLoading = false;

    if (response.statusCode == 200) {
      print('order -- > ${response.body['branch_table_token']}');
      String message = response.body['message'];
      String orderID = response.body['order_id'].toString();

      print('order id for : $orderID');


      _orderSuccessModel = OrderSuccessModel(
        orderId: '${response.body['order_id']}',
        branchTableToken: response.body['branch_table_token'],
        // paidAmount: double.parse(paidAmount.trim().isEmpty ? '0.0' : paidAmount),
        changeAmount: changeAmount,
        tableId: Get.find<SplashController>().getTableId().toString(),
        branchId: Get.find<SplashController>().getBranchId().toString(),
      );



      List<OrderSuccessModel> _list = [];
     try{
       _list.addAll(orderRepo.getOrderSuccessModelList());
     }catch(error){


     }

      _list.add(_orderSuccessModel!);

     orderRepo.addOrderModel(_list);
     callback(true, message, orderID);

    } else {
      callback(false, response.statusText, '-1',);
    }
    update();
  }

  List<OrderSuccessModel>? getOrderSuccessModel() {
    List<OrderSuccessModel>?  _list;
    try {
      _list =   orderRepo.getOrderSuccessModelList();
      _list = _list.reversed.toList();
      _orderSuccessModel = _list.firstWhere((model) {
        print('model : ${_orderSuccessModel?.branchTableToken}');
        return model.tableId == Get.find<SplashController>().getTableId().toString() &&
            Get.find<SplashController>().getBranchId().toString() == model.branchId.toString();
      });
    }catch(e) {
      _list = [OrderSuccessModel(orderId: '-1', branchTableToken: '',)];
      _orderSuccessModel = _list.first;
    }
    print('order success : ${_orderSuccessModel?.orderId}');

    return _list;
  }

  Future<List<Order>?> getOrderList() async {
    getOrderSuccessModel();
    _orderList = null;

    print('order token : -${_orderSuccessModel?.branchTableToken}');
    print('order id : -${_orderSuccessModel?.orderId}');
    if(_orderSuccessModel?.orderId != '-1') {
      _isLoading = true;
      Response response = await  orderRepo.getOderList(
        _orderSuccessModel!.branchTableToken!,
      );
      if (response.statusCode == 200) {
       try{
         _orderList = OrderList(order: OrderList.fromJson(response.body).order?.reversed.toList()).order;
       }catch(e) {
         _orderList = [];
       }


      } else {
        ApiChecker.checkApi(response);
      }
      _isLoading = false;
      update();
    }else{
      _orderList = [];
    }

    return _orderList;

  }

  double previousDueAmount() {
    double _amount = 0;
    _orderList?.forEach((order) {
      if(order.paymentStatus == 'unpaid' && order.orderAmount != null) {
        _amount = _amount + order.orderAmount!.toDouble() ;
      }
    });

    return _amount;

  }



  Future<void> getCurrentOrder(String? orderId, {bool isLoading = true}) async {
    if(isLoading) {
      print('current order list ==');
      _isLoading = true;
    }
    _currentOrderDetails = null;

   update();

   if(_orderSuccessModel?.orderId != '-1' && orderId != null) {
     Response response = await  orderRepo.getOrderDetails(
       orderId, _orderSuccessModel!.branchTableToken!,
     );

     if (response.statusCode == 200) {
       _currentOrderDetails =  OrderDetails.fromJson(response.body);

     } else {
       ApiChecker.checkApi(response);
     }
   }

   _isLoading = false;
   update();

  }


  Future<void> countDownTimer() async {
    DateTime _orderTime;
    if(Get.find<SplashController>().configModel?.timeFormat == '12') {
      print('order time : ${'${_currentOrderDetails?.order?.deliveryDate} ${_currentOrderDetails?.order?.deliveryTime}'}');
      _orderTime =  DateFormat("yyyy-MM-dd HH:mm").parse('${_currentOrderDetails?.order?.deliveryDate} ${_currentOrderDetails?.order?.deliveryTime}');

    }else{
      _orderTime =  DateFormat("yyyy-MM-dd HH:mm").parse('${_currentOrderDetails?.order?.deliveryDate} ${_currentOrderDetails?.order?.deliveryTime}');
    }

    DateTime endTime = _orderTime.add(Duration(minutes: int.parse('${_currentOrderDetails?.order?.preparationTime}')));

    _duration = endTime.difference(DateTime.now());
    cancelTimer();
    _timer = null;
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      if(!_duration.isNegative && _duration.inMinutes > 0) {
        _duration = _duration - Duration(minutes: 1);
        getOrderSuccessModel();
        getCurrentOrder(_orderSuccessModel?.orderId).then((value) => countDownTimer());
      }

    });




    if(_duration.isNegative) {
      _duration = Duration();
    }_duration = endTime.difference(DateTime.now());

  }

  void cancelTimer() => _timer?.cancel();




}