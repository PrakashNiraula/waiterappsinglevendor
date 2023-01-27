import 'package:get/get.dart';

class OrderDetails {
  Order? order;
  List<Details>? details;

  OrderDetails({this.order, this.details});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    order = json['order'] != null ? new Order.fromJson(json['order']) : null;
    if (json['details'] != null) {
      details = <Details>[];
      json['details'].forEach((v) {
        details!.add(new Details.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.order != null) {
      data['order'] = this.order!.toJson();
    }
    if (this.details != null) {
      data['details'] = this.details!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Order {
  int? id;
  double? orderAmount;
  int? couponDiscountAmount;
  String? couponDiscountTitle;
  String? paymentStatus;
  String? orderStatus;
  int? totalTaxAmount;
  String? paymentMethod;
  String? createdAt;
  String? updatedAt;
  int? checked;
  String? orderNote;
  String? couponCode;
  String? orderType;
  int? branchId;
  String? deliveryDate;
  String? deliveryTime;
  String? extraDiscount;
  int? preparationTime;
  int? tableId;
  int? numberOfPeople;
  int? tableOrderId;

  Order(
      {this.id,
        this.orderAmount,
        this.couponDiscountAmount,
        this.couponDiscountTitle,
        this.paymentStatus,
        this.orderStatus,
        this.totalTaxAmount,
        this.paymentMethod,
        this.createdAt,
        this.updatedAt,
        this.checked,
        this.orderNote,
        this.couponCode,
        this.orderType,
        this.branchId,
        this.deliveryDate,
        this.deliveryTime,
        this.extraDiscount,
        this.preparationTime,
        this.tableId,
        this.numberOfPeople,
        this.tableOrderId});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderAmount = double.parse('${json['order_amount']}');
    couponDiscountAmount = json['coupon_discount_amount'];
    couponDiscountTitle = json['coupon_discount_title'];
    paymentStatus = json['payment_status'];
    orderStatus = json['order_status'];
    totalTaxAmount = json['total_tax_amount'];
    paymentMethod = json['payment_method'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    checked = json['checked'];
    orderNote = json['order_note'];
    couponCode = json['coupon_code'];
    orderType = json['order_type'];
    branchId = json['branch_id'];
    deliveryDate = json['delivery_date'];
    deliveryTime = json['delivery_time'];
    extraDiscount = json['extra_discount'];
    preparationTime = json['preparation_time'];
    tableId = json['table_id'];
    numberOfPeople = json['number_of_people'];
    tableOrderId = json['table_order_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_amount'] = this.orderAmount;
    data['coupon_discount_amount'] = this.couponDiscountAmount;
    data['coupon_discount_title'] = this.couponDiscountTitle;
    data['payment_status'] = this.paymentStatus;
    data['order_status'] = this.orderStatus;
    data['total_tax_amount'] = this.totalTaxAmount;
    data['payment_method'] = this.paymentMethod;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['checked'] = this.checked;
    data['order_note'] = this.orderNote;
    data['coupon_code'] = this.couponCode;
    data['order_type'] = this.orderType;
    data['branch_id'] = this.branchId;
    data['delivery_date'] = this.deliveryDate;
    data['delivery_time'] = this.deliveryTime;
    data['extra_discount'] = this.extraDiscount;
    data['preparation_time'] = this.preparationTime;
    data['table_id'] = this.tableId;
    data['number_of_people'] = this.numberOfPeople;
    data['table_order_id'] = this.tableOrderId;
    return data;
  }
}

class Details {
  int? id;
  int? productId;
  int? orderId;
  double? price;
  ProductDetails? productDetails;
  Variations? variation;
  double? discountOnProduct;
  String? discountType;
  int? quantity;
  double? taxAmount;
  String? createdAt;
  String? updatedAt;
  List<dynamic>? addOnIds;
  List<dynamic>? addOnQtys;

  Details(
      {this.id,
        this.productId,
        this.orderId,
        this.price,
        this.productDetails,
        this.variation,
        this.discountOnProduct,
        this.discountType,
        this.quantity,
        this.taxAmount,
        this.createdAt,
        this.updatedAt,
        this.addOnIds,
        this.addOnQtys});

  Details.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    orderId = json['order_id'];
    if(json['price'] != null && json['price'] != 'null') {
      price = double.parse('${json['price']}');
    }
    productDetails = json['product_details'] != null
        ? new ProductDetails.fromJson(json['product_details'])
        : null;
    if(json['variation'] != null) {
      variation = Variations.fromJson(json['variation']);
    }
    discountOnProduct = double.parse('${json['discount_on_product']}');
    discountType = json['discount_type'];
    quantity = json['quantity'];
    taxAmount = double.parse('${json['tax_amount']}');
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];

    if(json['add_on_ids'] != null) {
      addOnIds = [];
      json['add_on_ids'].forEach((id) {
        try {
          addOnIds!.add( int.parse(id));
        }catch(e) {
          addOnIds!.add(id);
        }

      });
    }

    if(json['add_on_qtys'] != null) {
      addOnQtys = [];
      json['add_on_qtys'].forEach((qun) {
        try {
          addOnQtys!.add( int.parse(qun));
        }catch(e) {
          addOnQtys!.add(qun);
        }

      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['order_id'] = this.orderId;
    data['price'] = this.price;
    if (this.productDetails != null) {
      data['product_details'] = this.productDetails!.toJson();
    }
    data['variation'] = this.variation;
    data['discount_on_product'] = this.discountOnProduct;
    data['discount_type'] = this.discountType;
    data['quantity'] = this.quantity;
    data['tax_amount'] = this.taxAmount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['add_on_ids'] = this.addOnIds;
    data['add_on_qtys'] = this.addOnQtys;
    return data;
  }
}

class ProductDetails {
  int? id;
  String? name;
  String? description;
  String? image;
  double? price;
  List<Variations>? variations;
  List<AddOns>? addOns;
  num? tax;
  String? availableTimeStarts;
  String? availableTimeEnds;
  int? status;
  String? createdAt;
  String? updatedAt;
  List<String>? attributes;
  List<CategoryIds>? categoryIds;
  List<ChoiceOptions>? choiceOptions;
  int? discount;
  String? discountType;
  String? taxType;
  int? setMenu;
  int? branchId;
  int? popularityCount;
  String? productType;

  ProductDetails(
      {this.id,
        this.name,
        this.description,
        this.image,
        this.price,
        this.variations,
        this.addOns,
        this.tax,
        this.availableTimeStarts,
        this.availableTimeEnds,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.attributes,
        this.categoryIds,
        this.choiceOptions,
        this.discount,
        this.discountType,
        this.taxType,
        this.setMenu,
        this.branchId,
        this.popularityCount,
        this.productType,
      });

  ProductDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
    if(json['price'] != null && json['price'] != 'null') {
      price = double.parse('${json['price']}');
    }
    if (json['variations'] != null) {
      variations = <Variations>[];
      json['variations'].forEach((v) {
        variations!.add(new Variations.fromJson(v));
      });
    }
    if (json['add_ons'] != null) {
      addOns = <AddOns>[];
      json['add_ons'].forEach((v) {
        addOns!.add(new AddOns.fromJson(v));
      });
    }
    tax = json['tax'];
    availableTimeStarts = json['available_time_starts'];
    availableTimeEnds = json['available_time_ends'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    attributes = json['attributes'].cast<String>();
    if (json['category_ids'] != null) {
      categoryIds = <CategoryIds>[];
      json['category_ids'].forEach((v) {
        categoryIds!.add(new CategoryIds.fromJson(v));
      });
    }
    if (json['choice_options'] != null) {
      choiceOptions = <ChoiceOptions>[];
      json['choice_options'].forEach((v) {
        choiceOptions!.add(new ChoiceOptions.fromJson(v));
      });
    }
    discount = json['discount'];
    discountType = json['discount_type'];
    taxType = json['tax_type'];
    setMenu = json['set_menu'];
    branchId = json['branch_id'];
    popularityCount = json['popularity_count'];
    productType = json['product_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['image'] = this.image;
    data['price'] = this.price;
    if (this.variations != null) {
      data['variations'] = this.variations!.map((v) => v.toJson()).toList();
    }
    if (this.addOns != null) {
      data['add_ons'] = this.addOns!.map((v) => v.toJson()).toList();
    }
    data['tax'] = this.tax;
    data['available_time_starts'] = this.availableTimeStarts;
    data['available_time_ends'] = this.availableTimeEnds;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['attributes'] = this.attributes;
    if (this.categoryIds != null) {
      data['category_ids'] = this.categoryIds!.map((v) => v.toJson()).toList();
    }
    if (this.choiceOptions != null) {
      data['choice_options'] =
          this.choiceOptions!.map((v) => v.toJson()).toList();
    }
    data['discount'] = this.discount;
    data['discount_type'] = this.discountType;
    data['tax_type'] = this.taxType;
    data['set_menu'] = this.setMenu;
    data['branch_id'] = this.branchId;
    data['popularity_count'] = this.popularityCount;
    data['product_type'] = this.productType;
    return data;
  }
}

class Variations {
  String? type;
  double? price;

  Variations({this.type, this.price});



  Variations.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    if(json['price'] != null && json['price'] != 'null') {
      price = double.parse('${json['price']}');
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['price'] = this.price;
    return data;
  }
}

class AddOns {
  int? id;
  String? name;
  double? price;
  String? createdAt;
  String? updatedAt;

  AddOns(
      {this.id,
        this.name,
        this.price,
        this.createdAt,
        this.updatedAt,
      });

  AddOns.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = double.parse('${json['price']}');
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}


class CategoryIds {
  String? id;
  int? position;

  CategoryIds({this.id, this.position});

  CategoryIds.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['position'] = this.position;
    return data;
  }
}

class ChoiceOptions {
  String? name;
  String? title;
  List<String>? options;

  ChoiceOptions({this.name, this.title, this.options});

  ChoiceOptions.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    title = json['title'];
    options = json['options'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['title'] = this.title;
    data['options'] = this.options;
    return data;
  }
}

class OrderList {
  List<Order>? order;

  OrderList({this.order});

  OrderList.fromJson(Map<String, dynamic> json) {
    if (json['order'] != null) {
      order = <Order>[];
      json['order'].forEach((v) {
        order!.addIf( (Order.fromJson(v).orderStatus != 'canceled'), Order.fromJson(v));

      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.order != null) {
      data['order'] = this.order!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}