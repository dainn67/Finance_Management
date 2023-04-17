import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:phongs_app/data.dart';
import 'package:phongs_app/views/Summary.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class HousingView extends StatefulWidget {
  const HousingView({Key? key}) : super(key: key);

  @override
  State<HousingView> createState() => _HousingViewState();
}

class _HousingViewState extends State<HousingView> {
  final currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
  final TextEditingController _house = TextEditingController();
  final TextEditingController _electric = TextEditingController();
  final TextEditingController _water = TextEditingController();
  final TextEditingController _bike = TextEditingController();

  int displayMonth = DateTime.now().month;
  int displayYear = DateTime.now().year;

  static const _locale = 'en';

  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 10),
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
                      fontSize: 22, fontWeight: FontWeight.bold)),
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
          GestureDetector(
            onTap: () {
              editHouse();
            },
            child: ListTile(
              leading: const Icon(Icons.house_outlined),
              title:
                  Text("Tiền nhà", style: GoogleFonts.firaSans(fontSize: 20)),
              subtitle: const Text("Bấm để sửa"),
              trailing: Text(
                currencyFormatter
                    .format(house[hashYear(displayYear)][displayMonth]),
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              editElectric();
            },
            child: ListTile(
              leading: const Icon(Icons.electric_bolt),
              title:
                  Text("Tiền điện", style: GoogleFonts.firaSans(fontSize: 20)),
              subtitle: const Text("Bấm để sửa"),
              trailing: Text(
                currencyFormatter
                    .format(electric[hashYear(displayYear)][displayMonth]),
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              editWater();
            },
            child: ListTile(
              leading: const Icon(Icons.water_drop_outlined),
              title:
                  Text("Tiền nước", style: GoogleFonts.firaSans(fontSize: 20)),
              subtitle: const Text("Bấm để sửa"),
              trailing: Text(
                currencyFormatter
                    .format(water[hashYear(displayYear)][displayMonth]),
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ListTile(
            onTap: () {
              editMotorFee();
            },
            leading: const Icon(Icons.pedal_bike_outlined),
            title: Text("Phụ phí (gửi xe)",
                style: GoogleFonts.firaSans(fontSize: 20)),
            subtitle: const Text("Bấm để sửa"),
            trailing: Text(
              currencyFormatter
                  .format(motorFee[hashYear(displayYear)][displayMonth]),
              style: const TextStyle(fontSize: 20),
            ),
          ),
          Row(
            children: [
              Checkbox(
                value: motors[hashYear(displayYear)][displayMonth][0],
                onChanged: (bool? value) async {
                  setState(() {
                    motors[hashYear(displayYear)][displayMonth][0] = value!;
                  });
                  final fileMotors = await _localMotors;
                  fileMotors.writeAsStringSync(jsonEncode(motors));
                },
              ),
              const Text('Phong'),
              SizedBox(width: MediaQuery.of(context).size.width * 0.02),
              Checkbox(
                value: motors[hashYear(displayYear)][displayMonth][1],
                onChanged: (bool? value) async {
                  setState(() {
                    motors[hashYear(displayYear)][displayMonth][1] = value!;
                  });
                  final fileMotors = await _localMotors;
                  fileMotors.writeAsStringSync(jsonEncode(motors));
                },
              ),
              const Text('Tùng'),
              SizedBox(width: MediaQuery.of(context).size.width * 0.02),
              Checkbox(
                value: motors[hashYear(displayYear)][displayMonth][2],
                onChanged: (bool? value) async {
                  setState(() {
                    motors[hashYear(displayYear)][displayMonth][2] = value!;
                  });
                  final fileMotors = await _localMotors;
                  fileMotors.writeAsStringSync(jsonEncode(motors));
                },
              ),
              const Text('Lâm'),
              SizedBox(width: MediaQuery.of(context).size.width * 0.02),
              Checkbox(
                value: motors[hashYear(displayYear)][displayMonth][3],
                onChanged: (bool? value) async {
                  setState(() {
                    motors[hashYear(displayYear)][displayMonth][3] = value!;
                  });
                  final fileMotors = await _localMotors;
                  fileMotors.writeAsStringSync(jsonEncode(motors));
                },
              ),
              const Text('Hiển'),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(),
          GestureDetector(
            onTap: () {
              showTotalEach();
            },
            child: ListTile(
              leading: const Icon(Icons.done_all),
              title: Text("Tổng / Mỗi người",
                  style: GoogleFonts.firaSans(fontSize: 20)),
              subtitle: const Text("Bấm xem chi tiết"),
            ),
          )
        ],
      ),
    );
  }

  void editHouse() => showDialog(
        context: context,
        builder: (BuildContext context) {
          // String people = getPeople(getPeople(records[id]["people"]));

          return AlertDialog(
            title: const Text('Tiền nhà'),
            content: Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Nhập tiền nhà (VND)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    controller: _house,
                    keyboardType: TextInputType.number,
                    onChanged: (string) {
                      string = _formatNumber(string.replaceAll(',', ''));
                      if (string.isNotEmpty) {
                        // print("STRING: $string");
                        _house.value = TextEditingValue(
                          text: string,
                          selection:
                              TextSelection.collapsed(offset: string.length),
                        );
                        print("HOUSE TEXT:${_house.text.replaceAll(RegExp(r'\.\d+'), '').replaceAll(',', '')}");
                      }
                      // cmoney.text = int.parse(string.text.toString());
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Huỷ'),
                onPressed: () {
                  _house.clear();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Nhập'),
                onPressed: () async {
                  house[hashYear(displayYear)][displayMonth] = int.parse(_house.text.replaceAll(RegExp(r'\.\d+'), '').replaceAll(',', ''));
                  final fileHouse = await _localHouse;
                  fileHouse.writeAsStringSync(jsonEncode(house));
                  _house.clear();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

  void editElectric() => showDialog(
        context: context,
        builder: (BuildContext context) {
          // String people = getPeople(getPeople(records[id]["people"]));

          return AlertDialog(
            title: const Text('Tiền điện'),
            content: Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Nhập tiền điện (VND)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    controller: _electric,
                    keyboardType: TextInputType.number,
                    onChanged: (string) {
                      string = _formatNumber(string.replaceAll(',', ''));
                      if (string.isNotEmpty) {
                        // print("STRING: $string");
                        _electric.value = TextEditingValue(
                          text: string,
                          selection:
                              TextSelection.collapsed(offset: string.length),
                        );
                        print(
                            "ELECTRIC TEXT:${_electric.text.replaceAll(RegExp(r'\.\d+'), '').replaceAll(',', '')}");
                      }
                      // cmoney.text = int.parse(string.text.toString());
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text("Ghi chú: tiền điện được chia đều 5 người")
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Huỷ'),
                onPressed: () {
                  _electric.clear();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Nhập'),
                onPressed: () async {
                  electric[hashYear(displayYear)][displayMonth] = int.parse(
                      _electric.text
                          .replaceAll(RegExp(r'\.\d+'), '')
                          .replaceAll(',', ''));
                  final fileElectric = await _localElectric;
                  fileElectric.writeAsStringSync(jsonEncode(electric));
                  _electric.clear();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

  void editWater() => showDialog(
        context: context,
        builder: (BuildContext context) {
          // String people = getPeople(getPeople(records[id]["people"]));

          return AlertDialog(
            title: const Text('Tiền nước'),
            content: Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Nhập tiền nước (VND)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    controller: _water,
                    keyboardType: TextInputType.number,
                    onChanged: (string) {
                      string = _formatNumber(string.replaceAll(',', ''));
                      if (string.isNotEmpty) {
                        // print("STRING: $string");
                        _water.value = TextEditingValue(
                          text: string,
                          selection:
                              TextSelection.collapsed(offset: string.length),
                        );
                        print(
                            "WATER TEXT:${_water.text.replaceAll(RegExp(r'\.\d+'), '').replaceAll(',', '')}");
                      }
                      // cmoney.text = int.parse(string.text.toString());
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text("Ghi chú: tiền nước được chia đều 5 người")
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Huỷ'),
                onPressed: () {
                  _water.clear();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Nhập'),
                onPressed: () async {
                  water[hashYear(displayYear)][displayMonth] = int.parse(_water
                      .text
                      .replaceAll(RegExp(r'\.\d+'), '')
                      .replaceAll(',', ''));
                  final fileWater = await _localWater;
                  fileWater.writeAsStringSync(jsonEncode(water));
                  _water.clear();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

  void editMotorFee() => showDialog(
        context: context,
        builder: (BuildContext context) {
          // String people = getPeople(getPeople(records[id]["people"]));

          return AlertDialog(
            title: const Text('Tiền gửi xe'),
            content: Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Nhập tiền gủi xe (VND)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    controller: _bike,
                    keyboardType: TextInputType.number,
                    onChanged: (string) {
                      string = _formatNumber(string.replaceAll(',', ''));
                      if (string.isNotEmpty) {
                        // print("STRING: $string");
                        _bike.value = TextEditingValue(
                          text: string,
                          selection:
                              TextSelection.collapsed(offset: string.length),
                        );
                        print(
                            "MOTOR FEE TEXT:${_bike.text.replaceAll(RegExp(r'\.\d+'), '').replaceAll(',', '')}");
                      }
                      // cmoney.text = int.parse(string.text.toString());
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                      "Ghi chú: Tiền xe được tính theo người đăng kí gửi xe")
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Huỷ'),
                onPressed: () {
                  _bike.clear();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Nhập'),
                onPressed: () async {
                  motorFee[hashYear(displayYear)][displayMonth] = int.parse(
                      _bike.text
                          .replaceAll(RegExp(r'\.\d+'), '')
                          .replaceAll(',', ''));
                  final fileFee = await _localMotorFee;
                  fileFee.writeAsStringSync(jsonEncode(motorFee));
                  _bike.clear();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

  void showTotalEach() => showDialog(
        context: context,
        builder: (BuildContext context) {
          int house_elec_water = house[hashYear(displayYear)][displayMonth] +
              (electric[hashYear(displayYear)][displayMonth] ~/ 5) +
              (water[hashYear(displayYear)][displayMonth] ~/ 5);
          return AlertDialog(
            title: const Text('Tiền nhà mỗi người đóng'),
            content: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text("Phong"),
                    trailing: motors[hashYear(displayYear)][displayMonth][0]
                        ? Text(currencyFormatter.format(house_elec_water +
                            motorFee[hashYear(displayYear)][displayMonth]))
                        : Text(currencyFormatter.format(house_elec_water)),
                  ),
                  ListTile(
                    title: Text("Tùng"),
                    trailing: motors[hashYear(displayYear)][displayMonth][1]
                        ? Text(currencyFormatter.format(house_elec_water +
                            motorFee[hashYear(displayYear)][displayMonth]))
                        : Text(currencyFormatter.format(house_elec_water)),
                  ),
                  ListTile(
                    title: Text("Lâm"),
                    trailing: motors[hashYear(displayYear)][displayMonth][2]
                        ? Text(currencyFormatter.format(house_elec_water +
                            motorFee[hashYear(displayYear)][displayMonth]))
                        : Text(currencyFormatter.format(house_elec_water)),
                  ),
                  ListTile(
                    title: Text("Hiển"),
                    trailing: motors[hashYear(displayYear)][displayMonth][3]
                        ? Text(currencyFormatter.format(house_elec_water -
                            house[hashYear(displayYear)][displayMonth] +
                            motorFee[hashYear(displayYear)][displayMonth]))
                        : Text(currencyFormatter.format(house_elec_water -
                            house[hashYear(displayYear)][displayMonth])),
                  ),
                ],
              ),
            ),
          );
        },
      );

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
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
}
