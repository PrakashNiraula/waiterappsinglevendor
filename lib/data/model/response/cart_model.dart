import 'package:efood_table_booking/data/model/response/product_model.dart';

class CartModel {
  double? price;
  double? discountedPrice;
  List<Variation>? variation;
  double? discountAmount;
  int? quantity;
  double? taxAmount;
  List<AddOn>? addOnIds;
  Product? product;

  CartModel({
    this.price,
    this.discountedPrice,
    this.variation,
    this.discountAmount,
    this.quantity,
    this.taxAmount,
    this.addOnIds,
    this.product,
  });

   CartModel.fromJson(Map<String, dynamic> json) {
    price = json['price'].toDouble();
    discountedPrice = json['discounted_price'].toDouble();
    if (json['variation'] != null) {
      variation = [];
      json['variation'].forEach((v) {
        variation?.add(new Variation.fromJson(v));
      });
    }
    discountAmount = json['discount_amount'].toDouble();
    quantity = json['quantity'];
    taxAmount = json['tax_amount'].toDouble();
    if (json['add_on_ids'] != null) {
      addOnIds = [];
      json['add_on_ids'].forEach((v) {
        addOnIds?.add(new AddOn.fromJson(v));
      });
    }
    if (json['product'] != null) {
      product = Product.fromJson(json['product']);

    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this.price;
    data['discounted_price'] = this.discountedPrice;
    if (this.variation != null) {
      data['variation'] = this.variation?.map((v) => v.toJson()).toList();
    }
    data['discount_amount'] = this.discountAmount;
    data['quantity'] = this.quantity;
    data['tax_amount'] = this.taxAmount;
    if (this.addOnIds != null) {
      data['add_on_ids'] = this.addOnIds?.map((v) => v.toJson()).toList();
    }
    data['product'] = this.product?.toJson();
    return data;
  }
}

// class AddOn {
//   int? _id;
//   int? _quantity;
//
//   AddOn({int? id,  int? quantity}) {
//     this._id = id;
//     this._quantity = quantity!;
//   }
//
//   int? get id => _id;
//   int? get quantity => _quantity;
//
//   AddOn.fromJson(Map<String, dynamic> json) {
//     _id = json['id'];
//     _quantity = json['quantity'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this._id;
//     data['quantity'] = this._quantity;
//     return data;
//   }
// }
