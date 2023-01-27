import 'dart:convert';

import 'package:efood_table_booking/data/api/api_client.dart';
import 'package:efood_table_booking/data/model/response/order_success_model.dart';
import 'package:efood_table_booking/data/model/response/place_order_body.dart';
import 'package:efood_table_booking/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  OrderRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getOrderDetails(String orderID, String orderToken) async {
    return await apiClient.getData(
      '${AppConstants.ORDER_DETAILS_URI}order_id=$orderID&branch_table_token=$orderToken',
    );
  }

  Future<Response> getOderList(String orderToken) async {
    return await apiClient.getData('${AppConstants.ORDER_LIST}$orderToken');
  }
  //
  Future<Response> placeOrder(PlaceOrderBody orderBody) async {
    return await apiClient.postData(AppConstants.PLACE_ORDER_URI, orderBody.toJson());
  }

  void setOrderID(String orderInfo) {
    sharedPreferences.setString(AppConstants.ORDER_INFO, orderInfo);
  }
  String getOrderInfo() {
   return sharedPreferences.getString(AppConstants.ORDER_INFO) ?? '';
  }

  List<OrderSuccessModel> getOrderSuccessModelList() {
    List<String>? _orderList = [];
    if(sharedPreferences.containsKey(AppConstants.ORDER_INFO)) {
      _orderList = sharedPreferences.getStringList(AppConstants.ORDER_INFO);
    }
    List<OrderSuccessModel> orderSuccessList = [];
    _orderList?.forEach((orderSuccessModel) => orderSuccessList.add(OrderSuccessModel.fromJson(jsonDecode(orderSuccessModel))) );
    return orderSuccessList;
  }

  void addOrderModel(List<OrderSuccessModel> orderSuccessList) {
    List<String> _orderList = [];
    orderSuccessList.forEach((orderModel) => _orderList.add(jsonEncode(orderModel)) );
    sharedPreferences.setStringList(AppConstants.ORDER_INFO, _orderList);
  }



}