import 'package:flutter/material.dart';

class Other_Provider with ChangeNotifier{
  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void setDate(DateTime dateTime){
    _selectedDate = dateTime;
    notifyListeners();
  }

   pickDate(BuildContext context) async {
    return showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime(2020), lastDate: DateTime(2025));
  }
}