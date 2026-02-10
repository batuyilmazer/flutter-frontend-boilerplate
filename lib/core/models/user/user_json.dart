/// Centralized JSON parsing helpers for User model.
/// Handles backend inconsistencies (e.g. userId vs id).

import 'package:flutter_frontend_boilerplate/core/errors/app_exception.dart';

/// Reads user id from JSON. Backend may send "id" or "userId".
String parseUserId(Map<String, dynamic> json) {
  final rawId = json['userId'] ?? json['id'];
  if (rawId == null) {
    throw ApiException('User: "id" or "userId" field is missing');
  }
  return rawId.toString();
}

/// Reads and validates email from JSON.
String parseEmail(Map<String, dynamic> json) {
  final rawEmail = json['email'];
  if (rawEmail == null || rawEmail is! String || rawEmail.isEmpty) {
    throw ApiException('User: "email" field is missing or invalid');
  }
  return rawEmail;
}

bool parseBool(
  Map<String, dynamic> json,
  String key, {
  bool defaultValue = false,
}) {
  final v = json[key];
  if (v == null) return defaultValue;
  if (v is bool) return v;
  if (v is String) return v.toLowerCase() == 'true';
  return defaultValue;
}

DateTime? parseDateTime(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is String) return DateTime.tryParse(value);
  return null;
}
