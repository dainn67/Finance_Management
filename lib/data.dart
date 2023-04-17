//categories selector
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

int cId = 0;
List<String> categories = ["General", "Statistic", "Housing", "Summary"];

//records
// List records = [];
String jsonRecord = ''; //saved

//tổng số tiền đã chi cho đồ ăn / đồ gia dụng
int totalStationery = 0;
String jsonStation = ''; //saved

int totalFood = 0; //saved
String jsonFood = ''; //saved

//filter trang statistics/thống kê
int filter = 0;

//số tiền phải đóng cho chủ nhà của các tháng
//từ năm 2023 đến 2026 từ tháng 4 đến 12, từ Phong > Tùng > Lâm > Hiển
//1:2023  2:2024  3:2025  4:2026 // tháng tương tự số // 1-Phong 2-Tùng  3-Lâm  4-Hiển

// List moneyToPay = List.filled(5, 0);
List<List<List<int>>> moneyToPayy = List.generate(
  4, // 0-2023  1-2024  2-2025  3-2026
  (i) => List.generate(
    13, // 12 month, leave 0 empty unused
    (j) => List.generate(
      5, // 1-Phong   2-Tung  3-Lam   4-Hien
      (k) => 0, // Initialize each element to 0
    ),
  ),
);
String jsonMoney = '';
//saved

//Lưu từ lần tổng kết cuối
List<List<List<int>>> saved = List.generate(
  4, // 0-2023  1-2024  2-2025  3-2026
  (i) => List.generate(
    13, // 12 month, leave 0 empty unused
    (j) => List.generate(
      5, // 1-Phong   2-Tung  3-Lam   4-Hien
      (k) => 0, // Initialize each element to 0
    ),
  ),
);
//saved

//HOUSING
//Danh sách tiền nhà mặc định 500k, điện nước, xe các tháng, mặc định 80k
List<List<int>> house =
    List.generate(4, (_) => List.generate(13, (_) => 500000)); //saved
List<List<int>> electric =
    List.generate(4, (_) => List.generate(13, (_) => 0)); //saved
List<List<int>> water =
    List.generate(4, (_) => List.generate(13, (_) => 0)); //saved
List<List<int>> motorFee =
    List.generate(4, (_) => List.generate(13, (_) => 80000)); //saved
//kiểm tra đã tính tiền nhà chưa
List<List<int>> check = List.generate(4, (_) => List.generate(13, (_) => 0));

//danh sách người đi xe máy, trừ Khánh
List<List<List<bool>>> motors = List.generate(
  4,
  (i) => List.generate(
    13,
    (j) => List.generate(
      4,
      (k) => false,
    ),
  ),
);
//saved

class Record {
  String name;
  int money;
  String date;
  int by;
  int type;
  String people;

  Record(this.name, this.money, this.date, this.by, this.type, this.people);
}

class Record_Provider with ChangeNotifier{
  List<Record> _records = [];

  List<Record> get records{
    return [..._records];  //return a copy of items only
  }

  int getSize() => records.length;

  void addRecord(Record newRecord){
    _records.add(newRecord);
    notifyListeners();
  }

  void removeRecord(int id){
    _records.removeAt(id);
  }
}

class State_Provider with ChangeNotifier{
  bool isLoading = false;

  bool getLoadingState() => isLoading;

  void changeLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }
}
