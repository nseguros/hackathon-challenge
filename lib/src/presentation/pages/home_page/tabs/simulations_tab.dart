import 'package:flutter/material.dart';
import 'package:nossa_app_hackton/src/presentation/utils/app_consts_utils.dart';
import 'package:nossa_app_hackton/src/presentation/utils/size_device_util.dart';

class SimulationsTab extends StatelessWidget {
  const SimulationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              AppConstsUtils.logo,
              height: context.sizeDevice.height / 10,
              width: context.sizeDevice.width / 3,
            ),
            Text(
              "Simulações",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              )
            )
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: List.generate(
          10,
          (index) => Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withValues(alpha: .2), blurRadius: 10)
                ]),
            child: Row(
              children: [
                Image.asset(
                  index.isEven
                      ? AppConstsUtils.iconAutomovel
                      : AppConstsUtils.iconSaude,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        index.isEven
                            ? 'Seguro de Automóvel'
                            : 'Seguro de Saúde',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        index.isEven
                            ? 'Proteção contra danos, roubo e acidentes.'
                            : 'Cobertura médica e hospitalar para sua segurança.',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        index.isEven ? '150.000,00 AKZ' : '100.000,00 AKZ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
