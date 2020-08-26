import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../exceptions/AuthException.dart';

class AuthProvider with ChangeNotifier {
  String _email;
  String _password;
  String _token;

  /// Funtion untuk login
  Future<void> login(String email, String password) async {
    const String url = 'http://shopapp.ardynsulaeman.com/public/api/login';
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
        },
        body: {
          'email': email,
          'password': password,
        },
      );

      final responseData = json.decode(response.body);

      if (responseData != null) {
        if (responseData['error'] != null) {
          throw AuthException(responseData['error']);
        }
        _token = responseData['token'];
        _email = email;
        _password = password;
      }
      notifyListeners();
    } on AuthException catch (error) {
      throw error.toString();
    } catch (error) {
      throw "Gagal menghubungkan ke server";
    }
  }


  /// Untuk pengecekan apakan sudah login atau tidak
  bool get isAuth {
    if (token != null) {
      return true;
    }
    return false;
  }

  /// Untuk mengambil token
  String get token {
    return _token;
  }
}
