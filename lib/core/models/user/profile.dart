/// Profile model for extensible user profile data.
/// Separate from [User] (auth/core fields); can be extended with displayName, avatar, bio, etc.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@freezed
class Profile with _$Profile {
  const factory Profile({
    required String userId,
    String? displayName,
    String? avatarUrl,
    String? bio,
    DateTime? updatedAt,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
