import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:io';

import '../data.dart';

class addNewRecordView extends StatefulWidget {
  const addNewRecordView({super.key});

  @override
  _addNewRecordViewState createState() => _addNewRecordViewState();
}

class _addNewRecordViewState extends State<addNewRecordView> {
  late TextEditingController cname, cmoney;
  DateTime _selectedDate = DateTime.now();
  final currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imgFocusNode = FocusNode();

  // bool isLoading = false;

  var data = {'name': '', 'title': '', 'desc': '', 'imgURL': ''};

  static const _locale = 'en';

  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));

  int type = 1;
  int buyer = 1;
  List<bool> people = [false, false, false, false, false];

  @override
  void initState() {
    super.initState();
    cname = TextEditingController();
    cmoney = TextEditingController();

    _imgFocusNode.addListener(_updateImgURL);
  }

  void _updateImgURL() {
    if (!_imgFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    cname.dispose();
    cmoney.dispose();
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imgFocusNode.removeListener(_updateImgURL);
    _imgFocusNode.dispose();
    super.dispose();
  }

  @override
  // Widget build(BuildContext context) {
  //   return Form(
  //     key: _form,
  //       child: Padding(
  //     padding: const EdgeInsets.all(16.0),
  //     child: ListView(
  //       children: <Widget>[
  //         Container(
  //           decoration: const BoxDecoration(
  //             color: Colors.lightBlueAccent,
  //             borderRadius: BorderRadius.all(Radius.circular(5.0)),
  //           ),
  //           child: const Padding(
  //             padding: EdgeInsets.all(8.0),
  //             child: Center(
  //               child: Text(
  //                 "NEW RECORD",
  //                 style: TextStyle(
  //                   fontSize: 20.0,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //         const SizedBox(height: 20),
  //         TextFormField(
  //           decoration: const InputDecoration(labelText: 'Record Name', err),
  //           textInputAction: TextInputAction.next,
  //           onFieldSubmitted: (_) {
  //             FocusScope.of(context).requestFocus(_priceFocusNode);
  //           },
  //           onSaved: (value) {
  //             print(value);
  //           },
  //           validator: (val) {
  //             if(val != null && val.isEmpty) return 'Enter name';
  //             else return null;
  //           },
  //         ),
  //         TextFormField(
  //           decoration: const InputDecoration(labelText: 'Money'),
  //           keyboardType: TextInputType.number,
  //           textInputAction: TextInputAction.next,
  //           focusNode: _priceFocusNode,
  //           onFieldSubmitted: (_) {
  //             FocusScope.of(context).requestFocus(_descFocusNode);
  //           },
  //         ),
  //         TextFormField(
  //           decoration: const InputDecoration(labelText: 'Description'),
  //           maxLines: 3,
  //           keyboardType: TextInputType.multiline,
  //           focusNode: _descFocusNode,
  //         ),
  //         Row(
  //           crossAxisAlignment: CrossAxisAlignment.end,
  //           children: <Widget>[
  //             Container(
  //               width: 100,
  //               height: 100,
  //               margin: const EdgeInsets.only(top: 8, right: 10),
  //               decoration: BoxDecoration(
  //                   border: Border.all(width: 1, color: Colors.grey)),
  //               child: _imgURLController.text.isEmpty
  //                   ? const Text("Enter an URL")
  //                   : FittedBox(
  //                       fit: BoxFit.cover,
  //                       child: Image.network(_imgURLController.text),
  //                     ),
  //             ),
  //             Expanded(
  //               child: TextFormField(
  //                 decoration: const InputDecoration(labelText: 'ImageURL'),
  //                 keyboardType: TextInputType.url,
  //                 textInputAction: TextInputAction.done,
  //                 controller: _imgURLController,
  //                 focusNode: _imgFocusNode,
  //                 onFieldSubmitted: (_) {
  //                   saveForm();
  //                 },
  //               ),
  //             )
  //           ],
  //         ),
  //         Center(
  //           child: ElevatedButton(
  //               onPressed: () async {
  //                 // submit_done();
  //                 saveForm();
  //                 setState(() {});
  //               },
  //               child: const Text("Add")),
  //         ),
  //       ],
  //     ),
  //   ));
  // }
  // void saveForm() {
  //   bool isValid = false;
  //   if(_form.currentState?.validate() == null) isValid = false;
  //   else isValid = _form.currentState?.validate();
  //   if(isValid == true) _form.currentState?.save();
  //   else return;
  // }

  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            const SizedBox(height: 50.0),
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.lightBlue[100],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  CupertinoSlidingSegmentedControl(
                    groupValue: type,
                    children: {
                      1: Builder(
                        builder: (context) => SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: const Center(
                            child: Text(
                              'Đồ ăn',
                              style: TextStyle(color: Colors.purple),
                            ),
                          ),
                        ),
                      ),
                      2: Builder(
                        builder: (context) => SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: const Center(
                            child: Text(
                              'Đồ gia dụng',
                              style: TextStyle(color: Colors.purple),
                            ),
                          ),
                        ),
                      )
                    },
                    onValueChanged: (value) {
                      setState(() {
                        type = value!;
                        if (value == 2) {
                          setState(() {
                            for (int i = 0; i < 5; i++) people[i] = true;
                          });
                        } else {
                          setState(() {
                            for (int i = 0; i < 5; i++) people[i] = false;
                          });
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Tên chi tiêu',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    controller: cname,
                    onChanged: (string) {
                      print("CNAME TEXT: ${cname.text}");
                    },
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Số tiền (VND)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    controller: cmoney,
                    keyboardType: TextInputType.number,
                    onChanged: (string) {
                      string = _formatNumber(string.replaceAll(',', ''));
                      if (string.isNotEmpty) {
                        // print("STRING: $string");
                        cmoney.value = TextEditingValue(
                          text: string,
                          selection:
                              TextSelection.collapsed(offset: string.length),
                        );
                        print(
                            "CMONEY TEXT:${cmoney.text.replaceAll(RegExp(r'\.\d+'), '').replaceAll(',', '')}");
                      }
                      // cmoney.text = int.parse(string.text.toString());
                    },
                  ),
                  const SizedBox(height: 15),
                  const Text("Người thanh toán",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  const SizedBox(height: 10),
                  CupertinoSlidingSegmentedControl(
                    groupValue: buyer,
                    children: {
                      1: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: const Center(
                          child: Text('Phong'),
                        ),
                      ),
                      2: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: const Center(
                          child: Text('Khánh'),
                        ),
                      ),
                      3: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: const Center(
                          child: Text('Tùng'),
                        ),
                      ),
                      4: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: const Center(
                          child: Text('Lâm'),
                        ),
                      ),
                      5: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: const Center(
                          child: Text('Hiển'),
                        ),
                      ),
                    },
                    onValueChanged: (value) {
                      setState(() {
                        buyer = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  const Center(
                      child: Text("Người ăn",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20))),
                  CheckboxListTile(
                    title: const Text('Phong'),
                    value: people[0],
                    onChanged: (bool? value) {
                      setState(() {
                        people[0] = value!;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Khánh'),
                    value: people[1],
                    onChanged: (bool? value) {
                      setState(() {
                        people[1] = value!;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Tùng'),
                    value: people[2],
                    onChanged: (bool? value) {
                      setState(() {
                        people[2] = value!;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Lâm'),
                    value: people[3],
                    onChanged: (bool? value) {
                      setState(() {
                        people[3] = value!;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Hiển'),
                    value: people[4],
                    onChanged: (bool? value) {
                      setState(() {
                        people[4] = value!;
                      });
                    },
                  ),
                  //
                ],
              ),
            ),
            const SizedBox(height: 5),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 8),
                    Text(
                        "Ngày: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 16.0),
                    TextButton(
                        onPressed: () async {
                          _selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2025),
                          ) as DateTime;
                          setState(() {});
                        },
                        child: const Text(
                          "Thay đổi",
                          style: TextStyle(fontSize: 18.0),
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 1),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    isLoading = true;
                    submit_done().then((_) {
                      isLoading = false;
                    });
                  },
                  child: const Text("Thêm")),
            ),
          ],
        ));
  }

  Future<void> submit_done() async {
    Provider.of<Record_Provider>(context, listen: false).addRecord();
    // setState(() {
    //   // int money = int.parse(cmoney.text
    //   //     .replaceAll(RegExp(r'\.\d+'), '')
    //   //     .replaceAll(',', '')
    //   //     .toString());
    //   // String _people = "";
    //   // for (int i = 0; i < people.length; i++) {
    //   //   if (people[i]) {
    //   //     _people = _people + "1";
    //   //   } else {
    //   //     _people = _people + '0';
    //   //   }
    //   // }
    //   //
    //   // var temp = {
    //   //   "name": cname.text.toString(),
    //   //   "money": money,
    //   //   "date":
    //   //       "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
    //   //   "by": buyer,
    //   //   "type": type,
    //   //   "people": _people
    //   // };
    //
    //   var debugTemp = {
    //     "name": "Random name",
    //     "money": 100000,
    //     "date": "1/1/1111",
    //     "by": 2,
    //     "type": 2,
    //     "people": "11111"
    //   };
    //
    //   var _record = Record('RandomName', 100000, '1/1/1111', 2, 2, '11111');
    //
    //   // records.add(temp);
    //
    //   //SEND HTTP REQUEST
    //   var url = Uri.parse(
    //       'https://phong-s-app-default-rtdb.firebaseio.com/records.json');
    //   http
    //       .post(url,
    //           body: json.encode({
    //             'name': _record.name,
    //             'money': _record.money,
    //             'date': _record.date,
    //             'by': _record.by,
    //             'type': _record.type,
    //             'people': _record.people,
    //           }))
    //       .then((res) {
    //     records.add(debugTemp);
    //
    //     print(json.decode(res.body));
    //     // json.decode(res.body) is recommended to be used as id of record, so that when user need to DELETE
    //     // a record, we need to use that id to identify
    //
    //     if (type == 2) {
    //       // totalStationery += money;
    //       totalStationery += 100000;
    //     } else {
    //       // totalFood += money;
    //       totalFood += 100000;
    //     }
    //
    //     // computeExpenses(money, int.parse(getNumberOfPeople(_people)), _people, buyer, _selectedDate.month, _selectedDate.year);
    //     computeExpenses(100000, 5, "11111", 2, 4, 2023);
    //
    //     widget.functionCaller();
    //
    //     jsonRecord = "";
    //     for (int i = 0; i < records.length; i++) {
    //       if (i == 0) {
    //         jsonRecord = "[${jsonEncode(records[i])}";
    //       } else {
    //         jsonRecord = "$jsonRecord, ${jsonEncode(records[i])}";
    //       }
    //     }
    //     jsonRecord += ']';
    //     writeData();
    //   });
    // });

    cname.clear();
    cmoney.clear();
  }

  void computeExpenses(int money, int numberOfPeople, String people, int buyer,
      int month, int year) {
    //1:2023  2:2024  3:2025  4:2026 // tháng tương tự số // 1-Phong 2-Tùng  3-Lâm  4-Hiển
    //buyer: 1-P  2-K 3-T 4-L 5-H
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

    //people là 1 string 0-based, moneyToPayy[hashYear [month]là 1-based
    if (buyer == 2 ||
        (buyer == 1 && people[0] == '1') ||
        people[buyer - 1] == '1') {
      //nếu người mua có ăn
      if (buyer == 2) {
        //Khanh mua
        if (people[0] == '1')
          moneyToPayy[hashYear][month][1] +=
              getEqualMoney(money, numberOfPeople);
        for (int i = 2; i <= 4; i++)
          if (people[i] == '1')
            moneyToPayy[hashYear][month][i] +=
                getEqualMoney(money, numberOfPeople);
      } else if (buyer == 1) {
        //Phong mua
        moneyToPayy[hashYear][month][buyer] -=
            getEqualMoney(money, numberOfPeople) * (numberOfPeople - 1);
        for (int i = 2; i <= 4; i++)
          if (people[i] == '1')
            moneyToPayy[hashYear][month][i] +=
                getEqualMoney(money, numberOfPeople);
      } else {
        //Tung/Lam/Hien mua
        moneyToPayy[hashYear][month][buyer - 1] -=
            getEqualMoney(money, numberOfPeople) * (numberOfPeople - 1);
        if (people[0] == '1')
          moneyToPayy[hashYear][month][1] +=
              getEqualMoney(money, numberOfPeople);
        for (int i = 2; i <= 4; i++) {
          if (i != buyer - 1 && people[i] == '1')
            moneyToPayy[hashYear][month][i] +=
                getEqualMoney(money, numberOfPeople);
        }
      }
    } else {
      //nếu người mua ko ăn
      if (buyer == 1) {
        // Phong mua
        moneyToPayy[hashYear][month][1] -= money;
        for (int i = 2; i <= 4; i++) {
          if (people[i] == '1')
            moneyToPayy[hashYear][month][i] +=
                getEqualMoney(money, numberOfPeople);
        }
      } else if (buyer == 2) {
        //Khánh mua
        if (people[0] == '1')
          moneyToPayy[hashYear][month][1] +=
              getEqualMoney(money, numberOfPeople);
        for (int i = 2; i <= 4; i++)
          if (people[i] == '1')
            moneyToPayy[hashYear][month][i] +=
                getEqualMoney(money, numberOfPeople);
      } else {
        //3 người còn lại mua
        moneyToPayy[hashYear][month][buyer - 1] -= money;
        if (people[0] == '1')
          moneyToPayy[hashYear][month][1] +=
              getEqualMoney(money, numberOfPeople);
        for (int i = 2; i <= 4; i++)
          if (people[i] == '1' && i != buyer - 1)
            moneyToPayy[hashYear][month][i] +=
                getEqualMoney(money, numberOfPeople);
      }
    }
    print("AFTER: $moneyToPayy");
  }

  int getEqualMoney(int money, int numberOfPeople) {
    return money ~/ numberOfPeople;
  }

  String getPeople(String s) {
    String res = "";
    print("STRING IS: ${s[3]}");
    if (s[0] == '1') res = res + "Phong";
    if (s[1] == '1') res = res + " Khánh";
    if (s[2] == '1') res = res + " Tùng";
    if (s[3] == '1') res = res + " Lâm";
    if (s[4] == '1') res = res + " Hiển";
    print(res);
    return res;
  }

  String getNumberOfPeople(String s) {
    int count = 0;
    for (int i = 0; i < s.length; i++) {
      if (s[i] == '1') count++;
    }
    return "$count";
  }

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

  Future<void> writeData() async {
    final fileRecords = await _localRecords;
    fileRecords.writeAsStringSync(jsonRecord.toString());

    final fileStation = await _localTotalStationery;
    fileStation.writeAsString('$totalStationery');

    final fileFood = await _localTotalFood;
    fileFood.writeAsString('$totalFood');

    final fileSummary = await _localTotalSummary;
    fileSummary.writeAsString(jsonEncode(moneyToPayy));
  }
}
