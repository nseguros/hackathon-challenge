import 'package:flutter/material.dart';
import 'package:nossa_seguros/presenter/pages/home/home.dart';
import 'package:nossa_seguros/presenter/widgets/common_button.dart';

class SimulateResult extends StatelessWidget {
  String insuranceName = "Seguro de Vida";
  double value = 100000.0;

  SimulateResult({super.key, required this.insuranceName, required this.value});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Resultado da simulação"),
      ),
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Resultado da Simulação de Seguro Automóvel",
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              Text(insuranceName),
              SizedBox(
                height: 20,
              ),
              Text(
                "O seu prémio está estimado em:",
                textAlign: TextAlign.center,
              ),
              Text("${value.toStringAsFixed(2)} KZS",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(
                height: 20,
              ),
              CommonButton(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.mail,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Enviar por email")
                    ],
                  ),
                  action: () {},
                  active: true),
              SizedBox(
                height: 10,
              ),
              CommonButton(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Sair")
                    ],
                  ),
                  action: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (ctx) => Home()),
                        (t) => false);
                  },
                  active: false)
            ],
          ),
        ),
      )),
    );
  }
}
