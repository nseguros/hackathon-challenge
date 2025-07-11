import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:nossa_app_hackton/src/presentation/utils/app_consts_utils.dart';
import 'package:nossa_app_hackton/src/presentation/utils/navigator_util.dart';
import 'package:nossa_app_hackton/src/presentation/utils/size_device_util.dart';

import '../login_page/login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3)).then((value) {
      if(mounted) {
        NavigatorUtils.gotoWithoutReturn(context, page: const LoginPage());
      }
      
    });
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppConstsUtils.backgroundSaude,
            fit: BoxFit.cover,
          ),

          Container(
            height: context.sizeDevice.height,
            width: context.sizeDevice.width,
            decoration: BoxDecoration(
              color: AppConstsUtils.primaryColor.withValues(alpha: .5),
            ),
          ),

          Positioned(
            top: -(context.sizeDevice.height / 30),
            right: - (context.sizeDevice.width / 6),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppConstsUtils.secondaryColor,
                  width: 1
                ),
              ),
              child: Container(
                height: context.sizeDevice.height / 4,
                width: context.sizeDevice.height / 4,
                decoration: BoxDecoration(
                  color: AppConstsUtils.secondaryColor,
                  shape: BoxShape.circle
                ),
              ),
            ),
          ),

          Positioned(
            bottom: - (context.sizeDevice.width / 6),
            left: - (context.sizeDevice.width / 6),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppConstsUtils.secondaryColor,
                  width: 1
                ),
              ),
              child: Container(
                height: context.sizeDevice.height / 2.5,
                width: context.sizeDevice.height / 2.5,
                decoration: BoxDecoration(
                  color: AppConstsUtils.secondaryColor,
                  shape: BoxShape.circle
                ),
              ),
            ),
          ),

          Center(
            child: Pulse(
              infinite: true,
              duration: const Duration(seconds: 2),
              child: Image.asset(
                AppConstsUtils.logoWhite,
                height: context.sizeDevice.height / 4,
                width: context.sizeDevice.height / 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}