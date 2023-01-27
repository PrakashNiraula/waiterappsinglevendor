class ConfigModel {
  String? currencySymbol;
  String? timeFormat;
  int? decimalPointSettings;
  bool? maintenanceMode;
  String? currencySymbolPosition;
  String? restaurantLogo;
  BaseUrls? baseUrls;
  List<Branch>? branch;
  List<PromotionCampaign>? promotionCampaign;

  ConfigModel(
      {this.currencySymbol,
        this.timeFormat,
        this.decimalPointSettings,
        this.maintenanceMode,
        this.currencySymbolPosition,
        this.baseUrls,
        this.branch,
        this.promotionCampaign,
        this.restaurantLogo,
      });

  ConfigModel.fromJson(Map<String, dynamic> json) {
    currencySymbol = json['currency_symbol'];
    timeFormat = json['time_format'];
    decimalPointSettings = json['decimal_point_settings'];
    maintenanceMode = json['maintenance_mode'];
    currencySymbolPosition = json['currency_symbol_position'];
    baseUrls = json['base_urls'] != null
        ? new BaseUrls.fromJson(json['base_urls'])
        : null;
    if (json['branch'] != null) {
      branch = <Branch>[];
      json['branch'].forEach((v) {
        branch!.add(new Branch.fromJson(v));
      });
    }
    if (json['promotion_campaign'] != null) {
      promotionCampaign = <PromotionCampaign>[];
      json['promotion_campaign'].forEach((v) {
        promotionCampaign!.add(new PromotionCampaign.fromJson(v));
      });
    }
    restaurantLogo = json['restaurant_logo'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currency_symbol'] = this.currencySymbol;
    data['time_format'] = this.timeFormat;
    data['decimal_point_settings'] = this.decimalPointSettings;
    data['maintenance_mode'] = this.maintenanceMode;
    data['currency_symbol_position'] = this.currencySymbolPosition;
    if (this.baseUrls != null) {
      data['base_urls'] = this.baseUrls!.toJson();
    }
    if (this.branch != null) {
      data['branch'] = this.branch!.map((v) => v.toJson()).toList();
    }
    if (this.promotionCampaign != null) {
      data['promotion_campaign'] =
          this.promotionCampaign!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BaseUrls {
  String? productImageUrl;
  String? customerImageUrl;
  String? bannerImageUrl;
  String? categoryImageUrl;
  String? categoryBannerImageUrl;
  String? reviewImageUrl;
  String? notificationImageUrl;
  String? restaurantImageUrl;
  String? deliveryManImageUrl;
  String? chatImageUrl;
  String? promotionalUrl;

  BaseUrls(
      {this.productImageUrl,
        this.customerImageUrl,
        this.bannerImageUrl,
        this.categoryImageUrl,
        this.categoryBannerImageUrl,
        this.reviewImageUrl,
        this.notificationImageUrl,
        this.restaurantImageUrl,
        this.deliveryManImageUrl,
        this.chatImageUrl,
        this.promotionalUrl});

  BaseUrls.fromJson(Map<String, dynamic> json) {
    productImageUrl = json['product_image_url'];
    customerImageUrl = json['customer_image_url'];
    bannerImageUrl = json['banner_image_url'];
    categoryImageUrl = json['category_image_url'];
    categoryBannerImageUrl = json['category_banner_image_url'];
    reviewImageUrl = json['review_image_url'];
    notificationImageUrl = json['notification_image_url'];
    restaurantImageUrl = json['restaurant_image_url'];
    deliveryManImageUrl = json['delivery_man_image_url'];
    chatImageUrl = json['chat_image_url'];
    promotionalUrl = json['promotional_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_image_url'] = this.productImageUrl;
    data['customer_image_url'] = this.customerImageUrl;
    data['banner_image_url'] = this.bannerImageUrl;
    data['category_image_url'] = this.categoryImageUrl;
    data['category_banner_image_url'] = this.categoryBannerImageUrl;
    data['review_image_url'] = this.reviewImageUrl;
    data['notification_image_url'] = this.notificationImageUrl;
    data['restaurant_image_url'] = this.restaurantImageUrl;
    data['delivery_man_image_url'] = this.deliveryManImageUrl;
    data['chat_image_url'] = this.chatImageUrl;
    data['promotional_url'] = this.promotionalUrl;
    return data;
  }
}

class Branch {
  int? id;
  String? name;
  String? email;
  String? password;
  String? latitude;
  String? longitude;
  String? address;
  int? status;
  int? branchPromotionStatus;
  String? createdAt;
  String? updatedAt;
  int? coverage;
  String? image;
  List<TableModel>? table;

  Branch(
      {this.id,
        this.name,
        this.email,
        this.password,
        this.latitude,
        this.longitude,
        this.address,
        this.status,
        this.branchPromotionStatus,
        this.createdAt,
        this.updatedAt,
        this.coverage,
        this.image,
        this.table});

  Branch.fromJson(Map<String, dynamic> json) {
    print('branch id : ${json['id']}');
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    status = json['status'];
    branchPromotionStatus = json['branch_promotion_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    coverage = json['coverage'];
    image = json['image'];
    if (json['table'] != null) {
      table =  [];

      json['table'].forEach((v) {
        table!.add(new TableModel.fromJson(v));
      });
      if(table!.isEmpty) {
        table?.add(TableModel(id: -1));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['address'] = this.address;
    data['status'] = this.status;
    data['branch_promotion_status'] = this.branchPromotionStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['coverage'] = this.coverage;
    data['image'] = this.image;
    if (this.table != null) {
      data['table'] = this.table!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TableModel {
  int? id;
  int? number;
  int? capacity;
  int? branchId;
  int? isActive;
  int? isAvailable;
  String? createdAt;
  String? updatedAt;

  TableModel(
      {this.id,
        this.number,
        this.capacity,
        this.branchId,
        this.isActive,
        this.isAvailable,
        this.createdAt,
        this.updatedAt});

  TableModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    number = json['number'];
    capacity = json['capacity'];
    branchId = json['branch_id'];
    isActive = json['is_active'];
    isAvailable = json['is_available'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['number'] = this.number;
    data['capacity'] = this.capacity;
    data['branch_id'] = this.branchId;
    data['is_active'] = this.isActive;
    data['is_available'] = this.isAvailable;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class PromotionCampaign {
  int? id;
  int? restaurantId;
  String? name;
  String? email;
  String? password;
  String? latitude;
  String? longitude;
  String? address;
  int? status;
  int? branchPromotionStatus;
  String? createdAt;
  String? updatedAt;
  int? coverage;
  String? image;
  List<BranchPromotion>? branchPromotion;

  PromotionCampaign(
      {this.id,
        this.restaurantId,
        this.name,
        this.email,
        this.password,
        this.latitude,
        this.longitude,
        this.address,
        this.status,
        this.branchPromotionStatus,
        this.createdAt,
        this.updatedAt,
        this.coverage,
        this.image,
        this.branchPromotion});

  PromotionCampaign.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    restaurantId = json['restaurant_id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    status = json['status'];
    branchPromotionStatus = json['branch_promotion_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    coverage = json['coverage'];
    image = json['image'];
    if (json['branch_promotion'] != null) {
      branchPromotion = <BranchPromotion>[];
      json['branch_promotion'].forEach((v) {
        branchPromotion!.add(new BranchPromotion.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['restaurant_id'] = this.restaurantId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['address'] = this.address;
    data['status'] = this.status;
    data['branch_promotion_status'] = this.branchPromotionStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['coverage'] = this.coverage;
    data['image'] = this.image;
    if (this.branchPromotion != null) {
      data['branch_promotion'] =
          this.branchPromotion!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BranchPromotion {
  int? id;
  int? branchId;
  String? promotionType;
  String? promotionName;
  String? createdAt;
  String? updatedAt;

  BranchPromotion(
      {this.id,
        this.branchId,
        this.promotionType,
        this.promotionName,
        this.createdAt,
        this.updatedAt});

  BranchPromotion.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    branchId = json['branch_id'];
    promotionType = json['promotion_type'];
    promotionName = json['promotion_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['branch_id'] = this.branchId;
    data['promotion_type'] = this.promotionType;
    data['promotion_name'] = this.promotionName;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
