import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nossa_seguros/core/error/errorLog.dart';
import 'package:nossa_seguros/domain/entities/car.dart';
import 'package:nossa_seguros/domain/entities/car_brand.dart';
import 'package:nossa_seguros/domain/entities/escalao.dart';
import 'package:nossa_seguros/domain/usecases/escalao/get_escalao_usecase.dart';
import 'package:nossa_seguros/domain/usecases/insurance/insurance_simulate_usecase.dart';

import '../../../../../domain/entities/seguro.dart';
import '../../../../../domain/usecases/car/get_brands_usecase.dart';
import '../../../../../domain/usecases/car/get_car_usecase.dart';

class CarInsuranceSimulatorController extends ChangeNotifier {
  // This class will handle the logic for the insurance simulator page.
  // It will manage the state of the insurance options, user inputs, and calculations.
  // The controller will interact with the domain layer to fetch insurance data,
  // perform calculations, and update the UI accordingly.
  // It will also handle user interactions such as selecting insurance options,
  // submitting the form, and displaying results.
  // The controller will use GetX for state management and dependency injection.
  // It will also handle any errors that may occur during the process.
  // The controller will be responsible for validating user inputs,
  //

  var isLoading = false.obs;
  var insurance = SeguroEntity.empty().obs;
  var brands = <CarBrandEntity>[].obs;

  TextEditingController licensePlaceController = TextEditingController();
  TextEditingController firstLicensePlateDate = TextEditingController();
  TextEditingController insuranceBeginDate = TextEditingController();
  Rx<CarBrandEntity>? brandSelected;
  Rx<CarEntity> carSelected = CarEntity.empty().obs;
  Rx<EscalaoCapitalEntity> escalaoCapitalEntitySelected =
      EscalaoCapitalEntity.empty().obs;
  var cars = <CarEntity>[].obs;
  var escaloes = <EscalaoCapitalEntity>[].obs;

  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      brands.value = await Get.find<GetCarBrandsUseCase>().call();
      escaloes.value = await Get.find<GetEscalaoUseCase>().call();

      if (brands.isNotEmpty) {
        brandSelected = brands.first.obs;
      } else {
        brandSelected = null;
      }
      if (escaloes.isNotEmpty) {
        escalaoCapitalEntitySelected.value = escaloes.first;
      } else {
        escalaoCapitalEntitySelected.value = EscalaoCapitalEntity.empty();
      }
    } catch (error, stackTrace) {
      errorLog(error, stackTrace);
    } finally {
      isLoading.value = false;
    }
  }

  Future<double> simulateInsuranceCalculation(BuildContext context) async {
    try {
      isLoading.value = true;

      await Future.delayed(Duration(seconds: 3));
      return await InsuranceSimulateUseCase().execute(seguro: insurance.value);
    } catch (error, stackTrace) {
      errorLog(error, stackTrace);
    } finally {
      isLoading.value = false;

      resetInsurance();
    }
    return 0.0;
  }

  void resetInsurance() {
    insurance.value = SeguroEntity.empty();
  }

  checkData() {
    if (brandSelected == null) {
      Get.snackbar("Erro", "Selecione uma marca de carro",
          backgroundColor: Colors.red);
      return false;
    }
    if (carSelected == null) {
      Get.snackbar("Erro", "Selecione um carro", backgroundColor: Colors.red);
      return false;
    }
    if (escalaoCapitalEntitySelected == null) {
      Get.snackbar("Erro", "Selecione um escalão de capital",
          backgroundColor: Colors.red);
      return false;
    }
    if (licensePlaceController.text.isEmpty) {
      Get.snackbar("Erro", "Preencha a matrícula do carro",
          backgroundColor: Colors.red);
      return false;
    }
    if (firstLicensePlateDate.text.isEmpty) {
      Get.snackbar("Erro", "Preencha a data da primeira matrícula",
          backgroundColor: Colors.red);
      return false;
    }
    if (insuranceBeginDate.text.isEmpty) {
      Get.snackbar("Erro", "Preencha a data de início do seguro",
          backgroundColor: Colors.red);
      return false;
    }

    return true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  fetchCarByBrand() async {
    try {
      cars.value = await Get.find<GetCarByBrandUsecase>()
          .call(brandSelected!.value.uuid);
    } catch (error, stackTrace) {
      errorLog(error, stackTrace);
    } finally {}
  }
}
