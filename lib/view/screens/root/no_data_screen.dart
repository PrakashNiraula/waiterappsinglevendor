import 'package:efood_table_booking/util/dimensions.dart';
import 'package:efood_table_booking/util/images.dart';
import 'package:efood_table_booking/util/styles.dart';
import 'package:flutter/material.dart';

class NoDataScreen extends StatelessWidget {
  final String text;
  NoDataScreen({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.paddingSizeLarge),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.stretch, children: [

        Image.asset(
          Images.empty_box,
          width: MediaQuery.of(context).size.height * 0.22, height: MediaQuery.of(context).size.height * 0.22,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.03),

        Text(
          text,
          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.titleLarge?.color),
          textAlign: TextAlign.center,
        ),

      ]),
    );
  }
}
