/// User model aligned with backend Prisma schema.
/// Parsing handles backend inconsistencies (userId vs id) via [user_json.dart].

import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_json.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const User._();

  const factory User({
    required String id,
    required String email,
    @Default(false) bool emailVerified,
    @Default(false) bool isSuspended,
    DateTime? lastLoginAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: parseUserId(json),
      email: parseEmail(json),
      emailVerified: parseBool(json, 'emailVerified'),
      isSuspended: parseBool(json, 'isSuspended'),
      lastLoginAt: parseDateTime(json['lastLoginAt']),
      createdAt: parseDateTime(json['createdAt']),
      updatedAt: parseDateTime(json['updatedAt']),
    );
  }
}

/// toJson (Freezed does not generate it when using custom fromJson).
extension UserJsonExtension on User {
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'email': email,
        'emailVerified': emailVerified,
        'isSuspended': isSuspended,
        if (lastLoginAt != null) 'lastLoginAt': lastLoginAt!.toIso8601String(),
        if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
        if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      };
}
