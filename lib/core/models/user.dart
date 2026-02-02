/// User model
/// - id: user id
/// - email: user email

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_frontend_boilerplate/core/errors/app_exception.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({required String id, required String email}) = _User;

  factory User.fromJson(Map<String, dynamic> json) {
    // ID alanını güvenli şekilde çek
    final dynamic rawId =
        json['userId'] ??
        json['id']; // TODO: change when backend is fixed (unifying responses:userId and id)
    if (rawId == null) {
      // ID hiç yoksa anlamlı bir hata fırlat
      throw ApiException('User.fromJson: "id" or "userId" field is missing');
    }

    // Email alanını güvenli şekilde çek
    final dynamic rawEmail = json['email'];
    if (rawEmail == null || rawEmail is! String || rawEmail.isEmpty) {
      throw ApiException('User.fromJson: "email" field is missing or invalid');
    }

    return User(id: rawId.toString(), email: rawEmail);
  }
}

// Extension for toJson (Freezed doesn't auto-generate toJson when using custom fromJson)
extension UserJsonExtension on User {
  Map<String, dynamic> toJson() => <String, dynamic>{'id': id, 'email': email};
}
