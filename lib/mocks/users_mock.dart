import 'package:nossa_seguros/domain/entities/user.dart';

final List<UserEntity> usersMock = [
  UserEntity(
    uuid: '1',
    name: 'Adolfo',
    surname: 'Quende',
    phoneNumber: '123456',
    password: 'senha',
    createdAt: '2023-01-01T00:00:00Z',
    updatedAt: '2023-01-01T00:00:00Z',
  ),
  UserEntity(
    uuid: '2',
    name: 'Iracelma',
    surname: 'Faustino',
    phoneNumber: '0987654321',
    password: 'password456',
    createdAt: '2023-02-01T00:00:00Z',
    updatedAt: '2023-02-01T00:00:00Z',
  ),
  UserEntity(
    uuid: '3',
    name: 'Carlos',
    surname: 'Alves',
    phoneNumber: '1122334455',
    password: 'password789',
    createdAt: '2023-03-01T00:00:00Z',
    updatedAt: '2023-03-01T00:00:00Z',
  ),
  UserEntity(
    uuid: '4',
    name: 'Bob Johnson',
    surname: 'Williams',
    phoneNumber: '5566778899',
    password: 'password',
    createdAt: '2023-04-01T00:00:00Z',
    updatedAt: '2023-04-01T00:00:00Z',
  ),
];
