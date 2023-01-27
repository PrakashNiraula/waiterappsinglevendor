import 'package:efood_table_booking/data/model/response/product_model.dart';


class PlaceOrderBody {
  List<Cart>? _cart;
  double? _orderAmount;

  List<Cart>? get cart => _cart;
  String? _paymentMethod;
  String? _orderNote;
  String? _deliveryTime;
  String? _deliveryDate;
  String? _branchId;
  int? _tableNumber;
  int? _peopleNumber;
  String? _paymentStatus;
  String? _branchTableToken;

  PlaceOrderBody(
      this._cart,
      this._orderAmount,
      this._paymentMethod,
      this._orderNote,
      this._deliveryTime,
      this._deliveryDate,
      this._tableNumber,
      this._peopleNumber,
      this._branchId,
      this._paymentStatus,
      this._branchTableToken,
      );



  PlaceOrderBody copyWith({String? paymentStatus, String? paymentMethod, String? token, double? previousDue}) {
    if(paymentStatus != null) {
      _paymentStatus = paymentStatus;
    }
    if(paymentMethod != null) {
      _paymentMethod = paymentMethod;
    }
    if(token != null) {
      _branchTableToken = token;
    }
    if(previousDue != null) {
      _orderAmount = _orderAmount! - previousDue;
    }
    return this;
  }







  PlaceOrderBody.fromJson(Map<String, dynamic> json) {
    if (json['cart'] != null) {
      _cart = [];
      json['cart'].forEach((v) {
        _cart?.add(new Cart.fromJson(v));
      });
    }
    _orderAmount = json['order_amount'];
    _paymentMethod = json['payment_method'];
    _orderNote = json['order_note'];
    _deliveryTime = json['delivery_time'];
    _deliveryDate = json['delivery_date'];
    _tableNumber = json['table_id'];
    _peopleNumber = json['number_of_people'];
    _branchId = json['branch_id'];
    _paymentStatus = json['payment_status'];
    _branchTableToken = json['branch_table_token'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._cart != null) {
      data['cart'] = this._cart?.map((v) => v.toJson()).toList();
    }

    data['order_amount'] = this._orderAmount;
    data['payment_method'] = this._paymentMethod;
    data['order_note'] = this._orderNote;
    data['delivery_time'] = this._deliveryTime;
    data['delivery_date'] = this._deliveryDate;
    data['table_id'] = this._tableNumber;
    data['number_of_people'] = this._peopleNumber;
    data['branch_id'] = this._branchId;
    data['payment_status'] = this._paymentStatus;
    data['branch_table_token'] = this._branchTableToken;

    return data;
  }

  double? get orderAmount => _orderAmount;

  String? get paymentMethod => _paymentMethod;

  String? get orderNote => _orderNote;
  String? get deliveryTime => _deliveryTime;
  String? get deliveryDate => _deliveryDate;
  int? get tableNumber => _tableNumber;
  int? get peopleNumber => _peopleNumber;
  String? get paymentStatus => _paymentStatus;
  String? get branchTableToken => _branchTableToken;
}

class Cart {
  String? _productId;
  String? _price;
  String? _variant;
  List<Variation>? _variation;
  double? _discountAmount;
  int? _quantity;
  double? _taxAmount;
  List<int>? _addOnIds;
  List<int>? _addOnQtys;

  Cart(
      String productId,
      String price,
      String variant,
      List<Variation> variation,
      double discountAmount,
      int quantity,
      double taxAmount,
      List<int> addOnIds,
      List<int> addOnQtys) {
    this._productId = productId;
    this._price = price;
    this._variant = variant;
    this._variation = variation;
    this._discountAmount = discountAmount;
    this._quantity = quantity;
    this._taxAmount = taxAmount;
    this._addOnIds = addOnIds;
    this._addOnQtys = addOnQtys;
  }

  String? get productId => _productId;
  String? get price => _price;
  String? get variant => _variant;
  List<Variation>? get variation => _variation;
  double? get discountAmount => _discountAmount;
  int? get quantity => _quantity;
  double? get taxAmount => _taxAmount;
  List<int>? get addOnIds => _addOnIds;
  List<int>? get addOnQtys => _addOnQtys;

  Cart.fromJson(Map<String, dynamic> json) {
    _productId = json['product_id'];
    _price = json['price'];
    _variant = json['variant'];
    if (json['variation'] != null) {
      _variation = [];
      json['variation'].forEach((v) {
        _variation?.add(new Variation.fromJson(v));
      });
    }
    _discountAmount = json['discount_amount'];
    _quantity = json['quantity'];
    _taxAmount = json['tax_amount'];
    _addOnIds = json['add_on_ids'].cast<int>();
    _addOnQtys = json['add_on_qtys'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this._productId;
    data['price'] = this._price;
    data['variant'] = this._variant;
    if (this._variation != null) {
      data['variation'] = this._variation?.map((v) => v.toJson()).toList();
    }
    data['discount_amount'] = this._discountAmount;
    data['quantity'] = this._quantity;
    data['tax_amount'] = this._taxAmount;
    data['add_on_ids'] = this._addOnIds;
    data['add_on_qtys'] = this._addOnQtys;
    return data;
  }
}