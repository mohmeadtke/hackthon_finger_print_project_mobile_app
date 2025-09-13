import 'package:hackthon_app/Features/fingerPreant/domain/entity/user_entity.dart';

class UserMoidel extends UserEntity {
  UserMoidel({required super.name, required super.email});
  factory UserMoidel.fromJson(Map<String, dynamic> json) {
    return UserMoidel(name: json['name'], email: json['email']);
  }
}
