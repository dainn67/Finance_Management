import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:phongs_app/data.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class MoreView extends StatefulWidget {
  const MoreView({Key? key}) : super(key: key);

  @override
  State<MoreView> createState() => _MoreViewState();
}

class _MoreViewState extends State<MoreView> {
  final currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  int displayMonth = DateTime.now().month;
  int displayYear = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.summarize_outlined),
                  label: const Text('Lưu tổng kết'),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.blue),
                  ),
                  onPressed: () {
                    saveSummary();
                  },
                ),
                OutlinedButton.icon(
                  icon: Icon(
                    Icons.summarize,
                    color: getHouseMoneyColor(
                        check[hashYear(displayYear)][displayMonth]),
                  ),
                  label: Text(
                    'Tính tiền nhà',
                    style: TextStyle(
                        color: getHouseMoneyColor(
                            check[hashYear(displayYear)][displayMonth])),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                        color: getHouseMoneyColor(
                            check[hashYear(displayYear)][displayMonth])),
                  ),
                  onPressed: () {
                    computeAll();
                  },
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                  onTap: () {
                    setState(() {
                      if (!(displayMonth == 1 && displayYear == 2023)) {
                        if (displayMonth == 1) {
                          displayMonth = 12;
                          displayYear--;
                        } else {
                          displayMonth--;
                        }
                      }
                    });
                  },
                  child: const Icon(Icons.chevron_left)),
              const SizedBox(width: 10),
              Text("Tháng $displayMonth/$displayYear",
                  style: GoogleFonts.firaSans(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(width: 10),
              GestureDetector(
                  onTap: () {
                    if ((displayMonth < DateTime.now().month &&
                            displayYear >= DateTime.now().year) ||
                        displayYear < DateTime.now().year) {
                      setState(() {
                        if (displayMonth == 12) {
                          displayYear++;
                          displayMonth = 1;
                        } else {
                          displayMonth++;
                        }
                      });
                    }
                  },
                  child: const Icon(Icons.chevron_right)),
            ],
          ),
          ListTile(
            title:
                Text("Phong đóng", style: GoogleFonts.firaSans(fontSize: 20)),
            trailing: Text(
              currencyFormatter
                  .format(moneyToPayy[hashYear(displayYear)][displayMonth][1]),
              style: const TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.0001),
          ListTile(
            title: Text("Tùng đóng", style: GoogleFonts.firaSans(fontSize: 20)),
            trailing: Text(
              currencyFormatter
                  .format(moneyToPayy[hashYear(displayYear)][displayMonth][2]),
              style: const TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.0001),
          ListTile(
            title: Text("Lâm đóng", style: GoogleFonts.firaSans(fontSize: 20)),
            trailing: Text(
              currencyFormatter
                  .format(moneyToPayy[hashYear(displayYear)][displayMonth][3]),
              style: const TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.0001),
          ListTile(
            title: Text("Hiển đóng", style: GoogleFonts.firaSans(fontSize: 20)),
            trailing: Text(
              currencyFormatter
                  .format(moneyToPayy[hashYear(displayYear)][displayMonth][4]),
              style: const TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.0001),
          Text("Từ lần tổng kết cuối",
              style: GoogleFonts.firaSans(
                  fontSize: 20, fontWeight: FontWeight.bold)),
          ListTile(
            title:
                Text("Phong đóng", style: GoogleFonts.firaSans(fontSize: 20)),
            trailing: Text(
              currencyFormatter.format(moneyToPayy[hashYear(displayYear)]
                      [displayMonth][1] -
                  saved[hashYear(displayYear)][displayMonth][1]),
              style: const TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.0001),
          ListTile(
            title: Text("Tùng đóng", style: GoogleFonts.firaSans(fontSize: 20)),
            trailing: Text(
              currencyFormatter.format(moneyToPayy[hashYear(displayYear)]
                      [displayMonth][2] -
                  saved[hashYear(displayYear)][displayMonth][2]),
              style: const TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.0001),
          ListTile(
            title: Text("Lâm đóng", style: GoogleFonts.firaSans(fontSize: 20)),
            trailing: Text(
              currencyFormatter.format(moneyToPayy[hashYear(displayYear)]
                      [displayMonth][3] -
                  saved[hashYear(displayYear)][displayMonth][3]),
              style: const TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.0001),
          ListTile(
            title: Text("Hiển đóng", style: GoogleFonts.firaSans(fontSize: 20)),
            trailing: Text(
              currencyFormatter.format(moneyToPayy[hashYear(displayYear)]
                      [displayMonth][4] -
                  saved[hashYear(displayYear)][displayMonth][4]),
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  Color getHouseMoneyColor(int x) {
    switch (x) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  Future<void> saveSummary() async {
    setState(() {
      for (int i = 1; i <= 4; i++) {
        saved[hashYear(displayYear)][displayMonth][i] =
            moneyToPayy[hashYear(displayYear)][displayMonth][i];
      }
    });
    final fileSaved = await _localSaved;
    fileSaved.writeAsString(jsonEncode(saved));
  }

  Future<void> computeAll() async {
    if (check[hashYear(displayYear)][displayMonth] == 0) {
      //nếu chưa tính tiền nhà
      setState(() {
        for (int i = 1; i <= 3; i++) {
          moneyToPayy[hashYear(displayYear)][displayMonth][i] +=
              (house[hashYear(displayYear)][displayMonth] +
                  (electric[hashYear(displayYear)][displayMonth] ~/ 5) +
                  (water[hashYear(displayYear)][displayMonth] ~/ 5));
          //nếu đi xe thì thêm tiền xe nữa
          if (motors[hashYear(displayYear)][displayMonth][i - 1]) {
            moneyToPayy[hashYear(displayYear)][displayMonth][i] +=
                motorFee[hashYear(displayYear)][displayMonth];
          }
        }
        moneyToPayy[hashYear(displayYear)][displayMonth][4] +=
            ((electric[hashYear(displayYear)][displayMonth] ~/ 5) +
                (water[hashYear(displayYear)][displayMonth] ~/ 5));
        if (motors[hashYear(displayYear)][displayMonth][3]) {
          moneyToPayy[hashYear(displayYear)][displayMonth][4] +=
              motorFee[hashYear(displayYear)][displayMonth];
        }
        check[hashYear(displayYear)][displayMonth] = 1;
      });
    } else {
      //nếu đã tính tiền nhà và muốn huỷ
      setState(() {
        for (int i = 1; i <= 3; i++) {
          moneyToPayy[hashYear(displayYear)][displayMonth][i] -=
              (house[hashYear(displayYear)][displayMonth] +
                  (electric[hashYear(displayYear)][displayMonth] ~/ 5) +
                  (water[hashYear(displayYear)][displayMonth] ~/ 5));
          //nếu đi xe thì thêm tiền xe nữa
          if (motors[hashYear(displayYear)][displayMonth][i - 1]) {
            moneyToPayy[hashYear(displayYear)][displayMonth][i] -=
                motorFee[hashYear(displayYear)][displayMonth];
          }
        }
        moneyToPayy[hashYear(displayYear)][displayMonth][4] -=
            ((electric[hashYear(displayYear)][displayMonth] ~/ 5) +
                (water[hashYear(displayYear)][displayMonth] ~/ 5));
        if (motors[hashYear(displayYear)][displayMonth][3]) {
          moneyToPayy[hashYear(displayYear)][displayMonth][4] -=
              motorFee[hashYear(displayYear)][displayMonth];
        }
        check[hashYear(displayYear)][displayMonth] = 0;
      });
    }

    final fileSummary = await _localTotalSummary;
    fileSummary.writeAsString(jsonEncode(moneyToPayy));

    final fileCheck = await _localCheck;
    fileCheck.writeAsString(jsonEncode(check));
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localSaved async {
    final path = await _localPath;
    return File('$path/saved.txt');
  }

  Future<File> get _localTotalSummary async {
    final path = await _localPath;
    return File('$path/summary.txt');
  }

  Future<File> get _localCheck async {
    final path = await _localPath;
    return File('$path/check.txt');
  }
}

int hashYear(int year) {
  switch (year) {
    case 2023:
      return 0;
    case 2024:
      return 1;
    case 2025:
      return 2;
    case 2026:
      return 3;
    default:
      return 0;
  }
}
