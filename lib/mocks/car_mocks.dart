import 'package:nossa_seguros/domain/entities/car.dart';

import '../domain/entities/car_brand.dart';

var car_brands_mocks = [
  CarBrandEntity(uuid: "1", name: "Toyota"),
  CarBrandEntity(uuid: "2", name: "Hyundai"),
];

var cars_mocks = [
  CarEntity(
      uuid: "1",
      brandUuid: "1",
      model: "Corolla",
      cilindrada: "Entre 1.601 CC e 2.000 CC",
      matricula: "",
      categoria: "Ligeiro Particular"),
  CarEntity(
      uuid: "2",
      brandUuid: "2",
      model: "Elantra",
      cilindrada: "Entre 1.601 CC e 2.000 CC",
      matricula: "",
      categoria: "Ligeiro Particular"),
  CarEntity(
      uuid: "3",
      brandUuid: "1",
      model: "Rav 4",
      cilindrada: "Entre 2.001 CC e 2.500 CC",
      matricula: "",
      categoria: "Ligeiro Particular"),
  CarEntity(
      uuid: "4",
      brandUuid: "2",
      model: "Tucson",
      cilindrada: "Entre 2.001 CC e 2.500 CC",
      matricula: "",
      categoria: "Ligeiro Particular")
];
