import 'package:flutter/material.dart';

class TabAppBar extends StatelessWidget implements PreferredSize{
  const TabAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).cardColor.withOpacity(0.1), offset: Offset(0, 6), blurRadius: 12, spreadRadius: -3,
            ),
          ]),
    );
  }

  @override
  // TODO: implement child
  Widget get child => throw PreferredSize(child: child, preferredSize: preferredSize);

  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw PreferredSize(child: child, preferredSize: preferredSize);
}
