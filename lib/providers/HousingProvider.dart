import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Housing_Provider with ChangeNotifier{
  int _house = 0;
  int _electric = 0;
  int _water = 0;
  int _motorbike = 0;
  String? authToken;

  Housing_Provider(this.authToken);

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
    var uri = Uri.parse(
        'https://phong-s-app-default-rtdb.firebaseio.com/housing.json?$authToken');
    await http.patch(uri,
        body: json.encode({
          'house': _house,
          'electric': _electric,
          'water': _water,
          'motorbike': _motorbike,
        }));

    final prefs = await SharedPreferences.getInstance();
    final housingJson = json.encode({
      'house': _house,
      'electric': _electric,
      'water': _water,
      'motorbike': _motorbike,
    });
    prefs.setString('housing_${DateTime.now().month}_${DateTime.now().year}', housingJson);
  }

  Future<void> loadData() async {
    var uri = Uri.parse(
        'https://phong-s-app-default-rtdb.firebaseio.com/housing.json?$authToken');
    final housingData = await http.get(uri).catchError((err) => print('FETCH CATEGORIES ERROR'));
    final extractedData = json.decode(housingData.body);
    _electric = extractedData['electric'] ?? 0;
    _water = extractedData['water'] ?? 0;
    _house = extractedData['house'] ?? 0;
    _motorbike = extractedData['motorbike'] ?? 0;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString('housing_${DateTime.now().month}_${DateTime.now().year}');
    if (jsonData != null) {
      final extractedUserData = json.decode(jsonData);
      _house = extractedUserData['house'] ?? 0;
      _electric = extractedUserData['electric'] ?? 0;
      _water = extractedUserData['water'] ?? 0;
      _motorbike = extractedUserData['bike'] ?? 0;
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