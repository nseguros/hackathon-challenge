class CarBrandEntity {
  String uuid;
  final String name;

  CarBrandEntity({
    required this.uuid,
    required this.name,
  });

  @override
  String toString() {
    return 'CarBrand{name: $name}';
  }

  factory CarBrandEntity.fromJson(Map<String, dynamic> json) {
    return CarBrandEntity(
      uuid: json['uuid'] as String,
      name: json['name'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'name': name,
    };
  }
}
