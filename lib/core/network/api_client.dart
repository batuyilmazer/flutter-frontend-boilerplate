import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../errors/app_exception.dart';
import 'auth_interceptor.dart';

/// Very small HTTP client wrapper around `package:http`.
///
/// This is intentionally minimal; you can replace it with Dio or another
/// client later without touching feature modules.
///
/// Supports optional [AuthInterceptor] for automatic token injection and refresh.
class ApiClient {
  ApiClient({
    http.Client? httpClient,
    AuthInterceptor? authInterceptor,
  })  : _client = httpClient ?? http.Client(),
        _authInterceptor = authInterceptor;

  final http.Client _client;
  final AuthInterceptor? _authInterceptor;

  Future<Map<String, dynamic>> getJson(
    String path, {
    Map<String, String>? headers,
  }) async {
    return await _executeRequest(
      () async {
        final modifiedHeaders = _authInterceptor != null
            ? await _authInterceptor.interceptRequest(headers)
            : headers;
        final uri = Uri.parse('${AppConfig.apiBaseUrl}$path');
        final response = await _client.get(uri, headers: modifiedHeaders);
        return response;
      },
    );
  }

  Future<Map<String, dynamic>> postJson(
    String path, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    return await _executeRequest(
      () async {
        final baseHeaders = {
          'Content-Type': 'application/json',
          if (headers != null) ...headers,
        };
        final modifiedHeaders = _authInterceptor != null
            ? await _authInterceptor.interceptRequest(baseHeaders)
            : baseHeaders;
        final uri = Uri.parse('${AppConfig.apiBaseUrl}$path');
        final response = await _client.post(
          uri,
          headers: modifiedHeaders,
          body: body == null ? null : jsonEncode(body),
        );
        return response;
      },
    );
  }

  /// Execute HTTP request with interceptor support.
  ///
  /// Handles automatic token injection and 401 refresh retry logic.
  Future<Map<String, dynamic>> _executeRequest(
    Future<http.Response> Function() requestFn,
  ) async {
    http.Response response;
    try {
      response = await requestFn();
    } catch (e) {
      // Re-throw non-HTTP errors
      rethrow;
    }

    // Handle 401 with refresh retry if interceptor is available
    if (response.statusCode == 401 && _authInterceptor != null) {
      try {
        // Interceptor will attempt refresh and retry
        return await _authInterceptor.interceptResponse(
          () async {
            // Retry original request with new token
            final retryResponse = await requestFn();
            return _handleJsonResponse(retryResponse);
          },
        );
      } catch (e) {
        // Refresh failed, throw original 401 response
        return _handleJsonResponse(response);
      }
    }

    return _handleJsonResponse(response);
  }

  Map<String, dynamic> _handleJsonResponse(http.Response response) {
    if (kDebugMode) {
      debugPrint(
        'HTTP ${response.request?.method} '
        '${response.request?.url} -> ${response.statusCode}',
      );
    }

    final dynamic decoded = response.body.isNotEmpty
        ? jsonDecode(response.body)
        : null;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded is Map<String, dynamic> ? decoded : <String, dynamic>{};
    }

    throw ApiException(
      statusCode: response.statusCode,
      message: decoded is Map<String, dynamic>
          ? (decoded['message']?.toString() ?? 'Request failed')
          : 'Request failed',
    );
  }
}
