import 'package:flutter/foundation.dart';

class Title_Provider with ChangeNotifier{
  int title = 1;

  void setTitle(int target){
    title = target;
    notifyListeners();
  }
}