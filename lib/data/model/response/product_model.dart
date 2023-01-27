// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

class ProductModel {
    ProductModel({
        this.totalSize,
        this.limit,
        this.offset,
        this.products,
    });

    int? totalSize;
    String? limit;
    String? offset;
    List<Product>? products;

    factory ProductModel.fromRawJson(String str) => ProductModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        totalSize: json["total_size"],
        limit: json["limit"],
        offset: json["offset"],
        products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "total_size": totalSize,
        "limit": limit,
        "offset": offset,
        "products": List<dynamic>.from(products!.map((x) => x.toJson())),
    };
}

class Product {
    Product({
        this.id,
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
        this.popularityCount,
        this.rating,
        this.productType,
    });

    int? id;
    String? name;
    String? description;
    String? image;
    double? price;
    List<Variation>? variations;
    List<AddOn>? addOns;
    double? tax;
    String? availableTimeStarts;
    String? availableTimeEnds;
    int? status;
    DateTime? createdAt;
    DateTime? updatedAt;
    List<String>? attributes;
    List<CategoryId>? categoryIds;
    List<ChoiceOption>? choiceOptions;
    double? discount;
    String? discountType;
    String? taxType;
    int? setMenu;
    int? popularityCount;
    List<Rating>? rating;
    String? productType;

    // factory Product.fromRawJson(String str) => Product.fromJson(json.decode(str));

    // String toRawJson() => json.encode(toJson());

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        description: json["description"] == null ? '' : json["description"],
        image: json["image"],
        price: double.parse('${json["price"]}'),
        variations: List<Variation>.from(json["variations"].map((x) => Variation.fromJson(x))),
        addOns: List<AddOn>.from(json["add_ons"].map((x) => AddOn.fromJson(x))),
        tax: json["tax"].toDouble(),
        availableTimeStarts: json["available_time_starts"],
        availableTimeEnds: json["available_time_ends"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        attributes: List<String>.from(json["attributes"].map((x) => x)),
        categoryIds: List<CategoryId>.from(json["category_ids"].map((x) => CategoryId.fromJson(x))),
        choiceOptions: List<ChoiceOption>.from(json["choice_options"].map((x) => ChoiceOption.fromJson(x))),
        discount: double.parse('${json["discount"]}'),
        discountType: json["discount_type"],
        taxType: json["tax_type"],
        setMenu: json["set_menu"],
        popularityCount: json["popularity_count"],
        rating: List<Rating>.from(json["rating"].map((x) => Rating.fromJson(x))),
        productType: json["product_type"],

    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "image": image,
        "price": price,
        "variations": List<dynamic>.from(variations!.map((x) => x.toJson())),
        "add_ons": List<dynamic>.from(addOns!.map((x) => x.toJson())),
        "tax": tax,
        "available_time_starts": availableTimeStarts,
        "available_time_ends": availableTimeEnds,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "attributes": List<dynamic>.from(attributes!.map((x) => x)),
        "category_ids": List<dynamic>.from(categoryIds!.map((x) => x.toJson())),
        "choice_options": List<dynamic>.from(choiceOptions!.map((x) => x.toJson())),
        "discount": discount,
        "discount_type": discountType,
        "tax_type": taxType,
        "set_menu": setMenu,
        "popularity_count": popularityCount,
        "rating": rating != null ? List<dynamic>.from(rating!.map((x) => x.toJson())) : null,
        "product_type": productType,
    };
}


class AddOn {
    AddOn({
        this.id,
        this.name,
        this.price,
        this.quantity,
    });

    int? id;
    String? name;
    double? price;
    int? quantity;

    factory AddOn.fromRawJson(String str) => AddOn.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory AddOn.fromJson(Map<String, dynamic> json) {
        return AddOn(
        id: json["id"],
        name: json["name"],
        price: double.tryParse('${json["price"]}'),
        quantity:  json['quantity'],
    );}

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "quantity": quantity,

    };
}


class CategoryId {
    CategoryId({
        this.id,
        this.position,
    });

    String? id;
    int? position;

    factory CategoryId.fromRawJson(String str) => CategoryId.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CategoryId.fromJson(Map<String, dynamic> json) => CategoryId(
        id: json["id"],
        position: json["position"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "position": position,
    };
}

class ChoiceOption {
    ChoiceOption({
        this.name,
        this.title,
        this.options,
    });

    String? name;
    String? title;
    List<String>? options;

    factory ChoiceOption.fromRawJson(String str) => ChoiceOption.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ChoiceOption.fromJson(Map<String, dynamic> json) => ChoiceOption(
        name: json["name"],
        title: json["title"],
        options: List<String>.from(json["options"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "title": title,
        "options": options != null ? List<dynamic>.from(options!.map((x) => x)) : null,
    };
}

class Rating {
    Rating({
        this.average,
        this.productId,
    });

    double? average;
    int? productId;

    factory Rating.fromRawJson(String str) => Rating.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        average: double.tryParse('${json["average"]}'),
        productId: json["product_id"],
    );

    Map<String, dynamic> toJson() => {
        "average": average,
        "product_id": productId,
    };
}

class Variation {
    Variation({
        this.type,
        this.price,
    });

    String? type;
    double? price;

    factory Variation.fromRawJson(String str) => Variation.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Variation.fromJson(Map<String, dynamic> json) => Variation(
        type: json["type"],
        price: double.tryParse('${json["price"]}'),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "price": price,
    };
}

class EnumValues<T> {
    Map<String, T> map;
    Map<T, String>? reverseMap;

    EnumValues(this.map);

    Map<T, String>? get reverse {
        if (reverseMap == null) {
            reverseMap = map.map((k, v) => new MapEntry(v, k));
        }
        return reverseMap;
    }
}
