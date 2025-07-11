import 'package:flutter/material.dart';
import 'package:nossa_seguros/presenter/pages/auth/login.dart';
import 'package:nossa_seguros/presenter/widgets/common_button.dart';
import 'package:nossa_seguros/utils/assets_utils.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
        body: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: size.width,
            height: size.height / 2.5,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: Column(
                    children: [
                      Container(
                          width: size.width,
                          //height: size.height / 4,
                          child: Image(
                            image: AssetImage(AssetsUtils.LOGO),
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          "Faça aqui a gestão da sua carteira de seguros!",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        // Text(
                        //   "Ger",
                        //   style: Theme.of(context).textTheme.bodyMedium,
                        //   textAlign: TextAlign.center,
                        // ),
                      ],
                    )),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 70,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CommonButton(
                title: Text(
                  "Vamos começar",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                active: true,
                action: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => Login()));
                }),
          )
        ],
      ),
    ));
  }
}
