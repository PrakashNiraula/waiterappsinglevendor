

class OrderSuccessModel {
  String? orderId;
  String? branchTableToken;
  double? changeAmount;
  String? tableId;
  String? branchId;

  OrderSuccessModel({this.orderId, this.branchTableToken, this.changeAmount, this.tableId, this.branchId});

  OrderSuccessModel.fromJson(Map<String, dynamic> json) {
    orderId = '${json['order_id']}';
    branchTableToken = json['branch_table_token'];
    // paidAmount = json['paid_amount'];
    changeAmount = json['change_amount'];
    tableId = json['table_id'];
    branchId = json['branch_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['branch_table_token'] = this.branchTableToken;
    // data['paid_amount'] = this.paidAmount ?? 0.0;
    data['change_amount'] = this.changeAmount ?? 0.0;
    data['table_id'] = this.tableId ?? -1;
    data['branch_id'] = this.branchId ?? -1;
    return data;
  }
}

class OrderSuccessModelList{
  List<OrderSuccessModel>? orderList;

  OrderSuccessModelList({this.orderList});

  OrderSuccessModelList.fromJson(Map<String, dynamic> json) {
    if (json['order_list'] != null) {
      orderList = <OrderSuccessModel>[];
      json['order_list'].forEach((v) {
        orderList!.add(new OrderSuccessModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orderList != null) {
      data['order_list'] = this.orderList!.map((v) => v.toJson()).toList();
    }
    return data;
  }

}
