import 'package:flutter/material.dart';

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