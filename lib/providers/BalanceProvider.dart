import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Balance_Provider with ChangeNotifier{
  int _wallet = 0;
  int _bank = 0;
  String? authToken;

  Balance_Provider(this.authToken);

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

  void subtractFromWallet(int val){
    _wallet -= val;
    notifyListeners();
    saveData();
  }

  void subtractFromBank(int val){
    _bank -= val;
    notifyListeners();
    saveData();
  }

  Future<void> saveData() async {
    var uri = Uri.parse(
        'https://phong-s-app-default-rtdb.firebaseio.com/balance.json?$authToken');
    await http.patch(uri,
        body: json.encode({
          'wallet': _wallet,
          'bank': _bank,
        }));

    // final balanceData = await http.get(uri);
    // print('WALLET DATA: ${json.decode(balanceData.body)['wallet']}');
    // print('BANK DATA: ${json.decode(balanceData.body)['bank']}');
  }

  Future<void> loadData() async {
    var uri = Uri.parse(
        'https://phong-s-app-default-rtdb.firebaseio.com/balance.json?$authToken');
    final balanceData = await http.get(uri).catchError((err) => print('FETCH BALANCE ERROR'));
    final extractedData = json.decode(balanceData.body);
    _wallet = extractedData['wallet'] ?? 0;
    _bank = extractedData['bank'] ?? 0;
    notifyListeners();
  }
}