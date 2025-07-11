class SeguroEntity {
  String veiculo;
  String modelo;
  String cilindrada;
  double escalaoCapital;
  String fraccionamento;
  double factorBase;
  double factorEscalao;
  double factorFracionamento;
  double premioEstimado;

  // Construtor
  SeguroEntity({
    required this.veiculo,
    required this.modelo,
    required this.cilindrada,
    required this.escalaoCapital,
    required this.fraccionamento,
    required this.factorBase,
    required this.factorEscalao,
    required this.factorFracionamento,
    required this.premioEstimado,
  });

  // fromJson
  factory SeguroEntity.fromJson(Map<String, dynamic> json) {
    return SeguroEntity(
      veiculo: json['veiculo'],
      modelo: json['modelo'],
      cilindrada: json['cilindrada'],
      escalaoCapital: (json['escalaoCapital'] as num).toDouble(),
      fraccionamento: json['fraccionamento'],
      factorBase: (json['factorBase'] as num).toDouble(),
      factorEscalao: (json['factorEscalao'] as num).toDouble(),
      factorFracionamento: (json['factorFracionamento'] as num).toDouble(),
      premioEstimado: (json['premioEstimado'] as num).toDouble(),
    );
  }

  factory SeguroEntity.empty() {
    return SeguroEntity(
      veiculo: "",
      modelo: "",
      cilindrada: "",
      escalaoCapital: 0.0,
      fraccionamento: "",
      factorBase: 0.0,
      factorEscalao: 0.0,
      factorFracionamento: 0.0,
      premioEstimado: 0.0,
    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'veiculo': veiculo,
      'modelo': modelo,
      'cilindrada': cilindrada,
      'escalaoCapital': escalaoCapital,
      'fraccionamento': fraccionamento,
      'factorBase': factorBase,
      'factorEscalao': factorEscalao,
      'factorFracionamento': factorFracionamento,
      'premioEstimado': premioEstimado,
    };
  }
}
