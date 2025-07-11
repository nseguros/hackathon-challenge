class EscalaoCapitalEntity {
  String uuid;
  String categoria;
  String valor;

  // Construtor
  EscalaoCapitalEntity({
    required this.uuid,
    required this.categoria,
    required this.valor,
  });
  EscalaoCapitalEntity.empty()
      : uuid = '',
        categoria = '',
        valor = '';

  // fromJson
  factory EscalaoCapitalEntity.fromJson(Map<String, dynamic> json) {
    return EscalaoCapitalEntity(
      uuid: json['uuid'],
      categoria: json['categoria'],
      valor: json['valor'],
    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'categoria': categoria,
      'valor': valor,
    };
  }
}
