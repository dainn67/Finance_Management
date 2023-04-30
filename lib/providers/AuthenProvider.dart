import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authen_Provider with ChangeNotifier {
  String? _token;
  DateTime _expiryDate = DateTime.now();
  String? _userId;
  Timer? _authTimer;
  bool isAuth = true;

  String _displayEmail = '';

  bool get getIsAuth {
    if (token != null) {
      isAuth = true;
    } else {
      isAuth = false;
    }
    return isAuth;
  }

  String? get token {
    if (_expiryDate.isAfter(DateTime.now()) && _token != null) {
      return _token;
    } else {
      return null;
    }
  }

  String? get userId => _userId;

  DateTime? get expiryDate => _expiryDate;

  String get displayEmail => _displayEmail;

  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    String? jsonData = prefs.getString('userData');
    if (jsonData != null) {
      print('START TRY AUTOLOGIN');
      final extractedUserData = json.decode(jsonData);
      final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
      if (expiryDate.isBefore(DateTime.now())) return false;
      _token = extractedUserData['token'];
      _userId = extractedUserData['userId'];
      _expiryDate = DateTime.parse(extractedUserData['expiryDate']);
      _displayEmail = prefs.getString('mail') ?? 'error';
      notifyListeners();
      autoLogout();
      return true;
    } else {
      print('IF I SEE THIS LINE, I FUCKED UP');
      return false;
    }
  }

  Future<void> signUp(String email, String password) async {
    // print('Email: $email\nPassword: $password');

    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBaSwfOnmThBgIUlbE7cM4e8FylZYpcF5Y');
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw responseData['error']['message'];
      } else {
        _token = responseData['idToken'];
        _userId = responseData['localId'];
        _expiryDate = DateTime.now()
            .add(Duration(seconds: int.parse(responseData['expiresIn'])));
        notifyListeners();
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<void> signIn(String email, String password) async {
    // print('Email: $email\nPassword: $password');

    _displayEmail = email;
    try {
      final url = Uri.parse(
          'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBaSwfOnmThBgIUlbE7cM4e8FylZYpcF5Y');

      final res = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      // print('JSON BODY: ${json.decode(res.body)}');
      final responseData = json.decode(res.body);

      if (responseData['error'] != null) {
        throw responseData['error']['message'];
      } else {
        _token = responseData['idToken'];
        _userId = responseData['localId'];
        _expiryDate = DateTime.now()
            .add(Duration(seconds: int.parse(responseData['expiresIn'])));

        autoLogout();
        notifyListeners();

        final prefs = await SharedPreferences.getInstance();

        final userData = json.encode({
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String()
        });
        prefs.setString('userData', userData);
        prefs.setString('mail', _displayEmail);
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = DateTime.parse('2000-01-02 03:04:05');
    if (_authTimer != null) {
      _authTimer?.cancel();
      _authTimer = null;
    }
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      'expiryDate': _expiryDate.toIso8601String()
    });
    prefs.setString('userData', userData);
  }

  void autoLogout() {
    if (_authTimer != null) {
      _authTimer?.cancel();
    }
    final timetoExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timetoExpiry), logout);
  }
}