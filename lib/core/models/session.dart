/// Session model representing refresh token and device binding.
class Session {
  const Session({
    required this.refreshToken,
    required this.deviceId,
    this.expiresAt,
  });

  final String refreshToken;
  final String deviceId;
  final DateTime? expiresAt;

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      refreshToken: json['refreshToken'] as String,
      deviceId: json['deviceId'] as String,
      expiresAt: json['expiresAt'] != null
          ? DateTime.tryParse(json['expiresAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'refreshToken': refreshToken,
    'deviceId': deviceId,
    if (expiresAt != null) 'expiresAt': expiresAt!.toIso8601String(),
  };
}
