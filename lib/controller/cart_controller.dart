import 'package:efood_table_booking/data/model/response/cart_model.dart';
import 'package:efood_table_booking/data/repository/cart_repo.dart';
import 'package:get/get.dart';

class CartController extends GetxController implements GetxService {
  final CartRepo cartRepo;
  CartController({required this.cartRepo});

  List<CartModel> _cartList = [];
  double _amount = 0.0;
  bool _isCartUpdate = false;
  int? _peopleNumber;
  double _totalAmount = 0.0;






  List<CartModel> get cartList => _cartList;
  double get amount => _amount;
  double get totalAmount => _totalAmount;
  bool get isCartUpdate => _isCartUpdate;
  int? get peopleNumber => _peopleNumber;


  set setPeopleNumber(int value) {
    _peopleNumber = value;
  }


  set setTotalAmount(double value) {
    _totalAmount = value;
  }

  void getCartData() {
    _cartList = [];
    _cartList.addAll(cartRepo.getCartList());
    _cartList.forEach((cart) {
      _amount = _amount + (cart.discountedPrice! * cart.quantity!);
    });
  }

  int isExistInCart(int productId, String? variationType, bool isUpdate, int? cartIndex,) {
    for(int index = 0; index<_cartList.length; index++) {
      if(_cartList[index].product?.id == productId
          && (_cartList[index].variation!.length > 0
              ? _cartList[index].variation![0].type == variationType : true)) {


        if((isUpdate && index == cartIndex)) {
          return -1;
        }else {
          return index;
        }
      }
    }
    return -1;
  }

  int getCartIndex (int productID) {
    for(int index = 0; index < _cartList.length; index ++) {
      if(_cartList[index].product?.id == productID ) {
        return index;
      }
    }
    return -1;
  }



  void addToCart(CartModel cartModel, int? index) {
    print('index : $index');
    if(index != null && index != -1) {
      _cartList.replaceRange(index, index + 1, [cartModel]);

    }else {
      _cartList.add(cartModel);
    }
    cartRepo.addToCartList(_cartList);

    update();
  }

  void removeFromCart(int index) {
    _amount = _amount - (_cartList[index].discountedPrice! * _cartList[index].quantity!);
    _cartList.removeAt(index);
    cartRepo.addToCartList(_cartList);
    update();
  }

  void clearCartData() {
    _cartList = [];
    cartRepo.clearCartData();
    update();

  }







}
