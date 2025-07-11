import 'package:flutter/material.dart';
import 'package:nossa_app_hackton/src/presentation/utils/app_consts_utils.dart';

class CustomButtonComponent extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final Color? backgroundColor;
  const CustomButtonComponent({super.key, this.onPressed, required this.text, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      width: double.infinity,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor ?? AppConstsUtils.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          )
        ),
        onPressed: onPressed,
        
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: AppConstsUtils.fontBold
          )
        ),
      ),
    );
  }
}