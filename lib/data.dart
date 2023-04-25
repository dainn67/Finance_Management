//categories selector
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

int cId = 0;
List<String> categories = ["General", "Statistic", "Housing", "Summary"];

//records
// List records = [];
String jsonRecord = ''; //saved

//tổng số tiền đã chi cho đồ ăn / đồ gia dụng
int totalStationery = 0;
String jsonStation = ''; //saved

int totalFood = 0; //saved
String jsonFood = ''; //saved

//filter trang statistics/thống kê
int filter = 0;

//số tiền phải đóng cho chủ nhà của các tháng
//từ năm 2023 đến 2026 từ tháng 4 đến 12, từ Phong > Tùng > Lâm > Hiển
//1:2023  2:2024  3:2025  4:2026 // tháng tương tự số // 1-Phong 2-Tùng  3-Lâm  4-Hiển

List<List<List<int>>> moneyToPayy = List.generate(
  4, // 0-2023  1-2024  2-2025  3-2026
  (i) => List.generate(
    13, // 12 month, leave 0 empty unused
    (j) => List.generate(
      5, // 1-Phong   2-Tung  3-Lam   4-Hien
      (k) => 0, // Initialize each element to 0
    ),
  ),
);
String jsonMoney = '';

//Lưu từ lần tổng kết cuối
List<List<List<int>>> saved = List.generate(
  4, // 0-2023  1-2024  2-2025  3-2026
  (i) => List.generate(
    13, // 12 month, leave 0 empty unused
    (j) => List.generate(
      5, // 1-Phong   2-Tung  3-Lam   4-Hien
      (k) => 0, // Initialize each element to 0
    ),
  ),
);

//HOUSING
//Danh sách tiền nhà mặc định 500k, điện nước, xe các tháng, mặc định 80k
List<List<int>> house =
    List.generate(4, (_) => List.generate(13, (_) => 500000)); //saved
List<List<int>> electric =
    List.generate(4, (_) => List.generate(13, (_) => 0)); //saved
List<List<int>> water =
    List.generate(4, (_) => List.generate(13, (_) => 0)); //saved
List<List<int>> motorFee =
    List.generate(4, (_) => List.generate(13, (_) => 80000)); //saved
//kiểm tra đã tính tiền nhà chưa
List<List<int>> check = List.generate(4, (_) => List.generate(13, (_) => 0));

//danh sách người đi xe máy, trừ Khánh
List<List<List<bool>>> motors = List.generate(
  4,
  (i) => List.generate(
    13,
    (j) => List.generate(
      4,
      (k) => false,
    ),
  ),
);
//saved

class Record {
  String id;
  String name;
  int money;
  String date;
  int by;
  int type;
  String people;

  Record(this.id, this.name, this.money, this.date, this.by, this.type,
      this.people);
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

  Future<void> addRecord(String recordName, int money, String date, int buyer,
      int type, String _people) async {
    var uri = Uri.parse(
        'https://phong-s-app-default-rtdb.firebaseio.com/records.json?$authToken');
    final res = await http.post(uri,
        body: json.encode({
          'name': recordName,
          'money': money,
          'date': date,
          'by': buyer,
          'type': type,
          'people': _people,
          'creatorId': userId
        }));
    var record = Record(
        json.decode(res.body)['name'],
        //get the unique id back and use as id of record
        recordName,
        money,
        date,
        buyer,
        type,
        _people);
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
          print('id: $key');
          _records.add(Record(key, data['name'], data['money'], data['date'],
              data['by'], data['type'], data['people']));
        });
        print('FETCH (WITH TOKEN) DONE');
        notifyListeners();
      }
    } catch (err) {
      print('FETCH ERROR: $err\n');
      rethrow;
    }
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

  bool get getIsAuth {
    if(token != null) {
      isAuth = true;
    } else {
      isAuth = false;
    }
    print('IS AUTH (getIsAuth): $isAuth');
    return isAuth;
  }

  String? get token {
    if (_expiryDate.isAfter(DateTime.now()) && _token != null) {
      print('TOKEN (getToken): $_token');
      return _token;
    } else {
      if(!_expiryDate.isAfter(DateTime.now())) print('OVERTIME');
      if(_token == null) print('NULL TOKEN');
      print('TOKEN IS NULL');
      return null;
    }
  }

  String? get userId {
    return _userId;
  }

  DateTime? get expiryDate {
    return _expiryDate;
  }

  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData')){
      return false;
    }
    String? jsonData = prefs.getString('userData');
    if(jsonData != null) {
      print('START TRY AUTOLOGIN');
      final extractedUserData = json.decode(jsonData);
      final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
      if(expiryDate.isBefore(DateTime.now())) return false;
      _token = extractedUserData['token'];
      _userId = extractedUserData['userId'];
      _expiryDate = DateTime.parse(extractedUserData['expiryDate']);
      notifyListeners();
      autoLogout();
      return true;
    }else{
      print('IF I SEE THIS LINE, I FUCKED UP');
      return false;
    }
  }

  Future<void> signUp(String email, String password) async {
    print('Email: $email\nPassword: $password');

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
    print('Email: $email\nPassword: $password');

    try {
      final url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBaSwfOnmThBgIUlbE7cM4e8FylZYpcF5Y');
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

        autoLogout();
        notifyListeners();

        final prefs = await SharedPreferences.getInstance();

        // if store a map, use json.encode({''})
        final userData = json.encode({
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String()
        });
        prefs.setString('userData', userData);

        final prefs2 = await SharedPreferences.getInstance();
        final tmp = prefs2.getString('userData');
        print('AFTER LOGIN: $tmp');
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<void> logout() async{
    _token = null;
    _userId = null;
    _expiryDate = DateTime.parse('2000-01-02 03:04:05');
    if (_authTimer != null) {
      _authTimer?.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void autoLogout() {
    if (_authTimer != null) {
      _authTimer?.cancel();
    }
    final timetoExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timetoExpiry), logout);
  }
}

int categoriesTitleNum = 1;