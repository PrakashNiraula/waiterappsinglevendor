import 'package:efood_table_booking/data/api/api_client.dart';
import 'package:efood_table_booking/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashRepo {
  ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  SplashRepo({required this.sharedPreferences, required this.apiClient});

  Future<Response> getConfigData() async {
    Response _response = await apiClient.getData(AppConstants.CONFIG_URI);
    return _response;
  }

  Future<bool> initSharedData() {
    if(!sharedPreferences.containsKey(AppConstants.THEME)) {
      return sharedPreferences.setBool(AppConstants.THEME, false);
    }
    if(!sharedPreferences.containsKey(AppConstants.COUNTRY_CODE)) {
      return sharedPreferences.setString(AppConstants.COUNTRY_CODE, AppConstants.languages[0].countryCode!);
    }
    if(!sharedPreferences.containsKey(AppConstants.LANGUAGE_CODE)) {
      return sharedPreferences.setString(AppConstants.LANGUAGE_CODE, AppConstants.languages[0].languageCode!);
    }
    if(!sharedPreferences.containsKey(AppConstants.CART_LIST)) {
      return sharedPreferences.setStringList(AppConstants.CART_LIST, []);
    }
    if(!sharedPreferences.containsKey(AppConstants.TABLE_NUMBER)) {
      return sharedPreferences.setInt(AppConstants.TABLE_NUMBER, -1);
    }

    if(!sharedPreferences.containsKey(AppConstants.BRANCH)) {
      return sharedPreferences.setInt(AppConstants.BRANCH, -1);
    }
    if(!sharedPreferences.containsKey(AppConstants.ORDER_INFO)) {
      return sharedPreferences.setString(AppConstants.ORDER_INFO, '');
    }
    if(!sharedPreferences.containsKey(AppConstants.IS_FIX_TABLE)) {
      return sharedPreferences.setBool(AppConstants.IS_FIX_TABLE, false);
    }

    return Future.value(true);
  }

  Future<bool> removeSharedData() {
    return sharedPreferences.clear();
  }

  int getTable() => sharedPreferences.getInt(AppConstants.TABLE_NUMBER) ?? -1;
  void satTable(int number) => sharedPreferences.setInt(AppConstants.TABLE_NUMBER, number);

  void setFixTable(bool value) => sharedPreferences.setBool(AppConstants.IS_FIX_TABLE, value);
  bool getFixTable() => sharedPreferences.getBool(AppConstants.IS_FIX_TABLE) ?? false;

  int getBranchId() => sharedPreferences.getInt(AppConstants.BRANCH) ?? -1;
  void setBranchId(int id) => sharedPreferences.setInt(AppConstants.BRANCH, id);
}
