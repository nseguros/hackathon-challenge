import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nossa_seguros/presenter/widgets/common_button.dart';

import '../../../../domain/entities/car.dart';
import '../../../../domain/entities/car_brand.dart';
import '../../../../domain/entities/escalao.dart';
import '../simulate_result.dart';
import 'controller/car_insurance_simulator_controller.dart';

class CarInsuranceSimulator extends StatefulWidget {
  const CarInsuranceSimulator({super.key});

  @override
  State<CarInsuranceSimulator> createState() => _CarInsuranceSimulatorState();
}

class _CarInsuranceSimulatorState extends State<CarInsuranceSimulator> {
  var controller = Get.find<CarInsuranceSimulatorController>();

  @override
  void initState() {
    controller.fetchData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context)
            .unfocus(); // Dismiss the keyboard when tapping outside
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text("Simulador de seguro automóvel"),
          ),
          body: Obx(() {
            return controller.isLoading.value
                ? Center(child: CircularProgressIndicator())
                : controller.brands.isEmpty
                    ? Center(child: Text("Nenhuma marca de carro encontrada."))
                    : controller.escaloes.isEmpty
                        ? Center(child: Text("Nenhum escalão encontrado."))
                        : controller.insurance == null
                            ? Center(child: Text("Nenhum seguro encontrado."))
                            : _buildSimulatorForm();
          })),
    );
  }

  Widget _buildSimulatorForm() {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              "Marca do veiculo",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: size.width,
              height: 60,
              child: _brandCarSelection(),
              decoration: BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8)),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Modelo",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: size.width,
              height: 60,
              child: _carSelection(),
              decoration: BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8)),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Categoria",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: size.width,
              height: 60,
              decoration: BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8)),
              child: controller.carSelected?.value == null
                  ? Text("Sem categoria definida")
                  : Text(controller.carSelected!.value.categoria),
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Cilindrada",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: size.width,
                  height: 60,
                  decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8)),
                  child: controller.carSelected?.value == null
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Seleccione o carro"),
                        )
                      : Text(controller.carSelected!.value.cilindrada),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Escalão",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: size.width,
                  height: 60,
                  child: _escalaoSelection(),
                  decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8)),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Matricula",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: size.width,
                  height: 60,
                  decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8)),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: controller.licensePlaceController,
                    decoration: InputDecoration(
                      hintText: "Ex: LD-12-12-AB",
                      contentPadding: EdgeInsets.only(bottom: 10),
                      focusColor: Color(0xff000000),
                      filled: true,
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      fillColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      labelStyle: TextStyle(color: Color(0xff000000)),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Preencha o campo";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Data da 1a Matricula",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: size.width,
                  height: 60,
                  decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8)),
                  child: TextFormField(
                    keyboardType: TextInputType.datetime,
                    controller: controller.firstLicensePlateDate,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.calendar_today),
                      suffixIcon: Icon(Icons.arrow_drop_down_circle),
                      hintText: "",
                      contentPadding: EdgeInsets.only(bottom: 10),
                      focusColor: Color(0xff000000),
                      filled: true,
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      fillColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      labelStyle: TextStyle(color: Color(0xff000000)),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Preencha o campo";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Fracionamento",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    width: size.width,
                    height: 60,
                    decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Mensal",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Data de inicio",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: size.width,
                  height: 60,
                  decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8)),
                  child: TextFormField(
                    keyboardType: TextInputType.datetime,
                    controller: controller.insuranceBeginDate,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.calendar_today),
                      suffixIcon: Icon(Icons.arrow_drop_down_circle),
                      hintText: "",
                      contentPadding: EdgeInsets.only(bottom: 10),
                      focusColor: Color(0xff000000),
                      filled: true,
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      fillColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      labelStyle: TextStyle(color: Color(0xff000000)),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Preencha o campo";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Obx(() {
              return CommonButton(
                  title: controller.isLoading.value
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Text("Simular"),
                  action: () async {
                    if (controller.checkData()) {
                      var value = await controller
                          .simulateInsuranceCalculation(context);

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => SimulateResult(
                                insuranceName: 'Seguro automóvel',
                                value: value,
                              )));
                    }
                  },
                  active: !controller.isLoading.value);
            })
          ],
        ),
      ),
    );
  }

  _brandCarSelection() {
    return DropdownButton<CarBrandEntity>(
      value: controller.brandSelected?.value,
      items: controller.brands
          .map((brand) => DropdownMenuItem<CarBrandEntity>(
                value: brand,
                child: Text(
                  brand.name,
                  // Isso afeta apenas os itens na lista suspensa
                  textAlign: TextAlign.center,
                ),
              ))
          .toList(),
      onChanged: (value) async {
        controller.brandSelected?.value = value!;
        await controller.fetchCarByBrand();
      },
      hint: Text("Selecione a marca do carro"),
      isExpanded: true,
      underline: Container(
        height: 1,
        color: Colors.grey,
      ),
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
      icon: Icon(
        Icons.arrow_drop_down,
        color: Colors.black,
      ),
      iconSize: 24,
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(8),
      elevation: 2,
      isDense: true,

      // Aqui está o ponto-chave: item selecionado alinhado à esquerda
      selectedItemBuilder: (BuildContext context) {
        return controller.brands
            .map((brand) => Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    brand.name,
                    style: TextStyle(color: Colors.black),
                  ),
                ))
            .toList();
      },
    );
  }

  Widget _carSelection() {
    return DropdownButton<CarEntity>(
      value: controller.carSelected?.value,
      items: controller.cars
          .map((car) => DropdownMenuItem<CarEntity>(
                value: car,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    car.model,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ))
          .toList(),
      onChanged: (car) {
        if (car != null) {
          controller.carSelected?.value = car;
        }
      },
      hint: Align(
        alignment: Alignment.centerLeft,
        child: Text("Selecione o modelo do carro"),
      ),
      isExpanded: true,
      underline: Container(
        height: 1,
        color: Colors.grey,
      ),
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
      icon: Icon(
        Icons.arrow_drop_down,
        color: Colors.black,
      ),
      iconSize: 24,
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(8),
      elevation: 2,
      isDense: true,
      selectedItemBuilder: (BuildContext context) {
        return controller.cars.map((car) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Text(
              car.model,
              style: TextStyle(color: Colors.black),
            ),
          );
        }).toList();
      },
    );
  }

  _escalaoSelection() {
    return DropdownButton<EscalaoCapitalEntity>(
      value: controller.escalaoCapitalEntitySelected?.value,
      items: controller.escaloes
          .map((escalao) => DropdownMenuItem<EscalaoCapitalEntity>(
                value: escalao,
                child: Text(
                  escalao.valor,
                  textAlign: TextAlign.center,
                ),
              ))
          .toList(),
      onChanged: (escalao) {
        controller.escalaoCapitalEntitySelected?.value = escalao!;
      },
      hint: Text("Selecione a marca do carro"),
      isExpanded: true,
      underline: Container(
        height: 1,
        color: Colors.grey,
      ),
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
      icon: Icon(
        Icons.arrow_drop_down,
        color: Colors.black,
      ),
      iconSize: 24,
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(8),
      elevation: 2,
      selectedItemBuilder: (BuildContext context) {
        return controller.cars
            .map((car) => Text(
                  car.model,
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                ))
            .toList();
      },
      isDense: true,
    );
  }
}
