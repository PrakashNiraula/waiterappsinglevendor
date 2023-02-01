import 'package:efood_table_booking/controller/promotional_controller.dart';
import 'package:efood_table_booking/controller/splash_controller.dart';
import 'package:efood_table_booking/data/model/response/config_model.dart';
import 'package:efood_table_booking/helper/responsive_helper.dart';
import 'package:efood_table_booking/helper/route_helper.dart';
import 'package:efood_table_booking/util/dimensions.dart';
import 'package:efood_table_booking/util/styles.dart';
import 'package:efood_table_booking/view/base/custom_button.dart';
import 'package:efood_table_booking/view/screens/promotional_page/promotional_page_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingWidget extends StatefulWidget {
  final bool formSplash;
  const SettingWidget({Key? key, required this.formSplash}) : super(key: key);

  @override
  State<SettingWidget> createState() => _SettingWidgetState();
}

class _SettingWidgetState extends State<SettingWidget> {
  List<String> _errorText = [];
  List<TableModel> postlist = [];
  @override
  void initState() {
    final _splashController = Get.find<SplashController>();

    if (_splashController.getBranchId() < 1) {
      _splashController.updateBranchId(null, isUpdate: false);
    } else {
      _splashController.updateBranchId(_splashController.getBranchId(),
          isUpdate: false);
    }
    TableModel? _table = _splashController.getTable(
        _splashController.getTableId(),
        branchId: _splashController.getBranchId());

    if (_table == null || _splashController.getTableId() < 1) {
      _splashController.updateFixTable(false, false);
      _splashController.updateTableId(null, isUpdate: false);
    } else {
      _splashController.updateTableId(_splashController.getTableId(),
          isUpdate: false);
      _splashController.updateFixTable(true, false);
    }
    _splashController.updateFixTable(_splashController.getIsFixTable(), false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GetBuilder<SplashController>(builder: (splashController) {
        return Container(
          width: Get.width * 0.4,
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius:
                BorderRadius.all(Radius.circular(Dimensions.RADIUS_SMALL)),
          ),
          padding: EdgeInsets.symmetric(
              vertical: Dimensions.paddingSizeExtraLarge,
              horizontal: Dimensions.paddingSizeLarge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'table_setup'.tr,
                  style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeLarge),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: Dimensions.paddingSizeExtraLarge),
              Container(
                height: 40,
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeDefault,
                ),
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius:
                        BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    border: Border.all(
                        color: Theme.of(context).primaryColor.withOpacity(0.4))
                    // boxShadow: [BoxShadow(color: Theme.of(context).cardColor, spreadRadius: 2, blurRadius: 5, offset: Offset(0, 5))],
                    ),
                child: DropdownButton<int>(
                  menuMaxHeight: Get.height * 0.5,
                  hint: Text(
                    'select_your_branch'.tr,
                    style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall),
                  ),
                  value: splashController.selectedBranchId,
                  items:
                      splashController.configModel?.branch?.map((Branch value) {
                    return DropdownMenuItem<int>(
                      value: value.id,
                      child: Text(
                        value.name ?? 'no branch',
                        style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    _errorText = [];
                    splashController.updateBranchId(value!);
                    splashController.updateTableId(null);
                  },
                  isExpanded: true,
                  underline: SizedBox(),
                ),
              ),
              SizedBox(height: Dimensions.paddingSizeDefault),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        'Table',
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                        ),
                      ),
                      Text(
                          '${splashController.configModel?.branch?.map((e) => e.table?[0].number)}'),
                      Text('Capacity'),
                      Text(
                          '${splashController.configModel?.branch?.map((e) => e.table?[0].capacity)}'),
                    ],
                  ),
                  // SizedBox(
                  //   width: Dimensions.paddingSizeDefault,
                  // ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    color: Colors.red,
                    child: Column(
                      children: [
                        Text(
                          'Table',
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                          ),
                        ),
                        Text(
                            '${splashController.configModel?.branch?.map((e) => e.table?[1].number)}'),
                        Text('Capacity'),
                        Text(
                            '${splashController.configModel?.branch?.map((e) => e.table?[2].capacity)}'),
                      ],
                    ),
                  ),
                  // SizedBox(
                  //   width: Dimensions.paddingSizeDefault,
                  // ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    color: Colors.red,
                    child: Column(
                      children: [
                        Text(
                          'Table',
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                          ),
                        ),
                        Text(
                            '${splashController.configModel?.branch?.map((branch) => branch.table?[3].number)}'),
                        Text('Capacity'),
                        Text(
                            '${splashController.configModel?.branch?.map((branch) => branch.table?[3].capacity)}')
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    color: Colors.grey,
                    child: Column(
                      children: [
                        Text(
                          'Table',
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                          ),
                        ),
                        Text(
                            '${splashController.configModel?.branch?.map((branch) => branch.table?[4].number)}'),
                        Text('Capacity'),
                        Text(
                            '${splashController.configModel?.branch?.map((branch) => branch.table?[4].capacity)}')
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.paddingSizeDefault),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        'Table',
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                        ),
                      ),
                      Text(
                          '${splashController.configModel?.branch?.map((branch) => branch.table?[5].number)}'),
                      Text('Capacity'),
                      Text(
                          '${splashController.configModel?.branch?.map((branch) => branch.table?[5].capacity)}')
                    ],
                  ),
                  // SizedBox(
                  //   width: Dimensions.paddingSizeDefault,
                  // ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    color: Colors.red,
                    child: Column(
                      children: [
                        Text(
                          'Table',
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                          ),
                        ),
                        Text(
                            '${splashController.configModel?.branch?.map((branch) => branch.table?[6].number)}'),
                        Text('Capacity'),
                        Text(
                            '${splashController.configModel?.branch?.map((branch) => branch.table?[6].capacity)}')
                      ],
                    ),
                  ),
                  // SizedBox(
                  //   width: Dimensions.paddingSizeDefault,
                  // ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    color: Colors.red,
                    child: Column(
                      children: [
                        Text(
                          'Table',
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                          ),
                        ),
                        Text(
                            '${splashController.configModel?.branch?.map((branch) => branch.table?[7].number)}'),
                        Text('Capacity'),
                        Text(
                            '${splashController.configModel?.branch?.map((branch) => branch.table?[7].capacity)}')
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    color: Colors.grey,
                    child: Column(
                      children: [
                        Text(
                          'Table',
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                          ),
                        ),
                        Text(
                            '${splashController.configModel?.branch?.map((branch) => branch.table?[8].number)}'),
                        Text('Capacity'),
                        Text(
                            '${splashController.configModel?.branch?.map((branch) => branch.table?[8].capacity)}')
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.paddingSizeDefault),
              Row(
                children: [
                  Column(
                    children: [
                      Text(
                        'Table',
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                        ),
                      ),
                      Text(
                          '${splashController.configModel?.branch?.map((branch) => branch.table?[9].number)}'),
                      Text('Capacity'),
                      Text(
                          '${splashController.configModel?.branch?.map((branch) => branch.table?[9].capacity)}')
                    ],
                  ),
                  SizedBox(
                    width: Dimensions.paddingSizeDefault,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    color: Colors.red,
                    child: Column(
                      children: [
                        Text(
                          'Table',
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                          ),
                        ),
                        Text(
                            '${splashController.configModel?.branch?.map((branch) => branch.table?[10].number)}'),
                        Text('Capacity'),
                        Text(
                            '${splashController.configModel?.branch?.map((branch) => branch.table?[10].capacity)}')
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.paddingSizeDefault),
              Text(
                'set_fix_table_number'.tr,
                style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault),
              ),
              SizedBox(height: Dimensions.paddingSizeDefault),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 100,
                    child: RadioListTile(
                      activeColor: Theme.of(context).primaryColor,
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      visualDensity: const VisualDensity(
                        horizontal: VisualDensity.minimumDensity,
                        vertical: VisualDensity.minimumDensity,
                      ),
                      title: Text('yes'.tr, style: robotoRegular),
                      value: true,
                      groupValue: splashController.isFixTable,
                      onChanged: (bool? value) {
                        if (splashController.selectedBranchId != null) {
                          splashController.updateFixTable(true, true);
                        } else {
                          splashController.updateFixTable(true, true);
                          Future.delayed(Duration(milliseconds: 300))
                              .then((value) {
                            _errorText = [];
                            _errorText.add('please_select_your_branch'.tr);
                            splashController.updateFixTable(false, true);
                          });
                        }
                        splashController.updateTableId(null);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: RadioListTile(
                      activeColor: Theme.of(context).primaryColor,
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      visualDensity: const VisualDensity(
                        horizontal: VisualDensity.minimumDensity,
                        vertical: VisualDensity.minimumDensity,
                      ),
                      title: Text('no'.tr, style: robotoRegular),
                      value: splashController.isFixTable,
                      groupValue: false,
                      onChanged: (bool? value) =>
                          splashController.updateFixTable(false, true),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.paddingSizeDefault),
              if (splashController.isFixTable &&
                  splashController.selectedBranchId != null)
                Container(
                  height: 40,
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeDefault,
                  ),
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius:
                          BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      border: Border.all(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.4))
                      // boxShadow: [BoxShadow(color: Theme.of(context).cardColor, spreadRadius: 2, blurRadius: 5, offset: Offset(0, 5))],
                      ),
                  child: DropdownButton<int>(
                    menuMaxHeight: Get.height * 0.5,
                    borderRadius:
                        BorderRadius.circular(Dimensions.RADIUS_DEFAULT),
                    hint: Text(
                      'set_your_table_number'.tr,
                      style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall),
                    ),
                    value: splashController.selectedTableId,
                    items: splashController.configModel?.branch
                        ?.firstWhere((branch) =>
                            branch.id == splashController.selectedBranchId)
                        .table
                        ?.map((value) {
                      return DropdownMenuItem<int>(
                        value: value.id,
                        child: Text(
                          '${value.id == -1 ? 'no_table_available'.tr : value.number}',
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      splashController.updateTableId(value == -1 ? null : value,
                          isUpdate: true);
                    },
                    isExpanded: true,
                    underline: SizedBox(),
                  ),
                ),
              if (_errorText.isNotEmpty)
                Text(_errorText.first,
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: Theme.of(context).errorColor,
                    )),
              SizedBox(height: Dimensions.paddingSizeDefault),
              CustomButton(
                height: 40,
                width: 200,
                buttonText: 'save'.tr,
                onPressed: () {
                  if (splashController.selectedTableId == null &&
                      splashController.isFixTable) {
                    _errorText = [];
                    _errorText.add('set_your_table_number'.tr);
                    splashController.update();
                  } else if (splashController.selectedBranchId == null) {
                    _errorText = [];
                    _errorText.add('please_select_your_branch'.tr);
                    splashController.update();
                  } else {
                    if (splashController.isFixTable) {
                      splashController.setFixTable(true);
                      splashController
                          .setTableId(splashController.selectedTableId!);
                    } else {
                      splashController.setFixTable(false);
                      splashController.setTableId(-1);
                    }

                    print('table number : ---${splashController.getTableId()}');

                    splashController
                        .setBranch(splashController.selectedBranchId!);
                    if (widget.formSplash) {
                      if (ResponsiveHelper.isTab(context) &&
                          (Get.find<PromotionalController>()
                              .getPromotion('', all: true)
                              .isNotEmpty)) {
                        Get.offAll(() => PromotionalPageScreen());
                      } else {
                        Get.offAllNamed(RouteHelper.home);
                      }
                    } else {
                      Get.find<PromotionalController>().update();
                      Get.back();
                    }
                  }
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
