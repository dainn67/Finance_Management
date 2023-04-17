import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../data.dart';
import 'DashBoard.dart';
import 'dart:io';

class StatisticView extends StatefulWidget {
  const StatisticView({Key? key}) : super(key: key);

  @override
  State<StatisticView> createState() => _StatisticViewState();
}

class _StatisticViewState extends State<StatisticView> {
  var currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  @override
  Widget build(BuildContext context) {
    switch(isLoading){
      case true: return const Center(child: CircularProgressIndicator());
      default:  return (!isLoading && records.isNotEmpty)
          ? ListView.builder(
              itemCount: records.length,
              itemBuilder: (context, id) {
                return Dismissible(
                  key: Key(records[records.length - id - 1].toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    setState(() {
                      records.removeAt(records.length - id - 1);
                    });
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) {
                    return showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                              title: const Text("Delete record"),
                              content: const Text(
                                  "Are you sure you want to delete this record"),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(true);     //return true so that confirmDismiss delete the record
                                    }, child: Text("Yes")),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(false);     //return false so that confirmDismiss don't delete the record
                                    },
                                    child: Text("No"))
                              ],
                            ));
                  },
                  child: ListTile(
                    onTap: () {
                      detailAndEdit(records.length - id - 1);
                    },
                    onLongPress: () {
                      delete(records.length - id - 1);
                    },
                    leading: buildLeading(records[records.length - id - 1]["by"]),
                    subtitle: Text(records[records.length - id - 1]["date"]),
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          records[records.length - id - 1]["name"],
                          style: const TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                            "-${currencyFormat.format(records[records.length - id - 1]["money"])}",
                            style: const TextStyle(
                                fontSize: 16.0, color: Colors.purple)),
                      ],
                    ),
                    trailing: (() {
                      switch (records[records.length - id - 1]["type"]) {
                        case 2:
                          return const Icon(Icons.home_work_outlined);
                        case 1:
                          return const Icon(Icons.fastfood_outlined);
                      }
                    })(),
                  ),
                );
              })
          : Container(
              alignment: Alignment.center,
              child: const Text(
                'Chưa có chi tiêu nào',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
    }
  }

  void detailAndEdit(int id) => showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Chi tiết'),
            content: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text("Tên chi tiêu",
                        style: GoogleFonts.firaSans(
                          fontSize: 22,
                        )),
                    trailing: Text(records[id]["name"],
                        style: GoogleFonts.firaSans(
                          fontSize: 22,
                        )),
                  ),
                  ListTile(
                    title: Text("Số tiền",
                        style: GoogleFonts.firaSans(fontSize: 22)),
                    trailing: Text(currencyFormat.format(records[id]["money"]),
                        style: GoogleFonts.firaSans(fontSize: 22)),
                  ),
                  ListTile(
                    title: Text("Người mua",
                        style: GoogleFonts.firaSans(fontSize: 22)),
                    trailing: Text(getBuyer(records[id]["by"]),
                        style: GoogleFonts.firaSans(fontSize: 22)),
                  ),
                  ListTile(
                    title: Text("Người dùng",
                        style: GoogleFonts.firaSans(fontSize: 22)),
                    subtitle: Text(getPeople(records[id]["people"])),
                    trailing: Text(getNumberOfPeople(records[id]["people"])),
                  ),
                  ListTile(
                    title: Text("Ngày mua",
                        style: GoogleFonts.firaSans(fontSize: 22)),
                    trailing: Text(records[id]["date"],
                        style: GoogleFonts.firaSans(fontSize: 22)),
                  ),
                  ListTile(
                    title: Text("Mỗi người đóng",
                        style: GoogleFonts.firaSans(fontSize: 22)),
                    trailing: Text(
                        currencyFormat.format(getEqualMoney(
                            records[id]["money"], records[id]["people"])),
                        style: GoogleFonts.firaSans(fontSize: 22)),
                  )
                ],
              ),
            ),
          );
        },
      );

  void delete(int id) => showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Xoá chi tiêu'),
            content: const Text('Bạn có chắc muốn xoá chi tiêu này ?'),
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
                    refund(
                        records[id]["money"],
                        records[id]["by"],
                        records[id]["people"],
                        records[id]["date"],
                        records[id]["type"]);
                    records.remove(records[id]);

                    jsonRecord = "";
                    for (int i = 0; i < records.length; i++) {
                      if (i == 0) {
                        jsonRecord = "[${jsonEncode(records[i])}";
                      } else {
                        jsonRecord = "$jsonRecord, ${jsonEncode(records[i])}";
                      }
                    }
                    if (records.isNotEmpty)
                      jsonRecord += ']';
                    else
                      jsonRecord += '[]';
                  });
                  final fileTotalFood = await _localTotalFood;
                  fileTotalFood.writeAsString(jsonEncode(totalFood));

                  final fileTotalStationery = await _localTotalStationery;
                  fileTotalStationery
                      .writeAsString(jsonEncode(totalStationery));

                  final fileRecords = await _localRecords;
                  fileRecords.writeAsStringSync(jsonRecord.toString());

                  final tmp = fileRecords.readAsStringSync();
                  print("RECORDS: $tmp");
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

  String getBuyer(int i) {
    switch (i) {
      case 1:
        return "Phong";
      case 2:
        return "Khánh";
      case 3:
        return "Tùng";
      case 4:
        return "Lâm";
      default:
        return "Hiển";
    }
  }

  String getPeople(String s) {
    String res = "";
    if (s[0] == '1') res = res + "Phong";
    if (s[1] == '1') res = res + " Khánh";
    if (s[2] == '1') res = res + " Tùng";
    if (s[3] == '1') res = res + " Lâm";
    if (s[4] == '1') res = res + " Hiển";
    return res;
  }

  String getNumberOfPeople(String s) {
    int count = 0;
    for (int i = 0; i < s.length; i++) {
      if (s[i] == '1') count++;
    }
    return "$count";
  }

  int getEqualMoney(int money, String s) {
    return money ~/ int.parse(getNumberOfPeople(s));
  }

  Future<void> refund(
      int money, int buyer, String people, String date, int type) async {
    List<String> dateParts = date.split('/');
    int month = int.parse(dateParts[1]);
    int year = int.parse(dateParts[2]);

    int hashYear = 0;
    switch (year) {
      case 2023:
        hashYear = 0;
        break;
      case 2024:
        hashYear = 1;
        break;
      case 2025:
        hashYear = 2;
        break;
      case 2026:
        hashYear = 3;
        break;
    }

    //tính tiền hoàn lại mọi người
    if (type == 1) {
      totalFood -= money;
    } else {
      totalStationery -= money;
    }
    int equal = getEqualMoney(money, people);
    if (buyer == 2) {
      if (people[0] == '1') moneyToPayy[hashYear][month][1] -= equal;
      for (int i = 2; i <= 4; i++) {
        if (people[i] == '1') moneyToPayy[hashYear][month][i] -= equal;
      }
    } else {
      if (people[buyer - 1] == '0') {
        if (buyer == 1) {
          moneyToPayy[hashYear][month][1] += money;
          for (int i = 2; i <= 4; i++) {
            if (people[i] == '1') moneyToPayy[hashYear][month][i] -= equal;
          }
        } else {
          moneyToPayy[hashYear][month][buyer - 1] += money;
          if (people[0] == '1') moneyToPayy[hashYear][month][1] -= equal;
          for (int i = 2; i <= 4; i++) {
            if (people[i] == '1' && i != buyer - 1)
              moneyToPayy[hashYear][month][i] -= equal;
          }
        }
      } else {
        if (buyer == 1) {
          moneyToPayy[hashYear][month][1] +=
              equal * (int.parse(getNumberOfPeople(people)) - 1);
          for (int i = 2; i <= 4; i++) {
            if (people[i] == '1') moneyToPayy[hashYear][month][i] -= equal;
          }
        } else {
          moneyToPayy[hashYear][month][buyer - 1] +=
              equal * (int.parse(getNumberOfPeople(people)) - 1);
          for (int i = 2; i <= 4; i++) {
            if (people[i] == '1' && i != buyer - 1)
              moneyToPayy[hashYear][month][i] -= equal;
          }
        }
      }
    }
    //lưu lại tiền mới
    final fileSummary = await _localTotalSummary;
    fileSummary.writeAsString(jsonEncode(moneyToPayy));
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localRecords async {
    final path = await _localPath;
    return File('$path/records.txt');
  }

  Future<File> get _localTotalSummary async {
    final path = await _localPath;
    return File('$path/summary.txt');
  }

  Future<File> get _localTotalStationery async {
    final path = await _localPath;
    return File('$path/stationery.txt');
  }

  Future<File> get _localTotalFood async {
    final path = await _localPath;
    return File('$path/food.txt');
  }
}
