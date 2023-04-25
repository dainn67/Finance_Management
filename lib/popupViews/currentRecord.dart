import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data.dart';

class currentRecordView extends StatefulWidget {
  int index, type, buyer;
  String people, date;

  currentRecordView(this.index, this.type, this.buyer, this.people, this.date,
      {super.key});

  @override
  _currentRecordViewState createState() => _currentRecordViewState();
}

class _currentRecordViewState extends State<currentRecordView> {
  late TextEditingController cname, cmoney;
  final currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
  static const _locale = 'en';

  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();

  bool isChanged = false;

  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));

  late int type;
  late int buyer;
  List<bool> people = [false, false, false, false, false];
  late DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    type = widget.type;
    buyer = widget.buyer;
    for (int i = 0; i < widget.people.length; i++) {
      if (widget.people[i] == '1') people[i] = true;
    }
    DateFormat format = DateFormat('dd/MM/yyyy');
    _selectedDate = format.parse(widget.date);
    cname = TextEditingController();
    cmoney = TextEditingController();
  }

  @override
  void dispose() {
    cname.dispose();
    cmoney.dispose();
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final records = Provider.of<Record_Provider>(context, listen: false).records;

    final authData = Provider.of<Authen_Provider>(context, listen: false);
    final authToken = authData.token;
    final userId = authData.userId;

    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            Center(
              child: Text("Record detail",
                  style: GoogleFonts.firaSans(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.lightBlue[100],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  typeSelection(),
                  const SizedBox(height: 15),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Name: ${records[widget.index].name}',
                      // labelText: 'Record\'s name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    controller: cname,
                    onChanged: (string) {
                      isChanged = true;
                      // print("CNAME TEXT: ${cname.text}");
                    },
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      hintText:
                          'Amount: ${_formatNumber(records[widget.index].money.toString())}',
                      // labelText: 'Amount (vnd)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    controller: cmoney,
                    keyboardType: TextInputType.number,
                    onChanged: (string) {
                      isChanged = true;
                      string = _formatNumber(string.replaceAll(',', ''));
                      if (string.isNotEmpty) {
                        // print("STRING: $string");
                        cmoney.value = TextEditingValue(
                          text: string,
                          selection:
                              TextSelection.collapsed(offset: string.length),
                        );
                        print("NEW TEXT:${cmoney.text}");
                      }
                    },
                  ),
                  const SizedBox(height: 15),
                  const Text("Purchaser",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  const SizedBox(height: 10),
                  payerSelection(),
                  const SizedBox(height: 20),
                  const Center(
                      child: Text("User(s)",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20))),
                  selectUsers(),
                ],
              ),
            ),
            const SizedBox(height: 5),
            displayDate(),
            const SizedBox(height: 1),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    // state.changeLoading();
                    update_record(widget.index, authToken!, userId!);
                    // .then((_) {
                    //   // state.changeLoading();
                    // }).catchError((err) {
                    //   // Navigator.of(context).pop();
                    //   print("ERROR (ELEVATED BUTTON): $err");
                    // });
                  },
                  child: isChanged ? const Text("Change") : const Text("OK")),
            ),
          ],
        ));
  }

  CupertinoSlidingSegmentedControl typeSelection() {
    return CupertinoSlidingSegmentedControl(
      groupValue: type,
      children: {
        1: Builder(
          builder: (context) => SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: const Center(
              child: Text(
                'Food & Drinks',
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
                'Stationery',
                style: TextStyle(color: Colors.purple),
              ),
            ),
          ),
        )
      },
      onValueChanged: (value) {
        setState(() {
          isChanged = true;
          type = value!;
          print('type: $type');
          if (value == 2) {
            setState(() {
              for (int i = 0; i < 5; i++) {
                people[i] = true;
              }
            });
          } else {
            setState(() {
              for (int i = 0; i < 5; i++) {
                people[i] = false;
              }
            });
          }
        });
      },
    );
  }

  CupertinoSlidingSegmentedControl payerSelection() {
    return CupertinoSlidingSegmentedControl(
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
          isChanged = true;
          buyer = value!;
          setState(() {});
          print('buyer: $buyer');
        });
      },
    );
  }

  Column selectUsers() {
    return Column(
      children: [
        CheckboxListTile(
          title: const Text('Phong'),
          value: people[0],
          onChanged: (bool? value) {
            setState(() {
              isChanged = true;
              people[0] = value!;
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Khánh'),
          value: people[1],
          onChanged: (bool? value) {
            setState(() {
              isChanged = true;
              people[1] = value!;
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Tùng'),
          value: people[2],
          onChanged: (bool? value) {
            setState(() {
              isChanged = true;
              people[2] = value!;
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Lâm'),
          value: people[3],
          onChanged: (bool? value) {
            setState(() {
              isChanged = true;
              people[3] = value!;
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Hiển'),
          value: people[4],
          onChanged: (bool? value) {
            setState(() {
              isChanged = true;
              people[4] = value!;
            });
          },
        ),
      ],
    );
  }

  Center displayDate() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.calendar_today),
          const SizedBox(width: 8),
          Text(
              "Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(width: 16.0),
          TextButton(
              onPressed: () async {
                _selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2025),
                ) as DateTime;
                setState(() {
                  isChanged = true;
                });
              },
              child: const Text(
                "Change",
                style: TextStyle(fontSize: 18.0),
              )),
        ],
      ),
    );
  }

  void update_record(int index, String authToken, String userId) {
    print(
        'DATA:\n${cname.text}\n${cmoney.text}\n$people\n${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}\n$buyer\n$type');
    try{
      final data = Provider.of<Record_Provider>(context, listen: false);

      int money = 0;
      if(cmoney.text.isNotEmpty) {
        money = int.parse(cmoney.text
            .replaceAll(RegExp(r'\.\d+'), '')
            .replaceAll(',', '')
            .toString());
      }

      String _people = "";
      for (int i = 0; i < people.length; i++) {
        if (people[i]) {
          _people = "${_people}1";
        } else {
          _people = '${_people}0';
        }
      }

      //update & refund logic
      // if (type == 2) {
      //   totalStationery += money;
      // } else {
      //   totalFood += money;
      // }

      // computeExpenses(money, int.parse(getNumberOfPeople(_people)), _people,
      //     buyer, _selectedDate.month, _selectedDate.year);

      //SEND HTTP REQUEST
      // final uri = Uri.parse(
      //     'https://phong-s-app-default-rtdb.firebaseio.com/records/${data.records[index].id}.json?$authToken');
      final uri = Uri.parse(
          'https://phong-s-app-default-rtdb.firebaseio.com/useronly/$userId/${data.records[index].id}.json?$authToken');
      http.patch(uri,
          body: json.encode({
            'name': cname.text.isNotEmpty ? cname.text : data.records[widget.index].name,
            'money': cmoney.text.isNotEmpty ? money : data.records[widget.index].money,
            'date': '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
            'by': buyer,
            'type': type,
            'people': _people,
          }));
      print('Patch done');
      data.fetchRecord();

      //   // json.decode(res.body) is recommended to be used as id of record, so that when user need to DELETE
      //   // a record, we need to use that id to identify

      cname.clear();
      cmoney.clear();
      // Navigator.of(context).pop();
    } catch (err){
      print(err);
      rethrow;
    } finally {
      Navigator.of(context).pop();
    }
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
    // print("AFTER: $moneyToPayy");
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
}
