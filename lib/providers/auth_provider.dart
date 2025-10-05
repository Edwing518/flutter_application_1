import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();

  String? _token;

  bool get isAuthenticated => _token != null;

  String? get token => _token;

  Future<bool> login(String email, String password) async {
  final url = Uri.parse('http://10.0.2.2:3000/auth/login'); // Para emulador Android
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'email': email, 'password': password}),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    _token = data['token'];
    await _storage.write(key: 'auth_token', value: _token);
    notifyListeners();
    return true;
  }

  return false;
}

  Future<void> logout() async {
    _token = null;
    await _storage.delete(key: 'auth_token');
    notifyListeners();
  }

  Future<void> checkToken() async {
    final savedToken = await _storage.read(key: 'auth_token');
    if (savedToken != null) {
      _token = savedToken;
      notifyListeners();
    }
  }
}
