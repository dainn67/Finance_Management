import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Category_Provider with ChangeNotifier {
  int _fAndD = 0;
  int _household = 0;
  String? authToken;

  Category_Provider(this.authToken);

  int get fAndD {
    return _fAndD;
  }

  int get household {
    return _household;
  }

  void resetAll(){
    _fAndD = 0;
    _household = 0;
    saveCategory().then((value) => print('RESET F&D + H COMPLETE'));
    notifyListeners();
  }

  void addToFAD(int val) {
    _fAndD += val;
    notifyListeners();
    saveCategory().then((value) => print('Save DASHBOARD COMPLETE'));
  }

  void addToHousehold(int val) {
    _household += val;
    notifyListeners();
    saveCategory().then((value) => print('Save DASHBOARD COMPLETE'));
  }

  Future<void> saveCategory() async {
    var uri = Uri.parse(
        'https://phong-s-app-default-rtdb.firebaseio.com/categories.json?$authToken');
    await http.patch(uri,
        body: json.encode({
          'fad': _fAndD,
          'household': _household,
        }));
  }

  Future<void> loadData() async {
    var uri = Uri.parse(
        'https://phong-s-app-default-rtdb.firebaseio.com/categories.json?$authToken');
    final categoriesData = await http.get(uri).catchError((err) => print('FETCH CATEGORIES ERROR'));
    final extractedData = json.decode(categoriesData.body);
      _fAndD = extractedData['fad'];
      _household = extractedData['household'];
      notifyListeners();
  }
}


