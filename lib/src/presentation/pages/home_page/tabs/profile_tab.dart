import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nossa_app_hackton/src/presentation/components/custom_button_component.dart';
import 'package:nossa_app_hackton/src/presentation/utils/size_device_util.dart';

import '../../../utils/app_consts_utils.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppConstsUtils.secondaryColor,
                  width: 1
                )
              ),
              child: CircleAvatar(
                radius: context.sizeDevice.height / 15,
                backgroundImage: const AssetImage(AppConstsUtils.backgroundAutomovel),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Dorivaldo dos Santos',
              style: TextStyle(
                fontSize: context.sizeDevice.height / 30,
                fontFamily: AppConstsUtils.fontBold,
                color: AppConstsUtils.primaryColor
              )
            ),
            Text(
              'dorivaldodossantos20000@gmail.com',
              style: TextStyle(
                fontSize: context.sizeDevice.height / 50,
                fontFamily: AppConstsUtils.fontRegular,
                color: Colors.grey
              ),
            ),
            const SizedBox(height: 10),
            CustomButtonComponent(
              text: "Editar Perfil", 
              onPressed: () {}, 
              backgroundColor: AppConstsUtils.secondaryColor
            ),
            const SizedBox(height: 20),


            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppConstsUtils.secondaryColor.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppConstsUtils.secondaryColor.withValues(alpha: .5),
                  width: 1
                )
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          CupertinoIcons.lock,
                          color: AppConstsUtils.secondaryColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Bloquear',
                        style: TextStyle(
                          fontSize: context.sizeDevice.height / 60,
                          fontFamily: AppConstsUtils.lightFont,
                        )
                      ),
                      const Spacer(),
                  
                      Switch(
                        value: true, onChanged: (v) {},
                        activeTrackColor: AppConstsUtils.secondaryColor,
                        activeColor: Colors.white,
                      )
                    ],
                  ),
                  const Divider(),

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          CupertinoIcons.heart,
                          color: AppConstsUtils.secondaryColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Favoritos',
                        style: TextStyle(
                          fontSize: context.sizeDevice.height / 60,
                          fontFamily: AppConstsUtils.lightFont,
                        )
                      ),
                      const Spacer(),
                  
                      Icon(
                        CupertinoIcons.forward,
                        color: AppConstsUtils.secondaryColor,
                      )
                    ],
                  ),
                  const Divider(),

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          CupertinoIcons.exclamationmark_bubble,
                          color: AppConstsUtils.secondaryColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Suporte',
                        style: TextStyle(
                          fontSize: context.sizeDevice.height / 60,
                          fontFamily: AppConstsUtils.lightFont,
                        )
                      ),
                      const Spacer(),
                  
                      Icon(
                        CupertinoIcons.forward,
                        color: AppConstsUtils.secondaryColor,
                      )
                    ],
                  ),
                  
                ],
              ),
            ),
            const SizedBox(height: 20),


            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppConstsUtils.secondaryColor.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppConstsUtils.secondaryColor.withValues(alpha: .5),
                  width: 1
                )
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          CupertinoIcons.bell,
                          color: AppConstsUtils.secondaryColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Notificações',
                        style: TextStyle(
                          fontSize: context.sizeDevice.height / 60,
                          fontFamily: AppConstsUtils.lightFont,
                        )
                      ),
                      const Spacer(),
                  
                      Switch(
                        value: true, onChanged: (v) {},
                        activeTrackColor: AppConstsUtils.secondaryColor,
                        activeColor: Colors.white,
                      )
                    ],
                  ),
                  const Divider(),

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          CupertinoIcons.camera_viewfinder,
                          color: AppConstsUtils.secondaryColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Face ID',
                        style: TextStyle(
                          fontSize: context.sizeDevice.height / 60,
                          fontFamily: AppConstsUtils.lightFont,
                        )
                      ),
                      const Spacer(),
                  
                      Switch(
                        value: true, onChanged: (v) {},
                        activeTrackColor: AppConstsUtils.secondaryColor,
                        activeColor: Colors.white,
                      )
                    ],
                  ),
                  const Divider(),

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          CupertinoIcons.qrcode,
                          color: AppConstsUtils.secondaryColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Partilhar o perfil',
                        style: TextStyle(
                          fontSize: context.sizeDevice.height / 60,
                          fontFamily: AppConstsUtils.lightFont,
                        )
                      ),
                      const Spacer(),
                  
                      Icon(
                        CupertinoIcons.forward,
                        color: AppConstsUtils.secondaryColor,
                      )
                    ],
                  ),
                  const Divider(),

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          CupertinoIcons.power,
                          color: AppConstsUtils.secondaryColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Terminar sesssão',
                        style: TextStyle(
                          fontSize: context.sizeDevice.height / 60,
                          fontFamily: AppConstsUtils.lightFont,
                        )
                      ),
                  
                  
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}