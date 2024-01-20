import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

final class CustomHttpClient extends http.BaseClient {
  CustomHttpClient()
      : _client = http.Client(),
        _storage = _TokenStorage();

  final baseUrl = "http://127.0.0.1:4000";

  final http.Client _client;
  final _TokenStorage _storage;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final token = await _storage.getAccessToken();
    final defaultHeaders = <String, String>{
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    };

    request.headers.addAll(defaultHeaders);

    return _client.send(request);
  }

  @override
  void close() {
    _client.close();
    super.close();
  }

  // we could spawn a new isolate for this.
  Map<String, dynamic> decodeJson(String body) =>
      jsonDecode(body) as Map<String, dynamic>;

  Future<void> setAccessToken(String token) async =>
      await _storage.setAccessToken(token);
}

final class _TokenStorage {
  _TokenStorage() : _storage = FlutterSecureStorage();
  final FlutterSecureStorage _storage;

  static const _accessTokenKey = 'access-token';

  Future<String?> getAccessToken() async =>
      await _storage.read(key: _accessTokenKey);

  Future<void> setAccessToken(String value) async =>
      await _storage.write(key: _accessTokenKey, value: value);
}
