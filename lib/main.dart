import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:phongs_app/data.dart';
import 'package:phongs_app/views/HomePage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'dart:async';

void main() {
  runApp(MyApp(storage: CounterStorage()));
}

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localRecords async {
    final path = await _localPath;
    return File('$path/records.txt');
  }

  Future<File> get _localTotalStationery async {
    final path = await _localPath;
    return File('$path/stationery.txt');
  }

  Future<File> get _localTotalFood async {
    final path = await _localPath;
    return File('$path/food.txt');
  }

  Future<File> get _localTotalSummary async {
    final path = await _localPath;
    return File('$path/summary.txt');
  }

  Future<File> get _localSaved async {
    final path = await _localPath;
    return File('$path/saved.txt');
  }

  Future<File> get _localMotors async {
    final path = await _localPath;
    return File('$path/motors.txt');
  }

  Future<File> get _localHouse async {
    final path = await _localPath;
    return File('$path/house.txt');
  }

  Future<File> get _localElectric async {
    final path = await _localPath;
    return File('$path/electric.txt');
  }

  Future<File> get _localWater async {
    final path = await _localPath;
    return File('$path/water.txt');
  }

  Future<File> get _localMotorFee async {
    final path = await _localPath;
    return File('$path/motorsFee.txt');
  }

  Future<File> get _localCheck async {
    final path = await _localPath;
    return File('$path/check.txt');
  }

  Future<String> readDataRecord() async {
    try {
      final fileRecord = await _localRecords;
      return jsonRecord = await fileRecord.readAsString();
    } catch (e) {
      return jsonRecord = e.toString();
    }
  }

  Future<int> readDataStationery() async {
    try {
      final fileStation = await _localTotalStationery;
      jsonStation = await fileStation.readAsString();
      return totalStationery = int.parse(jsonStation);
    } catch (e) {
      return 0;
    }
  }

  Future<int> readDataFood() async {
    try {
      final fileFood = await _localTotalFood;
      jsonFood = await fileFood.readAsString();
      return totalFood = int.parse(jsonFood);
    } catch (e) {
      return 0;
    }
  }

  Future<List<List<List<int>>>> readDataMoney() async {
    try {
      final file = await _localTotalSummary;
      final contents = file.readAsStringSync();
      return moneyToPayy = List<List<List<int>>>.from(jsonDecode(contents).map(
          (x) => List<List<int>>.from(
              x.map((y) => List<int>.from(y.map((z) => z))))));
    } catch (e) {
      return List.generate(
        4, // 0-2023  1-2024  2-2025  3-2026
        (i) => List.generate(
          13, // 12 month, leave 0 empty unused
          (j) => List.generate(
            5, // 1-Phong   2-Tung  3-Lam   4-Hien
            (k) => 0, // Initialize each element to 0
          ),
        ),
      );
    }
  }

  Future<List<List<List<int>>>> readDataSaved() async {
    try {
      final file = await _localSaved;
      final contents = file.readAsStringSync();
      return saved = List<List<List<int>>>.from(jsonDecode(contents).map((x) =>
          List<List<int>>.from(x.map((y) => List<int>.from(y.map((z) => z))))));
    } catch (e) {
      return List.generate(
        4, // 0-2023  1-2024  2-2025  3-2026
        (i) => List.generate(
          13, // 12 month, leave 0 empty unused
          (j) => List.generate(
            5, // 1-Phong   2-Tung  3-Lam   4-Hien
            (k) => 0, // Initialize each element to 0
          ),
        ),
      );
    }
  }

  Future<List<List<List<bool>>>> readDataMotors() async {
    try {
      final file = await _localMotors;
      final contents = file.readAsStringSync();
      final decodedContent = jsonDecode(contents);
      return motors = List.generate(
          decodedContent.length,
          (i) => List.generate(
              decodedContent[i].length,
              (j) => List.generate(decodedContent[i][j].length,
                  (k) => decodedContent[i][j][k] as bool)));
    } catch (e) {
      return List.generate(
        4, // 0-2023  1-2024  2-2025  3-2026
        (i) => List.generate(
          13, // 12 month, leave 0 empty unused
          (j) => List.generate(
            5, // 1-Phong   2-Tung  3-Lam   4-Hien
            (k) => true, // Initialize each element to 0
          ),
        ),
      );
    }
  }

  Future<List<List<int>>> readDataHouse() async {
    try {
      final file = await _localHouse;
      final content = file.readAsStringSync();
      final decodedContents = jsonDecode(content);
      return house = List<List<int>>.from(
          decodedContents.map((row) => List<int>.from(row.map((e) => e))));
    } catch (e) {
      // If there's an error reading the file, return an empty list
      return [];
    }
  }

  Future<List<List<int>>> readDataElectric() async {
    try {
      final file = await _localElectric;
      final content = file.readAsStringSync();
      final decodedContents = jsonDecode(content);
      return electric = List<List<int>>.from(
          decodedContents.map((row) => List<int>.from(row.map((e) => e))));
    } catch (e) {
      // If there's an error reading the file, return an empty list
      return [];
    }
  }

  Future<List<List<int>>> readDataWater() async {
    try {
      final file = await _localWater;
      final content = file.readAsStringSync();
      final decodedContents = jsonDecode(content);
      return water = List<List<int>>.from(
          decodedContents.map((row) => List<int>.from(row.map((e) => e))));
    } catch (e) {
      // If there's an error reading the file, return an empty list
      return [];
    }
  }

  Future<List<List<int>>> readDataMotorFee() async {
    try {
      final file = await _localMotorFee;
      final content = file.readAsStringSync();
      final decodedContents = jsonDecode(content);
      return motorFee = List<List<int>>.from(
          decodedContents.map((row) => List<int>.from(row.map((e) => e))));
    } catch (e) {
      // If there's an error reading the file, return an empty list
      return [];
    }
  }

  Future<List<List<int>>> readDataCheck() async {
    try {
      final file = await _localCheck;
      final content = file.readAsStringSync();
      final decodedContents = jsonDecode(content);
      return check = List<List<int>>.from(
          decodedContents.map((row) => List<int>.from(row.map((e) => e))));
    } catch (e) {
      // If there's an error reading the file, return an empty list
      return [];
    }
  }
}

class MyApp extends StatefulWidget {
  final CounterStorage storage;

  const MyApp({Key? key, required this.storage}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // widget.storage.readDataRecord().then((value) {
    //   setState(() {
    //     jsonRecord = value;
    //     records = jsonDecode(jsonRecord);
    //   });
    // });
    // widget.storage.readDataStationery().then((value) {
    //   setState(() {
    //     totalStationery = value;
    //   });
    // });
    // widget.storage.readDataFood().then((value) {
    //   setState(() {
    //     totalFood = value;
    //   });
    // });
    // widget.storage.readDataMoney();
    // widget.storage.readDataSaved();
    // widget.storage.readDataMotors();
    // widget.storage.readDataHouse();
    // widget.storage.readDataElectric();
    // widget.storage.readDataWater();
    // widget.storage.readDataMotorFee();
    // widget.storage.readDataCheck();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Record_Provider()),
        ChangeNotifierProvider(create: (context) => State_Provider()),
      ],
      child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home:
              // LoginPage()
              HomePageView()
          // PlannedPayment()
          ),
    );
  }
}
