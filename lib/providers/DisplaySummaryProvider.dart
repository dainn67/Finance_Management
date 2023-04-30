import 'package:flutter/material.dart';

class Display_Summary_Provider with ChangeNotifier {
  int _displayFAD = 0;
  int _displayHousehold = 0;
  int _displayTotal = 0;
  int _displayElectric = 0;
  int _displayWater = 0;
  int _displayFee = 0;

  int get displayFAD => _displayFAD;

  int get displayHousehold => _displayHousehold;

  int get displayTotal => _displayTotal;

  int get displayElectric => _displayElectric;

  int get displayWater => _displayWater;

  int get displayFee => _displayFee;

  void changeFAD(int val) {
    _displayFAD = val;
    notifyListeners();
  }

  void changeHousehold(int val) {
    _displayHousehold = val;
    notifyListeners();
  }

  void changeTotal(int val) {
    _displayTotal = val;
    notifyListeners();
  }

  void changeElectric(int val) {
    _displayElectric = val;
    notifyListeners();
  }

  void changeWater(int val) {
    _displayWater = val;
    notifyListeners();
  }

  void changeFee(int val) {
    _displayFee = val;
    notifyListeners();
  }
}
