import 'dart:convert';

import 'package:efood_table_booking/data/model/response/cart_model.dart';
import 'package:efood_table_booking/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartRepo{
  final SharedPreferences sharedPreferences;
  CartRepo({required this.sharedPreferences});

  List<CartModel> getCartList() {
    List<String>? carts = [];
    if(sharedPreferences.containsKey(AppConstants.CART_LIST)) {
      carts = sharedPreferences.getStringList(AppConstants.CART_LIST);
    }
    List<CartModel> cartList = [];
    carts?.forEach((cart) {
      cartList.add(CartModel.fromJson(jsonDecode(cart)));
    } );
    carts?.forEach((cart) {
    });
    return cartList;
  }

  void addToCartList(List<CartModel> cartProductList) {
    List<String> carts = [];
    cartProductList.forEach((cartModel) {
      carts.add(jsonEncode(cartModel));
    });
    sharedPreferences.setStringList(AppConstants.CART_LIST, carts);
  }

  int? getTableNumber() {
    int? _number = -1;
    if(sharedPreferences.containsKey(AppConstants.TABLE_NUMBER)) {
      _number = sharedPreferences.getInt(AppConstants.TABLE_NUMBER);
    }

    return _number;
  }

  void clearCartData() {
    if(sharedPreferences.containsKey(AppConstants.CART_LIST)) {
      sharedPreferences.remove(AppConstants.CART_LIST);
    }
  }




}