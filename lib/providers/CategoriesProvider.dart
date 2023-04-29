import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Category_Provider with ChangeNotifier {
  int _fAndD = 0;
  int _household = 0;

  int get fAndD {
    return _fAndD;
  }

  int get household {
    return _household;
  }

  void resetAll(){
    _fAndD = 0;
    _household = 0;
    saveDashboard().then((value) => print('RESET F&D + H COMPLETE'));
    notifyListeners();
  }

  void addToFAD(int val) {
    _fAndD += val;
    notifyListeners();
    saveDashboard().then((value) => print('Save DASHBOARD COMPLETE'));
  }

  void addToHousehold(int val) {
    _household += val;
    notifyListeners();
    saveDashboard().then((value) => print('Save DASHBOARD COMPLETE'));
  }

  Future<void> saveDashboard() async {
    final prefs = await SharedPreferences.getInstance();
    final dashboardData = json.encode({
      'fad': _fAndD,
      'household': _household
    });
    prefs.setString('dashboard[${DateTime.now().month}/${DateTime.now().year}]', dashboardData);
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString('dashboard[${DateTime.now().month}/${DateTime.now().year}]');
    if (jsonData != null) {
      final extractedUserData = json.decode(jsonData);
      _fAndD = extractedUserData['fad'];
      _household = extractedUserData['household'];
      notifyListeners();
    } else {
      _fAndD = 0;
      _household = 0;
      print('NO DASHBOARD DATA');
    }
  }
}