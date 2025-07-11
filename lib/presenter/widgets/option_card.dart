import 'package:flutter/material.dart';

class OptionCard extends StatelessWidget {
  String title;
  String icon;
  Widget? iconData;

  OptionCard({
    super.key,
    required this.title,
    required this.icon,
    this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.35,
      height: size.width * 0.35,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Color(0xffe5e5e5),
                blurRadius: 5,
                spreadRadius: 0.7,
                offset: Offset(0, 0.0))
          ],
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            iconData == null
                ? Image(image: AssetImage(icon))
                : iconData as Widget,
            SizedBox(
              height: 10,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
