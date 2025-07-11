class CarEntity {
  String uuid;
  String brandUuid;
  String model;
  String cilindrada;
  String categoria;
  String matricula;

  // Construtor
  CarEntity({
    required this.uuid,
    required this.brandUuid,
    required this.model,
    required this.cilindrada,
    required this.categoria,
    required this.matricula,
  });

  CarEntity.empty()
      : uuid = '',
        brandUuid = '',
        model = '',
        cilindrada = '',
        categoria = '',
        matricula = '';

  // fromJson
  factory CarEntity.fromJson(Map<String, dynamic> json) {
    return CarEntity(
      uuid: json["uuid"] as String,
      brandUuid: json['brandUuid'],
      model: json['modelUuid'],
      cilindrada: json['cilindrada'],
      categoria: json['categoria'],
      matricula: json['matricula'],
    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'brandUuid': brandUuid,
      'modelUuid': model,
      'cilindrada': cilindrada,
      'categoria': categoria,
      'matricula': matricula,
    };
  }
}
