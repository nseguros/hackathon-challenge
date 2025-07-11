import 'package:flutter/material.dart';
import 'package:nossa_seguros/presenter/pages/auth/login.dart';
import 'package:nossa_seguros/presenter/widgets/option_card.dart';
import 'package:nossa_seguros/utils/constants/app_colors.dart';

import '../product_simulator/simulator_menu.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Menu Principal"),
          backgroundColor: SECONDARYCOLOR,
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 40, right: 40, top: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (ctx) => SimulatorMenu()));
                    },
                    child: OptionCard(
                      title: "Simulador de Produtos",
                      icon: "",
                      iconData: Icon(
                        Icons.calculate,
                        size: 40,
                        color: SECONDARYCOLOR,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (ctx) => Login()),
                          (c) => true);
                    },
                    child: OptionCard(
                      title: "Sair",
                      icon: "",
                      iconData: const Icon(
                        Icons.logout,
                        size: 40,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
