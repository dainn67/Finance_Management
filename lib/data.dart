import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:phongs_app/providers/CategoriesProvider.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Record {
  String id;
  String name;
  int money;
  DateTime date;
  int source;
  int type;
  String note;

  Record(this.id, this.name, this.money, this.date, this.source, this.type,
      this.note);
}

class Record_Provider with ChangeNotifier {
  List<Record> _records = [];
  final String? authToken;
  final String? userId;

  Record_Provider(this.authToken, this._records, this.userId);

  List<Record> get records {
    return [..._records]; //return a copy of items only
  }

  int getSize() => _records.length;

  Future<void> addRecord(String recordName, int money, DateTime date, int source, int type, String note, BuildContext context) async {
    final dashboardData = Provider.of<Category_Provider>(context, listen: false);
    var uri = Uri.parse(
        'https://phong-s-app-default-rtdb.firebaseio.com/records.json?$authToken');
    final res = await http.post(uri,
        body: json.encode({
          'name': recordName,
          'money': money,
          'date': date.toIso8601String(),
          'source': source,
          'type': type,
          'note': note,
          'creatorId': userId
        }));
    var record = Record(
        json.decode(res.body)['name'],
        //get the unique id back and use as id of record
        recordName,
        money,
        date,
        source,
        type,
        note);
    _records.add(record);
    notifyListeners();
  }

  Future<void> removeRecord(int id) async {
    var uri = Uri.parse(
        'https://phong-s-app-default-rtdb.firebaseio.com/records/${_records[id].id}.json?$authToken');
    final backupRecord = _records[id];
    _records.removeAt(id);
    http.delete(uri).then((_) {
      // fetchRecord().then((_) {
      //   print('Fetch done after deletion');
      // });
      print('Send HTTP delete record $id finished');

      notifyListeners();
    }).catchError((err) {
      print('DELETE ERROR: $err');
      _records.insert(id, backupRecord);
      notifyListeners();
    });
  }

  Future<void> fetchRecord([bool filter = false]) async {
    String filterUri = filter ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    final uri = Uri.parse(
        'https://phong-s-app-default-rtdb.firebaseio.com/records.json?$authToken&$filterUri');
    try {
      _records.clear();

      final res = await http.get(uri);
      if (res.body == null) print('BODY IS NULL MF');
      if (res.body != null) {
        final extractedData = json.decode(res.body) as Map<String,
            dynamic>; //string is the uniqueID and dynamic is Record object
        extractedData.forEach((key, data) {
          _records.add(Record(key, data['name'], data['money'], DateTime.parse(data['date']),
              data['source'], data['type'], data['note']));
        });
        print('FETCH (WITH TOKEN) DONE');
        notifyListeners();
      }
    } catch (err) {
      print('FETCH ERROR: $err\n');
      rethrow;
    }
  }

  void clearRecord() {
    _records.clear();
    notifyListeners();
  }
}

class Loading_State_Provider with ChangeNotifier {
  bool _isLoading = false;

  bool get getLoadingState {
    return _isLoading;
  }

  void changeState() {
    _isLoading = !_isLoading;
    notifyListeners();
  }
}

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