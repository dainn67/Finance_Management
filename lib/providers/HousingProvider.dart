import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Housing_Provider with ChangeNotifier{
  int _house = 0;
  int _electric = 0;
  int _water = 0;
  int _motorbike = 0;

  int get house => _house;
  int get electric =>  _electric;
  int get water => _water;
  int get motorbike => _motorbike;

  void resetAll(){
    _house = 0;
    _electric = 0;
    _water = 0;
    _motorbike =0;
    notifyListeners();
    saveHousing().then((value) => print('RESET HOUSING COMPLETE'));
  }

  void changeHouse(int val){
    _house = val;
    notifyListeners();
  }

  void changeElectric(int val){
    _electric = val;
    notifyListeners();
  }

  void changeWater(int val){
    _water = val;
    notifyListeners();
  }

  void changeMotorFee(int val){
    _motorbike = val;
    notifyListeners();
  }

  int getTotal() {
    return _house + _electric + _water + _motorbike;
  }

  Future<void> saveHousing() async {
    final prefs = await SharedPreferences.getInstance();
    final housingData = json.encode({
      'house': _house,
      'electric': _electric,
      'water': _water,
      'bike': _motorbike,
    });
    prefs.setString('housing[${DateTime.now().month}/${DateTime.now().year}]', housingData);
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString('housing[${DateTime.now().month}/${DateTime.now().year}]');
    if (jsonData != null) {
      final extractedUserData = json.decode(jsonData);
      _house = extractedUserData['house'];
      _electric = extractedUserData['electric'];
      _water = extractedUserData['water'];
      _motorbike = extractedUserData['bike'];
      notifyListeners();
    } else {
      _house = 0;
      _electric = 0;
      _water = 0;
      _motorbike = 0;
      print('NO HOUSING DATA');
    }
  }
}