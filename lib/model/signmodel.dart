import 'package:json_annotation/json_annotation.dart';
part 'signmodel.g.dart';

@JsonSerializable()
class LoginResponse {
  final String message;
  final String token;
  final User user;

  LoginResponse({
    required this.message,
    required this.token,
    required this.user,
  });

  /// Factory method for creating an instance from JSON
  factory LoginResponse.fromJson(Map<String, dynamic> json) =>_$LoginResponseFromJson(json);

  /// Method for converting an instance to JSON
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable()
class User {
  final int id;
  final String name;
  final String phone;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
  });

  /// Factory method for creating an instance from JSON
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// Method for converting an instance to JSON
  Map<String, dynamic> toJson() => _$UserToJson(this);
}









