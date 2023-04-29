import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Balance_Provider with ChangeNotifier{
  int _wallet = 0;
  int _bank = 0;

  int get wallet => _wallet;
  int get bank => _bank;
  int get balance {
    return _wallet + _bank;
  }

  void resetAll(){
    _wallet = 0;
    _bank = 0;
    saveData().then((value) => 'RESET BALANCE COMPLETE');
    notifyListeners();
  }

  void setWallet(int val){
    _wallet = val;
    notifyListeners();
    saveData();
  }

  void setBank(int val){
    _bank = val;
    notifyListeners();
    saveData();
  }

  void addToWallet(int val){
    _wallet += val;
    notifyListeners();
    saveData();
  }

  void addToBank(int val){
    _bank += val;
    notifyListeners();
    saveData();
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final dashboardData = json.encode({
      'wallet': _wallet,
      'bank': _bank
    });
    prefs.setString('balance[${DateTime.now().month}/${DateTime.now().year}]', dashboardData);
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString('balance[${DateTime.now().month}/${DateTime.now().year}]');
    if (jsonData != null) {
      final extractedUserData = json.decode(jsonData);
      _wallet = extractedUserData['wallet'];
      _bank = extractedUserData['bank'];
      notifyListeners();
    } else {
      _wallet = 0;
      _bank = 0;
      print('NO BALANCE DATA');
    }
  }
}