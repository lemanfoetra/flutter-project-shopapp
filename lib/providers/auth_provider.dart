import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
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

        // simpan data auth ke sharedprefences
        final shared = await SharedPreferences.getInstance();
        final dataAuth = json.encode({
          'email': email,
          'password': password,
        });
        shared.setString('DATA_AUTH', dataAuth);
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
    if (token != null && token != '') {
      return true;
    }
    return false;
  }



  /// logout 
  Future<void> logout() async {
    _email = null;
    _password = null;
    _token = null;

    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    notifyListeners();
  }



  /// Mencoba untuk login kembali dengan data SharedPreferences
  Future<void> tryLogin() async {
    final prefences = await SharedPreferences.getInstance();
    if (prefences.getString('DATA_AUTH') != null) {
      final data = json.decode(prefences.getString('DATA_AUTH')) as Map<String, dynamic>;
      await login(data['email'], data['password']);
    }
  }

  /// Untuk mengambil token
  String get token {
    return _token;
  }

  /// Hapus kode token
  void removeToken() {
    _token = null;
  }
}
