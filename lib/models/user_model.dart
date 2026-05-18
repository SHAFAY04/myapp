import 'dart:convert';

import '../core/enums/gender_enum.dart';

class UserModel {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final Gender gender;

  const UserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.gender,
  });

  String get fullName => '$firstName $lastName';

  String get initials =>
      '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}'
          .toUpperCase();

  // ─── Serialisation ────────────────────────────────────────────────────────
  Map<String, dynamic> toMap() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'gender': gender.displayName,
      };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        firstName: map['firstName'] as String,
        lastName: map['lastName'] as String,
        email: map['email'] as String,
        password: map['password'] as String,
        gender: Gender.fromString(map['gender'] as String) ?? Gender.other,
      );

  String toJson() => jsonEncode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(jsonDecode(source) as Map<String, dynamic>);

  UserModel copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    Gender? gender,
  }) =>
      UserModel(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        password: password ?? this.password,
        gender: gender ?? this.gender,
      );

  @override
  String toString() =>
      'UserModel(firstName: $firstName, lastName: $lastName, email: $email, gender: ${gender.displayName})';
}
