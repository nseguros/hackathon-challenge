import 'package:flutter/material.dart';
import 'package:nossa_seguros/presenter/widgets/option_card.dart';
import 'package:nossa_seguros/utils/constants/app_colors.dart';

import '../../../utils/assets_utils.dart';
import 'car_insurance/car_insurance_simulator.dart';

class SimulatorMenu extends StatefulWidget {
  const SimulatorMenu({super.key});

  @override
  State<SimulatorMenu> createState() => _SimulatorMenuState();
}

class _SimulatorMenuState extends State<SimulatorMenu> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(title: const Text("Simulador de Produtos")),
        body: Padding(
          padding: const EdgeInsets.only(left: 40, right: 40, top: 40),
          child: Column(
            children: [
              Container(
                  width: size.width,
                  height: 60,
                  child: Image(
                    image: AssetImage(AssetsUtils.LOGO),
                  )),
              SizedBox(
                height: 40,
              ),
              Text(
                "Escolha o tipo de seguro que pretende simular",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => CarInsuranceSimulator()));
                    },
                    child: OptionCard(
                      title: "Seguro Automóvel",
                      icon: "",
                      iconData: Icon(
                        Icons.car_crash,
                        size: 40,
                        color: SECONDARYCOLOR,
                      ),
                    ),
                  ),
                  OptionCard(
                    title: "Seguro saúde",
                    icon: "",
                    iconData: Icon(
                      Icons.health_and_safety_rounded,
                      size: 40,
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OptionCard(
                    title: "Seguro de vida",
                    icon: "",
                    iconData:
                        Icon(Icons.favorite, size: 40, color: Colors.grey),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
