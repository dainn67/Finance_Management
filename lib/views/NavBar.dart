import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../data.dart';
import 'AboutUs.dart';
import 'UserGuide.dart';

typedef void FunctionCaller();

class NavBarView extends StatefulWidget {
  // const NavBar({Key? key}) : super(key: key);
  final FunctionCaller functionCaller;

  NavBarView({required this.functionCaller});

  @override
  State<NavBarView> createState() => _NavBarViewState();
}

class _NavBarViewState extends State<NavBarView> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName:
                const Text("Phong NDH", style: TextStyle(color: Colors.white)),
            accountEmail: const Text("pephoi@gmail.com",
                style: TextStyle(color: Colors.white)),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset("assets/images/frog.jpg",
                    height: 90, width: 90, fit: BoxFit.cover),
              ),
            ),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/mc.jpg"),
                    fit: BoxFit.cover)),
          ),
          ListTile(
              leading: const Icon(Icons.account_tree_outlined),
              title: const Text("Đặt lại"),
              onTap: () => reset()),
          ListTile(
              leading: const Icon(Icons.account_tree_outlined),
              title: const Text("Đặt lại tháng này"),
              onTap: () => resetThisMonth()),
          ListTile(
            leading: const Icon(Icons.question_mark),
            title: const Text("Hướng dẫn dùng"),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => UserGuide())),
          ),
          ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Cài đặt"),
              onTap: () {
                setting();
              }),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("Thông tin app"),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AboutUs())),
          ),
        ],
      ),
    );
    ;
  }

  void reset() => showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Xác nhận hành động'),
            content: const Text('Bạn có chắc muốn đặt lại dữ liệu ?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Huỷ'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Đồng ý'),
                onPressed: () {
                  setState(() {
                    records.clear();
                    totalFood = 0;
                    totalStationery = 0;

                    for (int i = 0; i < 4; i++) {
                      for (int j = 0; j <= 12; j++) {
                        check[i][j] = 0;
                        house[i][j] = 500000;
                        electric[i][j] = 0;
                        water[i][j] = 0;
                        motorFee[i][j] = 80000;
                        for (int k = 0; k <= 4; k++) {
                          moneyToPayy[i][j][k] = 0;
                          saved[i][j][k] = 0;
                        }
                      }
                    }
                    widget.functionCaller();
                  });
                  jsonRecord = "";
                  for (int i = 0; i < records.length; i++) {
                    if (i == 0) {
                      jsonRecord = "[${jsonEncode(records[i])}";
                    } else {
                      jsonRecord = "$jsonRecord, ${jsonEncode(records[i])}";
                    }
                  }
                  if(records.isNotEmpty) jsonRecord += ']';
                  else jsonRecord += '[]';
                  writeData();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

  void resetThisMonth() => showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Xác nhận hành động'),
        content: const Text('Bạn có chắc muốn đặt lại dữ liệu của tháng này ?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Huỷ'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Đồng ý'),
            onPressed: () async {
              setState(() {
                int tmpFood = 0, tmpStationery = 0;
                int thisMonth = DateTime.now().month;
                int thisYearHashed = DateTime.now().year % 2020 - 3;

                //remove records of that month
                for(int i=records.length-1; i>=0; i--){
                  List<String> dateParts = records[i]["date"].split('/');
                  int month = int.parse(dateParts[1]);
                  int year = int.parse(dateParts[2]) % 2020 - 3;
                  print("CUR MONTH: $month CUR YEAR: $year");
                  if(month == thisMonth && year == thisYearHashed){
                    if(records[i]["type"] == 1) {
                      tmpFood += int.parse(records[i]["money"].toString());
                    } else {
                      tmpStationery += int.parse(records[i]["money"].toString());
                    }
                    print('DELETE ${records[i]}');
                    records.remove(records[i]);
                  }
                }

                //refund the money of that month

                totalFood -= tmpFood;
                totalStationery -= tmpStationery;

                print("NEW FOOD: $totalFood NEW STA $totalStationery");

                check[thisYearHashed][thisMonth] = 0;
                house[thisYearHashed][thisMonth] = 500000;
                electric[thisYearHashed][thisMonth] = 0;
                water[thisYearHashed][thisMonth] = 0;
                motorFee[thisYearHashed][thisMonth] = 80000;
                for (int k = 0; k <= 4; k++) {
                  moneyToPayy[thisYearHashed][thisMonth][k] = 0;
                  saved[thisYearHashed][thisMonth][k] = 0;
                }
                widget.functionCaller();
              });
              jsonRecord = "";
              for (int i = 0; i < records.length; i++) {
                if (i == 0) {
                  jsonRecord = "[${jsonEncode(records[i])}";
                } else {
                  jsonRecord = "$jsonRecord, ${jsonEncode(records[i])}";
                }
              }
              if(records.isNotEmpty) jsonRecord += ']';
              else jsonRecord += '[]';
              writeData();

              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );

  void help() => showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Hướng dẫn sử dụng'),
            content: const Text('Note debug: Cho file readme vào đây'),
            actions: <Widget>[
              TextButton(
                child: const Text('Xong'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

  void setting() => showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Cài đặt'),
            content: const Text('Chưa có cài đặt'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localCheck async {
    final path = await _localPath;
    return File('$path/check.txt');
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

  Future<File> get _localSaved async {
    final path = await _localPath;
    return File('$path/saved.txt');
  }

  Future<void> writeData() async {
    final fileRecords = await _localRecords;
    fileRecords.writeAsStringSync(jsonRecord.toString());

    final fileStation = await _localTotalStationery;
    fileStation.writeAsString('$totalStationery');

    final fileFood = await _localTotalFood;
    fileFood.writeAsString('$totalFood');

    final fileSummary = await _localTotalSummary;
    fileSummary.writeAsString(jsonEncode(moneyToPayy));

    final fileSaved = await _localSaved;
    fileSaved.writeAsString(jsonEncode(saved));

    final fileHouse = await _localHouse;
    fileHouse.writeAsStringSync(jsonEncode(house));

    final fileElectric = await _localElectric;
    fileElectric.writeAsStringSync(jsonEncode(electric));

    final fileWater = await _localWater;
    fileWater.writeAsStringSync(jsonEncode(water));

    final fileFee = await _localMotorFee;
    fileFee.writeAsStringSync(jsonEncode(motorFee));

    final fileCheck = await _localCheck;
    fileCheck.writeAsString(jsonEncode(check));
  }
}
