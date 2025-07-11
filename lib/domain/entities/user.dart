class UserEntity {
  String uuid;
  String phoneNumber;
  String name;
  String surname;
  String? password;
  String createdAt;
  String updatedAt;

  UserEntity({
    required this.uuid,
    required this.phoneNumber,
    required this.name,
    required this.surname,
    this.password,
    required this.createdAt,
    required this.updatedAt,
  });
  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      uuid: map['uuid'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      name: map['name'] ?? '',
      surname: map['surname'] ?? '',
      password: map['password'],
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'phoneNumber': phoneNumber,
      'name': name,
      'surname': surname,
      'password': password,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  @override
  String toString() {
    return 'UserEntity(uuid: $uuid,phoneNumber: $phoneNumber, name: $name, surname: $surname, password: $password, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
