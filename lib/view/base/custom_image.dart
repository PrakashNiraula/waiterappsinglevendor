import 'package:efood_table_booking/util/images.dart';
import 'package:flutter/cupertino.dart';

class CustomImage extends StatelessWidget {
  final String image;
  final double? height;
  final double? width;
  final BoxFit fit;
  final String placeholder;
  CustomImage({required this.image, this.height, this.width, this.fit = BoxFit.cover, this.placeholder = Images.placeholder_image});

  @override
  Widget build(BuildContext context) {
    return FadeInImage.assetNetwork(
      image: image, height: height, width: width, fit: fit,
      placeholder: placeholder,
      imageErrorBuilder: (context, url, error) => Image.asset(placeholder, height: height, width: width, fit: fit, filterQuality: FilterQuality.low,),
    );
  }
}
